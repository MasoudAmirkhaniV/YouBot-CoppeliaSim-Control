% Initialize connection
connector = VrepConnector(19997, 0.05);  % 19997 is the default port, 0.05 is the step time

% Define velocity 
velocities = [10.5, 0, 0, 0, 0];  % Velocities for each joint

% Apply control for a period (e.g., 1 second)
connector.ApplyControl(velocities, 1);

jointPositions = connector.GetState();
disp(jointPositions);

% Close the connection
connector.Close();
