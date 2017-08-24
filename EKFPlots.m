if d==1 
    dirName = 'plots/1-thumb/';
end
if d==2 
    dirName = 'plots/2-index/';
end
if d==3 
    dirName = 'plots/3-middle/';
end
if d==4 
    dirName = 'plots/4-ring/';
end
if d==5 
    dirName = 'plots/5-little/';
end
% %% marker1
% fileName = 'm1_meas';
% figure;
% subplot(3,1,1);
% plot(timeEst,[1000*mdt1i(:,1),1000*mdt1io(:,1)]);
% legend('m1x-meas','m1x-est')
% grid on;
% xlabel('time (sec)');ylabel('(mm)');
% title('m1');
% 
% subplot(3,1,2);
% plot(timeEst,[1000*mdt1i(:,2),1000*mdt1io(:,2)]);
% legend('m1y-meas','m1y-est')
% grid on;
% xlabel('time (sec)');ylabel('(mm)');
% 
% subplot(3,1,3);
% plot(timeEst,[1000*mdt1i(:,3),1000*mdt1io(:,3)]);
% legend('m1z-meas','m1z-est')
% grid on;
% xlabel('time (sec)');ylabel('(mm)');
% saveas(gcf,strcat(dirName,fileName,'.fig'));
% saveas(gcf,strcat(dirName,fileName,'.jpg'));
% 
% %% marker1error
% fileName = 'm1_error';
% figure;
% subplot(3,1,1);
% plot(timeEst,[1000*mdt1i(:,1)-1000*mdt1io(:,1)]);
% legend('m1x-err')
% grid on;
% xlabel('time (sec)');ylabel('(mm)');
% title('m1-err');
% 
% subplot(3,1,2);
% plot(timeEst,[1000*mdt1i(:,2)-1000*mdt1io(:,2)]);
% legend('m1y-err')
% grid on;
% xlabel('time (sec)');ylabel('(mm)');
% 
% subplot(3,1,3);
% plot(timeEst,[1000*mdt1i(:,3)-1000*mdt1io(:,3)]);
% legend('m1z-err')
% grid on;
% xlabel('time (sec)');ylabel('(mm)');
% saveas(gcf,strcat(dirName,fileName,'.fig'));
% saveas(gcf,strcat(dirName,fileName,'.jpg'));

%% marker2
fileName = 'm2_meas';
figure;
subplot(3,1,1);
plot(timeEst,[mdt2i(:,1),mdt2io(:,1)]);
legend('m2x-meas','m2x-est')
grid on;
xlabel('time (sec)');ylabel('(mm)');
title('m2');

subplot(3,1,2);
plot(timeEst,[mdt2i(:,2),mdt2io(:,2)]);
legend('m2y-meas','m2y-est')
grid on;
xlabel('time (sec)');ylabel('(mm)');

subplot(3,1,3);
plot(timeEst,[mdt2i(:,3),mdt2io(:,3)]);
legend('m2z-meas','m2z-est')
grid on;
xlabel('time (sec)');ylabel('(mm)');
saveas(gcf,strcat(dirName,fileName,'.fig'));
saveas(gcf,strcat(dirName,fileName,'.jpg'));


%% marker2error
fileName = 'm2_error';
figure;
subplot(3,1,1);
plot(timeEst,[mdt2i(:,1)-mdt2io(:,1)]);
legend('m2x-err')
grid on;
xlabel('time (sec)');ylabel('(mm)');
title('m2-err');

subplot(3,1,2);
plot(timeEst,[mdt2i(:,2)-mdt2io(:,2)]);
legend('m2y-err')
grid on;
xlabel('time (sec)');ylabel('(mm)');

subplot(3,1,3);
plot(timeEst,[mdt2i(:,3)-mdt2io(:,3)]);
legend('m2z-err')
grid on;
xlabel('time (sec)');ylabel('(mm)');
saveas(gcf,strcat(dirName,fileName,'.fig'));
saveas(gcf,strcat(dirName,fileName,'.jpg'));

nerr2=[norm([mdt2i(:,1)-mdt2io(:,1)]) norm([mdt2i(:,2)-mdt2io(:,2)]) norm([mdt2i(:,3)-mdt2io(:,3)])];


%% marker3
fileName = 'm3_meas';
figure;
subplot(3,1,1);
plot(timeEst,[mdt3i(:,1),mdt3io(:,1)]);
legend('m3x-meas','m3x-est')
grid on;
xlabel('time (sec)');ylabel('(mm)');
title('m3');

subplot(3,1,2);
plot(timeEst,[mdt3i(:,2),mdt3io(:,2)]);
legend('m3y-meas','m3y-est')
grid on;
xlabel('time (sec)');ylabel('(mm)');

