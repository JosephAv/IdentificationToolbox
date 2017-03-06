ReferenceIDS = [11 4 7 9];
ArmIDS       = [5 6 10 8 19 22];
ForearmIDS   = [23 21 20 16 18 17];
HandIDS      = [32 30 31 28];

ThumbIDS     = [29 33 34 35]; 
IndexIDS     = [68 66 69 70];
MiddleIDS    = [41 45 43 44];
RingIDS      = [67 64 65 71];
LittleIDS    = [46 42 47 40];



MkALL        = sort([ReferenceIDS ArmIDS ForearmIDS HandIDS...
                 ThumbIDS IndexIDS MiddleIDS RingIDS LittleIDS]);
MkIDS_UL     = [ReferenceIDS ArmIDS ForearmIDS HandIDS];
MkNOALL      = length(MkALL); %marker number
MkNOUL       = length(MkIDS_UL); %marker number