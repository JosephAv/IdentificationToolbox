%% Load Data & organize them in a cell struct

%Here i separe different frames of dataset as given by PS
%data = load('6_1.dat'); %6_1 9_1

[ndata, ~] = size(data);

% Change them
MkNUMBER = length(MkALL); 

frame = 1;
data2 = [];
data1 = cell(1,1);
data2old = 0;
for i = 1:ndata
    
    %here i create the cell structure
    if data(i,5) ~= 0
        data2 = [data2; data(i,[1 3:5])];
    else
        frame = frame + 1;
        [n1, n2] = size(data2);
        
        %here i replace missing mks with 0s (in order to be compatible with Visar's code)
        if n1 ~= MkNUMBER
            IDnow = data2(:,1);
            missids = find_missing_id(IDnow,MkALL); %this function give missing ids

            for l = 1 : length(missids)
                aux = MkALL - missids(l);
                index = find(~aux); %Find the position of missing mk in MkIDS
                data2 = [data2(1:index-1,:); [missids(l) zeros(1,3)]; data2(index:end,:)];
                %data2 = [data2; [missids(l) zeros(1,3)]];
            end
            
            [nr, ~] = size(data2);
            for m = 1 : nr 
                if data2(m,2) == 0  && data2old(1,1)~=0
                    data2(m,2:4) = data2old(m,2:4);
                end
            end     
            
        end
        
        [n1, n2] = size(data2);
        data1= [data1 mat2cell(data2,n1,n2)];    
        data2old = data2;
        data2 = [];
    end 

    %[mknr, mknc] = size(data2);
    
end

data1 = data1(2:end);
frame = frame-1;
clear data2

%save data1 data1

% Eliminate outliers by hand
% FrameToDelete = 220:250;
% 
% for i = FrameToDelete
%     tmp1 = cell2mat(data1(i));
%     tmp1(:,2:4) = 0*tmp1(:,2:4);
%     [n1, n2] = size(tmp1);
%     data1(i) = mat2cell(tmp1,n1,n2);
% end



%% Define Local coords (chest supp) % Mk IDs

r     = 43;   %lunghezza stanghette 
Gamma = pi/6; %Angolo fra le stanghette 
hMK1  = 45;   %quota led terzo piano
hMK2  = 40;   %quota led secondo piano
hMK3  = 35;   %quota led primo piano
hMK4  = 67;   %quota led piano alto == lunghezza lato corto
d1    = 5;    %lunghezza collo del led pi? alto (cappuccio)

StarLocalCoords = [r*cos(Gamma) r*sin(Gamma)  hMK1;... %MK1
                   r            0             hMK2;... %MK2
                   r*cos(Gamma) -r*sin(Gamma) hMK3;... %MK3
                   0            0             hMK4];   %MK4
               
%% Rotate Data

RotatedData = cell(1,1);

%aaa = [];
for j = 1:frame
    
    Frame_data = cell2mat(data1(j));
    IDs = Frame_data(:,1);
    Pos = Frame_data(:,2:end);    
     
    ReferencePos = Pos([find(IDs==ReferenceIDS(1)) find(IDs==ReferenceIDS(2)) find(IDs==ReferenceIDS(3)) find(IDs==ReferenceIDS(4))], :);
    [ReferenceNMK, ~] = size(ReferencePos);
    % If possible, calculate an updated Tr. homogeneous
    if ReferenceNMK == 4 && ReferencePos(1,1)~=0 && ReferencePos(2,1)~=0 && ReferencePos(3,1)~=0 && ReferencePos(4,1)~=0;
        [Ropt, dopt, ~, T_hom_inv] = OptimalRigidPose(StarLocalCoords, ReferencePos);
    end

    [MkNum, ~] = size(Frame_data);
    clear Rotated_frame_data
    Rotated_frame_data = [];
    for k = 1:MkNum
        
        if Pos(k,1) ~= 0
            rotatedv = T_hom_inv*([Pos(k,:) 1]');
            Rotated_frame_data(k,:) = rotatedv(1:3);
        else
            rotatedv = [Pos(k,:) 1]';
            Rotated_frame_data(k,:) = rotatedv(1:3);
        end
    end
    
    NewFrame = [IDs Rotated_frame_data];
    [n1, n2] = size(NewFrame);
    RotatedData = [ RotatedData mat2cell(NewFrame,n1,n2)];

end

RotatedData = RotatedData(2:end);
save RotatedData RotatedData



% load Calibration measurements in a new form (accoarding to visar's structure)
% MKPos has NumFrame(CalibFrameNum) (30) rows and MkNO*3 colums (for each row xmk1 ymk1 zmk1 xmk2 etc... )
MKPos = zeros(frame, 1);

for i = 1 : frame
    tmp1 = cell2mat(RotatedData(i)); % export from the cell
    
    %tmp2 is a reorganization of tmp1 looking at correct list ok mks
    tmp2 = tmp1([find(MkALL==ArmIDS(1))       find(MkALL==ArmIDS(2))...
                 find(MkALL==ArmIDS(3))       find(MkALL==ArmIDS(4))...
                 find(MkALL==ArmIDS(5))       find(MkALL==ArmIDS(6))...
                 find(MkALL==ForearmIDS(1))   find(MkALL==ForearmIDS(2))...
                 find(MkALL==ForearmIDS(3))   find(MkALL==ForearmIDS(4))...
                 find(MkALL==ForearmIDS(5))   find(MkALL==ForearmIDS(6))...
                 find(MkALL==HandIDS(1))      find(MkALL==HandIDS(2))...
                 find(MkALL==HandIDS(3))      find(MkALL==HandIDS(4))],:);
             
       for j = 1 : MkNOUL-4
           MKPos(i, 1 +(j-1)*3 : 3 +(j-1)*3) = tmp2(j,2:4);
       end
end
 
%%% find(MkALL==ReferenceIDS(1)) find(MkALL==ReferenceIDS(2))...
%%%                 find(MkALL==ReferenceIDS(3)) find(MkALL==ReferenceIDS(4))...
                 

clear tmp1 tmp2


[nr,nc]=size(MKPos);
MKPosSmoothed = [];
span = 100;
for i = 1 : nc
    MKPosSmoothed(:,i) = smooth(MKPos(:,i),span);
end
