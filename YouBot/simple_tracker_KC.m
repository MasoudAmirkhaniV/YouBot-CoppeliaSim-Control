clc;
clear;
close all;

qd = [0; 0; 0; 0; 0; 0; 0; 0; 0];

% Time Step
Ts = 0.01;

Kp = 50;  % gain
qd0 = [0;0;0;0;0;0;0;0;0];  % Initial joint velocity

qd_max = [10; 10; 10; 10; 10; 50; 50; 50; 50];

% Total time
T_tot = 20;


% Time vector
tvec = 0:Ts:T_tot;

robot = VrepConnector(19997, Ts);  
q = robot.GetState();              

tracker_handle = robot.GetObjectHandle('tracker');
p0_handle = robot.GetObjectHandle('youBotArmJoint0');
base_handle = robot.GetObjectHandle('ME_Platfo2_sub1');
x1 = [0; 0; 0];


for i = 1:length(tvec)

    tracker_position = robot.GetObjectPosition(tracker_handle);
    base_orientation = robot.GetObjectOrientation(base_handle);

    theta = base_orientation(3); 


    x_real_time = tracker_position(:);
    x_dot_real_time = (x_real_time - x1)/Ts;
    x1 = x_real_time;

    p0_position = robot.GetObjectPosition(p0_handle);
    p0 = p0_position(:);

    q = robot.GetState();    

    e = x_real_time - ForKin(p0, q);

    rd = x_dot_real_time + Kp * e;


    J_manipulator = Jacob(q);
    Gb = JacobM();

    Jb = [cos(theta), -sin(theta), 0;
           sin(theta), cos(theta), 0
           0            0          1];

    
    JNMM = [Jb*Gb J_manipulator];
    qd = pinv(JNMM)*rd + (eye(9) - pinv(JNMM)*JNMM)*qd0;

    qd = max(min(qd, qd_max), -qd_max);

    robot.ApplyControl(qd, Ts);
end

robot.Close();
