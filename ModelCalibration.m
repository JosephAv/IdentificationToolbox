close all
clear all
clc

directory = 'datasets/';

Subject = 'Mimma_30';

%Filename = 'task7.dat';
Task = '_7';
Repetition = '_2';
Filename = [Subject Task Repetition];

data = load([directory Filename '.dat']);

IDS_Definition

MkSuppDimensions = [15 7 22.5 55]; %[Suppx Suppy ParX ParZ]

%% ArmCalib

%remember SymbolicParameters = [DX DY DZ DX1 DY1 DZ1 DX2 DY2 DZ2 DX3 DY3 DZ3 L1 L2];
%L1 length arm
%L2 length forearm
%DX DY DZ distance between reference and shoulder in star ref sys 
%DX1 DY1 DZ1 distance between shoulder and arm mks in star ref sys 
%DX2 DY2 DZ2 distance between elbow and forearm mks in star ref sys 
%DX3 DY3 DZ3 distance between wrist and hand mks in star ref sys 
%Suppx Suppy are mk base dimensions suppx>suppy

%UpperLimbParametersDEF=[-20 200 -100 0 40 120 0 20 180 45 10 0 220 250];

tic
ArmCalibration
toc

ArmIdentification

VISUAL

%% HandCalib
clear all

directory = 'datasets/';

file_calib_hand1 = 'kio1'; %Index & Ring Calib Data
dat_name = [directory file_calib_hand1];
generic_rigid_body_visar %rotate all 

file_calib_hand2 = 'kmo1'; %Middle & Little Calib Data
dat_name = [directory file_calib_hand2];
generic_rigid_body_visar

tic
HandCalibration
toc