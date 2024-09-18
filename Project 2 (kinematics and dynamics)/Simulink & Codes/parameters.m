clc
clear all
close all
syms b1 theta2 theta3 b4
syms b1_dot theta2_dot theta3_dot b4_dot b1_ddot theta2_ddot theta3_ddot b4_ddot

%% Physical Data
% Link0
mass_link0 = 0.8;
com_link0_ros = [0.0000000e+00 0.0000000e+00 0.0000000e+00]';
I0_ros = [0.44 , 0.0           , 0.0
            0.0         ,  0.003, 0.0
         0.0 ,  0.0          , 0.44];
% Link1
mass_link1 = 0.8;
com_link1_ros = [0.15 0.08 0.1]';
I1_ros = [2000 , 2.0           , 160
            2.0         ,  3000, 1.0
         160 ,  1.0          , 2000].*(10^(-6));
% Link2
mass_link2 = 1.2;
com_link2_ros = [0.35 0.1 0.25]';
I2_ros = [1600 , -0.25, -1200
     -0.25,  30000, 0.05
     -1200,  0.05, 30000].*(10^(-6));
% Link3
mass_link3 = 0.85;
com_link3_ros = [0.45 0.1 0.3]';
I3_ros = [6000, -0.3, 1300
      -0.3, 15000, -0.3
     1300, -0.3, 12000].*(10^(-6));
% Link4
mass_link4 = 0.15;
com_link4_ros = [0.65 0.02 0.4]';
I4_ros = [3000, 0.07, 0.04
         0.07,  3000,  0.1
         0.04,  0.1,  20].*(10^(-6));

%% Change Varibales
I0 =  I0_ros ;
com0 =  com_link0_ros;
I1 = I1_ros;
com1 = com_link1_ros;
I2 = I2_ros ;
com2 =  com_link2_ros;
I3 =  I3_ros;
com3 = com_link3_ros;
I4 =  I4_ros ;
com4 =  com_link4_ros;
%% Theta
q = [ b1 ; theta2 ; theta3 ; b4 ];
q_dot = [ b1_dot ; theta2_dot; theta3_dot ; b4_dot];
q_ddot = [ b1_ddot ; theta2_ddot; theta3_ddot ; b4_ddot];

%% Displacements

disp_link0_joint1 =[0;0;0.0735];         % + rot_x -90
disp_joint1_link1 =[-0.2;0;0];              % + rot_x  90
disp_link1_joint2 =[0.2;0.08;0.078];        
disp_joint2_link2 =[-0.073;-0.083;-0.079];
disp_link2_joint3 =[0.47;0.09;0.2];
disp_joint3_link3 =[-0.4;-0.09;-0.2];
disp_link3_joint4 =[0.65;0.07;0.28];
disp_joint4_link4 =[-0.65;0;-0.345];

%% D-H Form
% T = [Q,P;0,1];
% Com_dh = T*Com_link
% I_dh = Q*I*Q'

Alpha = [pi/2, 0, 0, 0];
Theta = [0, theta2, theta3, 0];

% link0 -> joint1
T = [Qx(-pi/2),disp_link0_joint1;
    [0,0,0,1]]*[eye(3),[0;0;b1];
    [0,0,0,1]];
a1 = T*[0;0;0;1];
a1 = a1(1:3);
Q01 = T(1:3,1:3);

% joint1 -> link1
T = T*[Qx(pi/2),disp_joint1_link1;
    [0,0,0,1]];
com1_dh = T*[com1;1];
com1_dh = com1_dh(1:3);
I1_dh = T(1:3,1:3)*(I1+mass_link1*(T(1:3,4).'*T(1:3,4)*eye(3)-T(1:3,4)*T(1:3,4).'))/T(1:3,1:3);

% link1 -> joint2
T = T*[eye(3),disp_link1_joint2;[0,0,0,1]]*[Qfunc(2,Theta,Alpha),[0;0;0];[0,0,0,1]];
a2 = T*[0;0;0;1];
a2 = a2(1:3);
Q012 = T(1:3,1:3);

% joint2 -> link2
T = T*[eye(3),disp_joint2_link2;
    [0,0,0,1]];
com2_dh = T*[com2;1];
com2_dh = com2_dh(1:3);
I2_dh = T(1:3,1:3)*(I2+mass_link2*(T(1:3,4).'*T(1:3,4)*eye(3)-T(1:3,4)*T(1:3,4).'))/T(1:3,1:3);

% link2 -> joint3
T = T*[eye(3),disp_link2_joint3;[0,0,0,1]]*[Qfunc(3,Theta,Alpha),[0;0;0];[0,0,0,1]];
a3 = T*[0;0;0;1];
a3 = a3(1:3);
Q0123 = T(1:3,1:3);

% joint3 -> link3
T = T*[eye(3),disp_joint3_link3;[0,0,0,1]];
com3_dh = T*[com3;1];
com3_dh = com3_dh(1:3);
I3_dh = T(1:3,1:3)*(I3+mass_link3*(T(1:3,4).'*T(1:3,4)*eye(3)-T(1:3,4)*T(1:3,4).'))/T(1:3,1:3);

