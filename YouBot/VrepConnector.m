classdef VrepConnector
    
    properties
        sim;                % Similar to fd
        clientID;           % Used for server connection and server requests
        robot_joints = [];  % List of joint handles for the manipulator
        wheel_joints = [];  % List of joint handles for the wheels
        step_time_vrep;     % Integration step used for simulation
    end
    
    methods
        function obj = VrepConnector(port, step_time_vrep)
            addpath vrep_lib/;                      % Adding the APIs to the path
            obj.step_time_vrep = step_time_vrep;    
            obj.sim = remApi('remoteApi');          % RemoteAPI object
            obj.sim.simxFinish(-1);
            obj.clientID = obj.sim.simxStart('127.0.0.1', port, true, true, 5000, 5);
            if (obj.clientID > -1)
                disp('Connected to simulator');
            else
                disp('Error in connection');
            end
            % Enable the synchronous mode on the client (integration step on call)
            obj.sim.simxSynchronous(obj.clientID, true);
            % Start the simulation
            obj.sim.simxStartSimulation(obj.clientID, obj.sim.simx_opmode_blocking);

            % Retrieve handles for each manipulator joint (assuming your robot has 5 joints)
            jointNames = {'youBotArmJoint0', 'youBotArmJoint1', 'youBotArmJoint2', 'youBotArmJoint3', 'youBotArmJoint4'};
            for i = 1:5 
                [~, obj.robot_joints(i)] = obj.sim.simxGetObjectHandle(obj.clientID, jointNames{i}, obj.sim.simx_opmode_blocking);
            end
            
            % Retrieve handles for each wheel joint
            wheelNames = {'rollingJoint_rr', 'rollingJoint_rl', 'rollingJoint_fl', 'rollingJoint_fr'};
            for i = 1:4
                [~, obj.wheel_joints(i)] = obj.sim.simxGetObjectHandle(obj.clientID, wheelNames{i}, obj.sim.simx_opmode_blocking);
            end

            % Initialize joint positions streaming for manipulator
            for i = 1:5
                obj.sim.simxGetJointPosition(obj.clientID, obj.robot_joints(i), obj.sim.simx_opmode_streaming);
            end
        end
        
        function Close(obj)
            obj.sim.simxStopSimulation(obj.clientID, obj.sim.simx_opmode_blocking);
            obj.sim.simxFinish(-1);
            obj.sim.delete();
        end
        
        function ApplyControl(obj, qd, delta_t)
            wheel_speeds = qd(1:4);
            u = qd(5:9);
            % Apply control to each manipulator joint with target velocities from vector u
            for i = 1:5
                obj.sim.simxSetJointTargetVelocity(obj.clientID, obj.robot_joints(i), u(i), obj.sim.simx_opmode_oneshot);
            end

            % Apply control to each wheel with target velocities from vector wheel_speeds
            for i = 1:4
                obj.sim.simxSetJointTargetVelocity(obj.clientID, obj.wheel_joints(i), wheel_speeds(i), obj.sim.simx_opmode_oneshot);
            end

            % Trigger synchronous steps for delta_t time period
            for i = 1:(delta_t / obj.step_time_vrep)    % Number of integrations in delta_t
                obj.sim.simxSynchronousTrigger(obj.clientID);  % Triggering the integration
            end
            obj.sim.simxGetPingTime(obj.clientID);           % Synchronizing
        end
        
        function q = GetState(obj)
            % Retrieve the current position of each manipulator joint
            q = zeros(5, 1);
            for i = 1:5
                [~, q(i)] = obj.sim.simxGetJointPosition(obj.clientID, obj.robot_joints(i), obj.sim.simx_opmode_buffer);
            end
        end
        
        function handle = GetObjectHandle(obj, objectName)
            % Retrieve the handle of an object by its name
            [~, handle] = obj.sim.simxGetObjectHandle(obj.clientID, objectName, obj.sim.simx_opmode_blocking);
        end
        
        function position = GetObjectPosition(obj, handle)
            % Retrieve the position of an object
            [~, position] = obj.sim.simxGetObjectPosition(obj.clientID, handle, -1, obj.sim.simx_opmode_streaming);
        end

        function SetObjectPosition(obj, handle, position)
            % Set the position of an object
            obj.sim.simxSetObjectPosition(obj.clientID, handle, -1, position, obj.sim.simx_opmode_oneshot);
        end

        function orientation = GetObjectOrientation(obj, handle)
    % Retrieve the orientation of an object in Euler angles (roll, pitch, yaw)
    [~, orientation] = obj.sim.simxGetObjectOrientation(obj.clientID, handle, -1, obj.sim.simx_opmode_streaming);
end

    end
end
