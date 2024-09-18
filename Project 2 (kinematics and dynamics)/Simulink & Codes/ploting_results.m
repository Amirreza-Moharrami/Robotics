clc
close all
TAUT = TAU';
figure()
%%
% Plot
% title : 'joints torque and force using simscape and dynamic model'


subplot(2,2,1)
plot(out.f1.Time,out.f1.Data,'DisplayName',"Simscape");
hold on
plot(0:Ts_M:tf,TAU(1,:),'DisplayName',"Model");
xlabel('t (s)')
ylabel('f_1 (n.m)')
grid on
hold off
legend

subplot(2,2,2)
plot(out.tau2.Time,out.tau2.Data,'DisplayName',"Simscape");
hold on
plot(0:Ts_M:tf,TAU(2,:),'DisplayName',"Model");
xlabel('t (s)')
ylabel('\tau_2 (n.m)')
grid on
hold off
legend

subplot(2,2,3)
plot(out.tau3.Time,out.tau3.Data,'DisplayName',"Simscape");
hold on
plot(0:Ts_M:tf,TAU(3,:),'DisplayName',"Model");
xlabel('t (s)')
ylabel('\tau_3 (n.m)')
grid on
hold off
legend

subplot(2,2,4)
plot(out.f4.Time,out.f4.Data,'DisplayName',"Simscape");
hold on
plot(0:Ts_M:tf,TAU(4,:),'DisplayName',"Model");
xlabel('t (s)')
ylabel('f_4 (n.m)')
grid on
hold off
legend
