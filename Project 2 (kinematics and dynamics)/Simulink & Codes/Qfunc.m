function Q= Qfunc(i,th,alpha)
Q=[cos(th(i)),-cos(alpha(i))*sin(th(i)),sin(alpha(i))*sin(th(i));...
    sin(th(i)),cos(alpha(i))*cos(th(i)),-sin(alpha(i))*cos(th(i));...
    0,sin(alpha(i)),cos(alpha(i))];
end