subplot(3,1,3);
plot(timeEst,[mdt3i(:,3),mdt3io(:,3)]);
legend('m3z-meas','m3z-est')
grid on;
xlabel('time (sec)');ylabel('(mm)');
saveas(gcf,strcat(dirName,fileName,'.fig'));
saveas(gcf,strcat(dirName,fileName,'.jpg'));


%% marker3error
fileName = 'm3_error';
figure;
subplot(3,1,1);
plot(timeEst,[mdt3i(:,1)-mdt3io(:,1)]);
legend('m3x-err')
grid on;
xlabel('time (sec)');ylabel('(mm)');
title('m3-err');

subplot(3,1,2);
plot(timeEst,[mdt3i(:,2)-mdt3io(:,2)]);
legend('m3y-err')
grid on;
xlabel('time (sec)');ylabel('(mm)');

subplot(3,1,3);
plot(timeEst,[mdt3i(:,3)-mdt3io(:,3)]);
legend('m3z-err')
grid on;
xlabel('time (sec)');ylabel('(mm)');
saveas(gcf,strcat(dirName,fileName,'.fig'));
saveas(gcf,strcat(dirName,fileName,'.jpg'));

nerr3=[norm([mdt3i(:,1)-mdt3io(:,1)]) norm([mdt3i(:,2)-mdt3io(:,2)]) norm([mdt3i(:,3)-mdt3io(:,3)])];

%% marker4
fileName = 'm4_meas';
figure;
subplot(3,1,1);
plot(timeEst,[mdt4i(:,1),mdt4io(:,1)]);
legend('m4x-meas','m4x-est')
grid on;
xlabel('time (sec)');ylabel('(mm)');
title('m4');

subplot(3,1,2);
plot(timeEst,[mdt4i(:,2),mdt4io(:,2)]);
legend('m4y-meas','m4y-est')
grid on;
xlabel('time (sec)');ylabel('(mm)');

subplot(3,1,3);
plot(timeEst,[mdt4i(:,3),mdt4io(:,3)]);
legend('m4z-meas','m4z-est')
grid on;
xlabel('time (sec)');ylabel('(mm)');
saveas(gcf,strcat(dirName,fileName,'.fig'));
saveas(gcf,strcat(dirName,fileName,'.jpg'));


%% marker4error
fileName = 'm4_error';
figure;
subplot(3,1,1);
plot(timeEst,[mdt4i(:,1)-mdt4io(:,1)]);
legend('m4x-err')
grid on;
xlabel('time (sec)');ylabel('(mm)');
title('m4-err');

subplot(3,1,2);
plot(timeEst,[mdt4i(:,2)-mdt4io(:,2)]);
legend('m4y-err')
grid on;
xlabel('time (sec)');ylabel('(mm)');

subplot(3,1,3);
plot(timeEst,[mdt4i(:,3)-mdt4io(:,3)]);
legend('m4z-err')
grid on;
xlabel('time (sec)');ylabel('(mm)');
saveas(gcf,strcat(dirName,fileName,'.fig'));
saveas(gcf,strcat(dirName,fileName,'.jpg'));

nerr4=[norm([mdt4i(:,1)-mdt4io(:,1)]) norm([mdt4i(:,2)-mdt4io(:,2)]) norm([mdt4i(:,3)-mdt4io(:,3)])];
nerr=[nerr2; nerr3; nerr4]

%% q1
fileName = 'q1_est';
figure;
subplot(1,1,1);
plot(timeEst,[radtodeg(stateEst(:,1))]);
legend('q1-est')
grid on;
xlabel('time (sec)');ylabel('(deg)');


title('q1');

saveas(gcf,strcat(dirName,fileName,'.fig'));
saveas(gcf,strcat(dirName,fileName,'.jpg'));


%% q2
fileName = 'q2_est';
figure;
subplot(1,1,1);
plot(timeEst,[radtodeg(stateEst(:,2))]);
legend('q2-est')
grid on;
title('q2');
xlabel('time (sec)');ylabel('(deg)');
saveas(gcf,strcat(dirName,fileName,'.fig'));
saveas(gcf,strcat(dirName,fileName,'.jpg'));


%% q3
fileName = 'q3_est';
figure;
subplot(1,1,1);
plot(timeEst,[radtodeg(stateEst(:,3))]);
legend('q3-est')
grid on;
title('q3');
xlabel('time (sec)');ylabel('(deg)');
saveas(gcf,strcat(dirName,fileName,'.fig'));
saveas(gcf,strcat(dirName,fileName,'.jpg'));

%% q4
fileName = 'q4_est';
figure;
subplot(1,1,1);
plot(timeEst,[radtodeg(stateEst(:,4))]);
legend('q4-est')
grid on;
title('q4');
xlabel('time (sec)');ylabel('(deg)');
saveas(gcf,strcat(dirName,fileName,'.fig'));
saveas(gcf,strcat(dirName,fileName,'.jpg'));





