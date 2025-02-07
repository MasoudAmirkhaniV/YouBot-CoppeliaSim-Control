function qd = InvKin(q, rd, qd0)
    J = Jacob(q);
    qd = pinv(J)*rd + (eye(5) - pinv(J)*J)*qd0;

end
