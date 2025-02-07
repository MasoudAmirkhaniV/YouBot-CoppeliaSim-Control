function J = Jacob(q)

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

    T02 = T01*T12;
    T03 = T02*T23;
    T04 = T03*T34;
    T05 = T04*T45;

    z0 = [0; 0; 1];
    z1 = T01(1:3,3);
    z2 = T02(1:3,3);
    z3 = T03(1:3,3);
    z4 = T04(1:3,3);

    
    p0 = [0; 0; 0];
    p1 = T01(1:3,4);
    p2 = T02(1:3,4);
    p3 = T03(1:3,4);
    p4 = T04(1:3,4);
    pe = T05(1:3,4);


    Ja = [cross(z0, (pe-p0)) cross(z1, (pe-p1)) cross(z2, (pe-p2)) cross(z3, (pe-p3)) cross(z4, (pe-p4))];
%     Jw = [z0 z1 z2 z3 z4];

    J = Ja;

end