% link3 -> joint4
T = T*[eye(3),disp_link3_joint4;[0,0,0,1]]*[eye(3),[0;0;b4];[0,0,0,1]];
a4 = T*[0;0;0;1];
a4 = a4(1:3);
Q01234 = T(1:3,1:3);

% joint4 -> link4
T = T*[eye(3),disp_joint4_link4;[0,0,0,1]];
com4_dh = T*[com4;1];
com4_dh = com4_dh(1:3);
I4_dh = T(1:3,1:3)*(I4+mass_link4*(T(1:3,4).'*T(1:3,4)*eye(3)-T(1:3,4)*T(1:3,4).'))/T(1:3,1:3);


%% First dot

%Rotation Axis
zero=[0;0;0];
z=[0;0;1];
e11=Q01*z;
e21=Q012*z;
e31=Q0123*z;
e41=Q01234*z;


Q0 = Qx(-pi/2);
Q1 = inv(Q0)*Q01;
Q2 = inv(Q0 * Q1)*Q012;
Q3 = inv(Q0 * Q1 * Q2)*Q0123;
Q4 = inv(Q0 * Q1 * Q2 * Q3)*Q01234;


e22 = inv(Q0 * Q1) * e21;
e33 = inv(Q0 * Q1 * Q2) * e31;
e44 = inv(Q0 * Q1 * Q2 * Q3) * e41;

%r_ij
r11 =   com1_dh -a1;                 

r12 =   com2_dh -a1;
r22 =   com2_dh -a2 ;

r13 =   com3_dh - a1;
r23 =   com3_dh - a2;
r33 =   com3_dh - a3;

r14 =   com4_dh - a1;
r24 =   com4_dh - a2 ;
r34 =   com4_dh - a3 ;
r44 =   com4_dh - a4 ;

% Ni in world frame
N1 = [e11       zero      zero            zero];
N2 = [e11  cross(e21,r22)  zero            zero];
N3 = [e11  cross(e21,r23)  cross(e31,r33)   zero];
N4 = [e11  cross(e21,r24)  cross(e31,r34)   e41 ];

% Wi in i th frame <=== Ii in i th frame

W1 = [zero     zero      zero     zero];
W2 = [zero     e22        zero     zero];
W3 = [zero    (Q2') * e22           e33      zero];
W4 = [zero    (Q3') * (Q2') * e22      (Q3') * e33      zero];


%% Final calculation



% Mass Matrix
M1 = mass_link1 * N1'*N1 + W1'*I1_dh*W1;
M2 = mass_link2 * N2'*N2 + W2'*I2_dh*W2;
M3 = mass_link3 * N3'*N3 + W3'*I3_dh*W3;
M4 = mass_link4 * N4'*N4 + W4'*I4_dh*W4;
M = M1 + M2 + M3 + M4  ;

% Kinetic Energy
T = 0.5*q_dot'*M*q_dot;

%hi all in world frame
h1 =  (r11)'*z;
h2 =  (r12)'*z;
h3 =  (r13)'*z;
h4 =  (r14)'*z;

% Potential Energy
g = 9.81;
V1 = mass_link1 *g*h1;
V2 = mass_link2 *g*h2;
V3 = mass_link3 *g*h3;
V4 = mass_link4 *g*h4;
V = V1 + V2 + V3 + V4 ;

%% Euler-Lagrange
Fb1 = sym(0);
Tt2 = sym(0);
Tt3 = sym(0);
Fb4 = sym(0);
L=T-V;

j = jacobian(diff(L,b1_dot),[b4,b1_dot,theta2_dot,theta3_dot,b4_dot]);
Fb1 = j(1)*b4_dot+j(2)*b1_ddot+j(3)*theta2_ddot+j(4)*theta3_ddot+j(5)*b4_ddot-diff(L,b1);

j = jacobian(diff(L,theta2_dot),[b4,b1_dot,theta2_dot,theta3_dot,b4_dot]);
Tt2 = j(1)*b4_dot+j(2)*b1_ddot+j(3)*theta2_ddot+j(4)*theta3_ddot+j(5)*b4_ddot-diff(L,theta2);

j = jacobian(diff(L,theta3_dot),[b4,b1_dot,theta2_dot,theta3_dot,b4_dot]);
Tt3 = j(1)*b4_dot+j(2)*b1_ddot+j(3)*theta2_ddot+j(4)*theta3_ddot+j(5)*b4_ddot-diff(L,theta3);

j = jacobian(diff(L,b4_dot),[b4,b1_dot,theta2_dot,theta3_dot,b4_dot]);
Fb4 = j(1)*b4_dot+j(2)*b1_ddot+j(3)*theta2_ddot+j(4)*theta3_ddot+j(5)*b4_ddot-diff(L,b4);

ForceandTorques = [Fb1;Tt2;Tt3;Fb4];
ForceandTorques = simplify(ForceandTorques);

matlabFunction(ForceandTorques,'File','OpenMan_torquesandforce');
