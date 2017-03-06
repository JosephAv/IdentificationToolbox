close all
clear all
clc

directory = 'datasets/';

Subject = 'Simona';
Filename = 'task7.dat';

data = load([directory Filename]);

IDS_Definition

MkSuppDimensions = [15 7 22.5 55]; %[Suppx Suppy ParX ParZ]

dataset_reorg_UpperLimb