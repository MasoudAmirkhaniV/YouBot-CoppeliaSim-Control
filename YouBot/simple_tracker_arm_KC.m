clc;
clear;
close all;

% Integration Time Step
Ts = 0.05;

Kp = 10;  %  gain
qd0 = 0;  % Initial joint velocity


% Total execution time
T_tot = 30;


% Time vector
tvec = 0:Ts:T_tot;

% Connect to the CoppeliaSim
robot = VrepConnector0(19997, Ts);  
q = robot.GetState();             

tracker_handle = robot.GetObjectHandle('tracker');
p0_handle = robot.GetObjectHandle('youBotArmJoint0');


for i = 1:length(tvec)

    tracker_position = robot.GetObjectPosition(tracker_handle);
    x_real_time = tracker_position(:);
    x_dot_real_time = [0; 0; 0];

    p0_position = robot.GetObjectPosition(p0_handle);
    p0 = p0_position(:);

    q = robot.GetState();     

    % Compute position error
    e = x_real_time - ForKin(p0, q);

    rd = x_dot_real_time + Kp * e;

    qd = InvKin(q, rd, qd0);

    robot.ApplyControl(qd, Ts);
end

robot.Close();
