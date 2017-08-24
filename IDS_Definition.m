ReferenceIDS = [11 4 7 9];
ArmIDS       = [5 6 10 8 22 19];
ForearmIDS   = [23 21 20 16 18 17];
HandIDS      = [32 30 33 28];

ThumbIDS     = [34 35 29 31]; 
IndexIDS     = [68 67 63 64];
MiddleIDS    = [47 46 44 45];
RingIDS      = [69 70 66 71];
LittleIDS    = [42 43 41 40];



MkALL        = sort([ReferenceIDS ArmIDS ForearmIDS HandIDS...
                 ThumbIDS IndexIDS MiddleIDS RingIDS LittleIDS]);
MkIDS_UL     = [ReferenceIDS ArmIDS ForearmIDS HandIDS];
MkNOALL      = length(MkALL); %marker number
MkNOUL       = length(MkIDS_UL); %marker number