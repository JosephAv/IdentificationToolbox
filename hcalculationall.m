%% Load of all kinematic transformations and creation of vector h and H
%h is a 69*1 matrix, h(1:3) is the position of the first marker in function
%of the joint angles. H is the jacobian of h
close all
clear all
clc

syms q1 q2 q3 q4 q5 q6 q7 
syms DX DY DZ DX1 DY1 DZ1 DX2 DY2 DZ2 DX3 DY3 DZ3 L1 L2 Suppx Suppy ParX ParZ
% % % DX = 0;
% % % DY = 20;
% % % DZ = 0;
% % % 
% % % L1 = 20;
% % % L2 = 20;
% % % 
% % % DX1 = 5;
% % % DY1 = 0;
% % % DZ1 = 10;
% % % 
% % % DX2 = 5;
% % % DY2 = 0;
% % % DZ2 = 10;
% % % 
% % % DX3 = 3;
% % % DY3 = 0;
% % % DZ3 = -5;
% % % 
% % % Suppx = 1.7;
% % % Suppy = 0.7;

tic
path = ['MathematicaKinematics/ACTUAL_MKS_KINEMATICS/']; %check if path is correct

disp('Loading kinematics...')
%upperlimb
run([path, 'gWorldB1s.m']);
run([path, 'gWorldB2s.m']);
run([path, 'gWorldHs.m']);
%MK Supports
run([path, 'gWorldMKA1s.m']);
run([path, 'gWorldMKA2s.m']);
run([path, 'gWorldMKA3s.m']);
run([path, 'gWorldMKA4s.m']);
run([path, 'gWorldMKA5s.m']);
run([path, 'gWorldMKA6s.m']);
run([path, 'gWorldMKF1s.m']);
run([path, 'gWorldMKF2s.m']);
run([path, 'gWorldMKF3s.m']);
run([path, 'gWorldMKF4s.m']);
run([path, 'gWorldMKF5s.m']);
run([path, 'gWorldMKF6s.m']);
run([path, 'gWorldMKH1s.m']);
run([path, 'gWorldMKH2s.m']);
run([path, 'gWorldMKH3s.m']);
run([path, 'gWorldMKH4s.m']);

disp('Homogeneous Transforms Loaded')

disp('calculating h...')

h = [gWorldMKA1(1:3,4); gWorldMKA2(1:3,4); gWorldMKA3(1:3,4); gWorldMKA4(1:3,4); gWorldMKA5(1:3,4); gWorldMKA6(1:3,4);...
    gWorldMKF1(1:3,4); gWorldMKF2(1:3,4); gWorldMKF3(1:3,4); gWorldMKF4(1:3,4); gWorldMKF5(1:3,4); gWorldMKF6(1:3,4);...
    gWorldMKH1(1:3,4); gWorldMKH2(1:3,4); gWorldMKH3(1:3,4); gWorldMKH4(1:3,4);];
export_ascii_sym(h,'hfun','h')
disp('h done')

disp('calculating H...')
qsym = [q1 q2 q3 q4 q5 q6 q7];

H = jacobian (h, qsym);
export_ascii_sym(H,'jacobianfun','H')
disp('H done')

disp('saving...')

save ForwardKin h
save JacobianForwardKin H

disp('h and H saved')

toc
