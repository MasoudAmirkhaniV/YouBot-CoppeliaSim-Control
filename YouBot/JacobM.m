function Gb = JacobM()

    % thetad: 4x1 vector of wheel velocities

    % Define necessary parameters
    r = 0.0475;         % wheel radius
    l = 0.47 / 2;       % half of the chassis length
    w = 0.3 / 2;        % half of the chassis width

    Gb = (r / 4) * [1, 1, 1, 1;
                      -1,       1,      1,         -1
                      -1/(l+w)  1/(l+w)  -1/(l+w)  1/(l+w)];