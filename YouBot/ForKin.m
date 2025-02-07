function pe = ForKin(p0, q)

dh_table = [pi/2   0.1013     0.0330      q(1)+pi/2
             0         0        0.1550      q(2)+pi/2
             0         0        0.1348     q(3)
             -pi/2   -0.019       0         q(4)-pi/2
             0       0.1937       0         q(5) + pi/2]; 

    T01 = TransKuka(dh_table(1,:));
    T12 = TransKuka(dh_table(2,:));
    T23 = TransKuka(dh_table(3,:));
    T34 = TransKuka(dh_table(4,:));
    T45 = TransKuka(dh_table(5,:));

    Te = T01*T12*T23*T34*T45;

    pe = Te(1:3,4) + p0;



end