clear all
clc
%% FKP

% Write your code here 

% D-H parametes

syms a2 a3 b1 l2 l3 b4
syms theta2 theta3
a = [0, a2, a3, 0];
b = [b1, l2, l3, b4];
alpha = [pi/2, 0, 0, 0];
theta = [0, theta2, theta3, 0];


% Rotation matrix

for i=1:4
    if(i == 1)
        Q{i} = round(Qfunc(i,theta,alpha));
    else
        Q{i} = Qfunc(i,theta,alpha);
    end
    
    A{i} = afunc(i,a,b,theta);
end

Q0 = round(Qx(-pi/2));

% transition+matrix
Q_EE = Q0 * (Q{1} * Q{2}* Q{3} * Q{4});
Q_EE = simplify(Q_EE);

P_EE = Q0 * (A{1} + Q{1}*A{2} + Q{1}*Q{2}*A{3} + Q{1}*Q{2}*Q{3}*A{4});
P_EE = simplify(P_EE);

Phi = theta2 + theta3;
Phi = simplify(Phi);

% Final Matrix (Q,P,T)

T = [Q_EE,P_EE;zeros(1,3),1];
%% IKP

% Write your code here 
syms x y z phi

eq1 = x == P_EE(1);
eq2 = y == P_EE(2);
eq3 = z == P_EE(3);
eq4 = phi == Phi;

sol = solve([eq1,eq2,eq3,eq4],[b1, theta2, theta3, b4]);

B1 = sol.b1;
Theta2 = sol.theta2;
Theta3 = sol.theta3;
B4 = sol.b4;

% Known parametes
% equations
% solve equations
%% Jacobian

zero = [0;0;0];
e1_1 = [0;0;1];
e2_2 = [0;0;1];
e3_3 = [0;0;1];
e4_4 = [0;0;1];

e1_1 = Q0 * (e1_1);
e2_1 = Q0 * (Q{1} * e2_2);
e3_1 = Q0 * (Q{1} * Q{2} * e3_3);
e4_1 = Q0 * (Q{1} * Q{2} * Q{3}* e4_4);

r2_1 = Q0 * (Q{1}*A{2} + Q{1}*Q{2}*A{3} + Q{1}*Q{2}*Q{3}*A{4});
r3_1 = Q0 * (Q{1}*Q{2}*A{3} + Q{1}*Q{2}*Q{3}*A{4});


JA = [zero , e2_1 , e3_1 , zero];
JB = [e1_1 , cross(e2_1,r2_1) , cross(e3_1,r3_1) , e4_1];

J = simplify([JA;JB]);