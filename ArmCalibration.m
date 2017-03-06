%% load dataset & rotate data for uppelimb calibration
disp('Rotating dataset...')
dataset_reorg_UpperLimb

MKPos = MKPosSmoothed;

NumFrame = numel(MKPosSmoothed); %total number of frames
%Data are organized in a cell vector of NFRAMES elements. Each element is a
%matrix NMKs*4. The first column collects a IDs and columns 2:4 are the 
%positions x y z read from Phase Space. 
%N.B. Dataset for this section is reduced to upperlimb markers only

%Dataset now is RotatedData
disp('...done')

%% CALIBRATION INCIPIT

CalibFrameNum = 10; %number of frames used for calibration
IND_for_Calib = floor(linspace(1, frame, CalibFrameNum));%randi(NumFrame,1,CalibFrameNum); %frames used for calibration
%IND_for_Calib = 1:10;

%MKPos = MKPosSmoothed;

%% Calibration

display('Calibration Upper Limb...');

%load('datasetsimulated.mat')
%MKPos = hn(1:48,:);

%define Initial Guess Angles & Bounds

angleslb   = [-pi/2 -2.6  -3*pi/4 0      -pi   -pi/3 -pi/2]; %upper bounds (Angles)
anglesub   = [0     pi/2  pi/2    2/3*pi pi/2  0.3   pi/2]; %lower bounds (Angles)
anglesinit = [-0.01     0     0       0.5    -pi/2 0     0];%(anglesub+angleslb)/2;

%anglesinit = [0 0 0 0 0 0 0]; %initial guess (Angles)


%replicate them for each frame
anglesinit = repmat(anglesinit,1,CalibFrameNum); %initial guess (Angles)
angleslb   = repmat(angleslb,1,CalibFrameNum); %upper bounds (Angles)
anglesub   = repmat(anglesub,1,CalibFrameNum); %lower bounds (Angles)

%remember Parameters = [DX DY DZ DX1 DY1 DZ1 DX2 DY2 DZ2 DX3 DY3 DZ3 L1 L2 Suppx Suppy ParX ParZ];

%define Upper limb Geom Parameters (Initial Guess) & Bounds
UpperLimbParametersIG  = [130 160 -140  0  40 170 0 20 180 25 5 0 300 270]; %[90 200 -40  0  40  180 0 20 155 22  5 0 300 225];

%UpperLimbParametersIG = [108.2569 174.7941 -50.3476 -6.7210 10.9731 131.3430 -14.1185 -0.2734 136.7899 49.4783 20.2631 -18.2123 285.5432 220.2431];
%UpperLimbParametersIG = [108.2569 174.7941 -50.3476 -6.7210 10.9731 131.3430 -14.1185 -0.2734 136.7899 49.4783 20.2631 -18.2123 285.5432 220.2431 0];

% Parlb   = UpperLimbParametersIG - [50  50  50   5  5   50  5 5  50  30  2 5 50  50]*1;
% Parub   = UpperLimbParametersIG + [50  50  50   5  10  50  5 10 50  30  5 5 50  50]*1;
v = [50  50  50   20  35  50  20 35 50  20  10 10 50  50]*1;
Parlb   = UpperLimbParametersIG - v;
Parub   = UpperLimbParametersIG + v;

Parinit = UpperLimbParametersIG;  %[DX DY DZ DX1 DY1 DZ1 DX2 DY2 DZ2 DX3 DY3 DZ3 L1 L2];
% Parlb   = UpperLimbParametersIG - [20 20 50 10 0 20 10 0 20 10 0 5 30 30];
% Parub   = UpperLimbParametersIG + [20 20 50 10 10 20 10 10 20 10 5 5 30 30]; 

%define minimization parameters
A   = [];
b   = [];
Aeq = [];
beq = [];

x0 = [Parinit, anglesinit];
lb = [Parlb, angleslb];
ub = [Parub, anglesub];

%load symbolic forward kinematics
%load('ForwardKin.mat');%load in ws h 
%href = [StarLocalCoords(1,:) StarLocalCoords(2,:) StarLocalCoords(3,:) StarLocalCoords(4,:)]'; %add star transformation 
%h = [href; h(1:36)]; %select only upperlimb kinematics
%j =0;
MeasNowAll = [];
MeasHand = [];
for i = IND_for_Calib
    %j=j+1;
    %qnum = x(9+(j-1)*7 : 8+(j)*7);
    
    %hn = hfun(NumericParameters, qnum);
    measnow = MKPos(i,:);
    measnowhand = MKPos(i,end-12:end);
    %KinVectAll = [KinVectAll; hn];
    MeasNowAll = [MeasNowAll; measnow'];
    MeasHand = [MeasHand; measnowhand'];
end

options = optimoptions('fmincon','MaxIter',Inf,'MaxFunEvals',10000,'Display','iter')%,'Algorithm','active-set')

[x, fval] = fmincon(@(x) ObjArm(x,MeasNowAll,IND_for_Calib,MkSuppDimensions),x0,A,b,Aeq,beq,lb,ub,[],options);% @(x) NonLinConstr(x, MeasNowAll,IND_for_Calib, MkSuppDimensions)


% ObjectiveFunction = @(x) ObjArm(x,MKPos',CalibFrameNum);
% nvars = 56;    % Number of variables
% LB = lb;   % Lower bound
% UB = ub;  % Upper bound
% %ConstraintFunction = @simple_constraint;
% [x,fval] = ga(ObjectiveFunction,nvars,[],[],[],[],LB,UB)


display('...done');

UpperLimbParametersDEF = x(1:14);
FinalErrorCalib = fval;
%name = ['UpperLimbParametersDEF mouse.dat' ];
dir1 = 'EstimatedParameters/';

save ([dir1 'UpperLimbParametersDEF' Subject], 'UpperLimbParametersDEF')
save ([dir1 'ErrorUpperLimbCalib' Subject], 'FinalErrorCalib')

%figure;plot(values)
disp('Calibration Ended')

