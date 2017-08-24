%% Load Data & organize them in a cell struct

%Here i separe different frames of dataset as given by PS
%data = load('6_1.dat'); %6_1 9_1

[ndata, ndata1] = size(data);

% Change them
MkNUMBER = length(MkALL); 

frame = 1;
data2 = [];
data1 = cell(1,1);
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
            
        end
        [n1, n2] = size(data2);
        data1= [data1 mat2cell(data2,n1,n2)];
        data2 = [];
    end 
    
    %[mknr, mknc] = size(data2);
    
end

data1 = data1(2:end);
frame = frame-1;
clear data2
% 
% % Eliminate outliers by hand
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
    [ReferenceNMK, ReferenceNMK1] = size(ReferencePos);
    % If possible, calculate an updated Tr. homogeneous
    if ReferenceNMK == 4 && ReferencePos(1,1)~=0 && ReferencePos(2,1)~=0 && ReferencePos(3,1)~=0 && ReferencePos(4,1)~=0;
        [Ropt, dopt, dopt1, T_hom_inv] = OptimalRigidPose(StarLocalCoords, ReferencePos);
    end

    [MkNum, MkNum1] = size(Frame_data);
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
%save RotatedData RotatedData

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


% % % % % % % % % % % %% Filtering 
% % % % % % % % % % % 
% % % % % % % % % % % %Find central point for each support at frame i
% % % % % % % % % % % CarmMAT     = [];
% % % % % % % % % % % CforearmMAT = [];
% % % % % % % % % % % ChandMAT    = [];
% % % % % % % % % % % 
% % % % % % % % % % % phi_F_A_MAT   = [];
% % % % % % % % % % % psi_F_A_MAT   = [];
% % % % % % % % % % % theta_F_A_MAT = [];
% % % % % % % % % % % 
% % % % % % % % % % % phi_F_F_MAT   = [];
% % % % % % % % % % % psi_F_F_MAT   = [];
% % % % % % % % % % % theta_F_F_MAT = [];
% % % % % % % % % % % 
% % % % % % % % % % % phi_F_H_MAT   = [];
% % % % % % % % % % % psi_F_H_MAT   = [];
% % % % % % % % % % % theta_F_H_MAT = [];
% % % % % % % % % % %     
% % % % % % % % % % % for i = 1 : frame
% % % % % % % % % % %     
% % % % % % % % % % % %%%%%Arm plate
% % % % % % % % % % %     ArmP1 = MKPos(i,1:3);
% % % % % % % % % % %     ArmP2 = MKPos(i,4:6);
% % % % % % % % % % %     ArmP3 = MKPos(i,7:9);
% % % % % % % % % % %     ArmP4 = MKPos(i,10:12);
% % % % % % % % % % %     
% % % % % % % % % % % %%%%%Forearm plate
% % % % % % % % % % %     ForearmP1 = MKPos(i,13:15);
% % % % % % % % % % %     ForearmP2 = MKPos(i,16:18);
% % % % % % % % % % %     ForearmP3 = MKPos(i,19:21);
% % % % % % % % % % %     ForearmP4 = MKPos(i,22:24);
% % % % % % % % % % % %%%%%Hand plate
% % % % % % % % % % %     HandP1 = MKPos(i,25:27);
% % % % % % % % % % %     HandP2 = MKPos(i,28:30);
% % % % % % % % % % %     HandP3 = MKPos(i,31:33);
% % % % % % % % % % %     HandP4 = MKPos(i,34:36);
% % % % % % % % % % %     
% % % % % % % % % % % %%%%%Fixed Ref Sys
% % % % % % % % % % %     Xfixed = [1 0 0];
% % % % % % % % % % %     Yfixed = [0 1 0];
% % % % % % % % % % %     Zfixed = [0 0 1];
% % % % % % % % % % %     
% % % % % % % % % % % %%%%%Arm Ref Sys
% % % % % % % % % % %     if ArmP2(1) ~= 0 && ArmP1(1) ~= 0
% % % % % % % % % % %         Xarm = ArmP2-ArmP1;
% % % % % % % % % % %     elseif ArmP4(1) ~= 0 && ArmP3(1) ~= 0
% % % % % % % % % % %         Xarm = ArmP4-ArmP3;
% % % % % % % % % % %     else
% % % % % % % % % % %         Xarm = XarmOLD;
% % % % % % % % % % %     end
% % % % % % % % % % %     Xarm = Xarm/norm(Xarm);
% % % % % % % % % % %     XarmOLD = Xarm;
% % % % % % % % % % %     
% % % % % % % % % % %     if ArmP1(1) ~= 0 && ArmP3(1) ~= 0
% % % % % % % % % % %         Zarm = ArmP1-ArmP3;
% % % % % % % % % % %     elseif ArmP2(1) ~= 0 && ArmP4(1) ~= 0
% % % % % % % % % % %         Zarm = ArmP2-ArmP4;
% % % % % % % % % % %     else
% % % % % % % % % % %         Zarm = ZarmOLD;
% % % % % % % % % % %     end
% % % % % % % % % % %     Zarm = Zarm/norm(Zarm);
% % % % % % % % % % %     ZarmOLD = Zarm;
% % % % % % % % % % %     
% % % % % % % % % % %     Yarm = cross(Zarm,Xarm);
% % % % % % % % % % %     Yarm = Yarm/norm(Yarm);
% % % % % % % % % % %     
% % % % % % % % % % % %%%%%Forearm Ref Sys
% % % % % % % % % % %     if ForearmP2(1) ~= 0 && ForearmP1(1) ~= 0
% % % % % % % % % % %         Xforearm = ForearmP2-ForearmP1;
% % % % % % % % % % %     elseif ForearmP4(1) ~= 0 && ForearmP3(1) ~= 0
% % % % % % % % % % %         Xforearm = ForearmP4-ForearmP3;
% % % % % % % % % % %     else
% % % % % % % % % % %         Xforearm = XforearmOLD;
% % % % % % % % % % %     end
% % % % % % % % % % %     Xforearm = Xforearm/norm(Xforearm);
% % % % % % % % % % %     XforearmOLD = Xforearm;
% % % % % % % % % % %     
% % % % % % % % % % %     if ForearmP1(1) ~= 0 && ForearmP3(1) ~= 0
% % % % % % % % % % %         Zforearm = ForearmP1-ForearmP3;
% % % % % % % % % % %     elseif ForearmP2(1) ~= 0 && ForearmP4(1) ~= 0
% % % % % % % % % % %         Zforearm = ForearmP2-ForearmP4;
% % % % % % % % % % %     else
% % % % % % % % % % %         Zforearm = ZforearmOLD;
% % % % % % % % % % %     end
% % % % % % % % % % %     Zforearm = Zforearm/norm(Zforearm);
% % % % % % % % % % %     ZforearmOLD = Zforearm;
% % % % % % % % % % %     
% % % % % % % % % % %     Yforearm = cross(Zforearm,Xforearm);
% % % % % % % % % % %     Yforearm = Yforearm/norm(Yforearm);
% % % % % % % % % % %     
% % % % % % % % % % % %%%%%Hand Ref Sys    
% % % % % % % % % % %     if HandP4(1) ~= 0 && HandP3(1) ~= 0
% % % % % % % % % % %         Xhand = HandP4-HandP3;
% % % % % % % % % % %     elseif HandP2(1) ~= 0 && HandP1(1) ~= 0
% % % % % % % % % % %         Xhand = HandP2-HandP1;
% % % % % % % % % % %     else
% % % % % % % % % % %         Xhand = XhandOLD;
% % % % % % % % % % %     end
% % % % % % % % % % %     Xhand = Xhand/norm(Xhand);
% % % % % % % % % % %     XhandOLD = Xhand;
% % % % % % % % % % %     
% % % % % % % % % % %     if HandP4(1) ~= 0 && HandP2(1) ~= 0
% % % % % % % % % % %         Zhand = HandP4-HandP2;
% % % % % % % % % % %     elseif HandP3(1) ~= 0 && HandP1(1) ~= 0
% % % % % % % % % % %         Zhand = HandP3-HandP1;
% % % % % % % % % % %     else
% % % % % % % % % % %         Zhand = ZhandOLD;
% % % % % % % % % % %     end
% % % % % % % % % % %     Zhand = Zhand/norm(Zhand);
% % % % % % % % % % %     ZhandOLD = Zhand;
% % % % % % % % % % %     
% % % % % % % % % % %     Yhand = cross(Zhand,Xhand);
% % % % % % % % % % %     Yhand = Yhand/norm(Yhand);
% % % % % % % % % % %     
% % % % % % % % % % % %%%%%Centers
% % % % % % % % % % %     if ArmP4(1) ~= 0 && ArmP1(1) ~= 0
% % % % % % % % % % %         Carm = ArmP4 + (ArmP1-ArmP4)/2;
% % % % % % % % % % %     elseif ArmP2(1) ~= 0 && ArmP3(1) ~= 0
% % % % % % % % % % %         Carm = ArmP2 + (ArmP3-ArmP2)/2;
% % % % % % % % % % %     else
% % % % % % % % % % %         Carm = CarmOLD;
% % % % % % % % % % %     end
% % % % % % % % % % %     CarmOLD = Carm;
% % % % % % % % % % %     
% % % % % % % % % % %     if ForearmP4(1) ~= 0 && ForearmP1(1) ~= 0
% % % % % % % % % % %         Cforearm = ForearmP4 + (ForearmP1-ForearmP4)/2;
% % % % % % % % % % %     elseif ForearmP2(1) ~= 0 && ForearmP3(1) ~= 0
% % % % % % % % % % %         Cforearm = ForearmP2 + (ForearmP3-ForearmP2)/2;
% % % % % % % % % % %     else
% % % % % % % % % % %         Cforearm = CforearmOLD;
% % % % % % % % % % %     end
% % % % % % % % % % %     CforearmOLD = Cforearm;
% % % % % % % % % % %     
% % % % % % % % % % %     if HandP4(1) ~= 0 && HandP1(1) ~= 0
% % % % % % % % % % %         Chand = HandP4 + (HandP1-HandP4)/2;
% % % % % % % % % % %     elseif HandP2(1) ~= 0 && HandP3(1) ~= 0
% % % % % % % % % % %         Chand = HandP2 + (HandP3-HandP2)/2;
% % % % % % % % % % %     else
% % % % % % % % % % %         Chand = ChandOLD;
% % % % % % % % % % %     end
% % % % % % % % % % %     ChandOLD = Chand;
% % % % % % % % % % % 
% % % % % % % % % % % %%%%%Rotations
% % % % % % % % % % %     RefFix     = [Xfixed'   Yfixed'   Zfixed'];
% % % % % % % % % % %     RefArm     = [Xarm'     Yarm'     Zarm'];
% % % % % % % % % % %     RefForearm = [Xforearm' Yforearm' Zforearm'];
% % % % % % % % % % %     RefHand    = [Xhand'    Yhand'    Zhand'];
% % % % % % % % % % %     
% % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%% Wahba's problem %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % % % % % % %     BA = RefArm';
% % % % % % % % % % %     BF = RefForearm';
% % % % % % % % % % %     BH = RefHand';
% % % % % % % % % % %     
% % % % % % % % % % %     [UA, SA, VA] = svd(BA);
% % % % % % % % % % %     [UF, SF, VF] = svd(BF);
% % % % % % % % % % %     [UH, SH, VH] = svd(BH);
% % % % % % % % % % %     
% % % % % % % % % % %     MA = [1 0 0; 0 1 0; 0 0 det(UA)*det(VA)];
% % % % % % % % % % %     MF = [1 0 0; 0 1 0; 0 0 det(UF)*det(VF)];
% % % % % % % % % % %     MH = [1 0 0; 0 1 0; 0 0 det(UH)*det(VH)];
% % % % % % % % % % %     
% % % % % % % % % % %     R_F_A = UA*MA*VA';
% % % % % % % % % % %     R_F_F = UF*MF*VF';
% % % % % % % % % % %     R_F_H = UH*MH*VH';
% % % % % % % % % % %     
% % % % % % % % % % % %     R_F_A = RefArm/RefFix;%RefArm*inv(RefFix);     %Rotation from Fixed ref sys to Arm ref sys
% % % % % % % % % % % %     R_F_F = RefForearm/RefFix;%RefForearm*inv(RefFix); %Rotation from Fixed ref sys to Forearm ref sys
% % % % % % % % % % % %     R_F_H = RefHand/RefFix;%RefHand*inv(RefFix);    %Rotation from Fixed ref sys to Hand ref sys
% % % % % % % % % % % 
% % % % % % % % % % %     phi_F_A   = atan2(R_F_A(1,3),-R_F_A(2,3));
% % % % % % % % % % %     psi_F_A   = atan2(-cos(phi_F_A)*R_F_A(1,2)-sin(phi_F_A)*R_F_A(2,2), cos(phi_F_A)*R_F_A(1,1)+sin(phi_F_A)*R_F_A(2,1));
% % % % % % % % % % %     theta_F_A = atan2(sin(phi_F_A)*R_F_A(1,3)-cos(phi_F_A)*R_F_A(2,3),R_F_A(3,3));
% % % % % % % % % % %     
% % % % % % % % % % %     phi_F_F   = atan2(R_F_F(1,3),-R_F_F(2,3));
% % % % % % % % % % %     psi_F_F   = atan2(-cos(phi_F_F)*R_F_F(1,2)-sin(phi_F_F)*R_F_F(2,2), cos(phi_F_F)*R_F_F(1,1)+sin(phi_F_F)*R_F_F(2,1));
% % % % % % % % % % %     theta_F_F = atan2(sin(phi_F_F)*R_F_F(1,3)-cos(phi_F_F)*R_F_F(2,3),R_F_F(3,3));
% % % % % % % % % % %     
% % % % % % % % % % %     phi_F_H   = atan2(R_F_H(1,3),-R_F_H(2,3));
% % % % % % % % % % %     psi_F_H   = atan2(-cos(phi_F_H)*R_F_H(1,2)-sin(phi_F_H)*R_F_H(2,2), cos(phi_F_H)*R_F_H(1,1)+sin(phi_F_H)*R_F_H(2,1));
% % % % % % % % % % %     theta_F_H = atan2(sin(phi_F_H)*R_F_H(1,3)-cos(phi_F_H)*R_F_H(2,3),R_F_H(3,3));
% % % % % % % % % % % 
% % % % % % % % % % %     
% % % % % % % % % % % %%%%%Export values for filtering
% % % % % % % % % % % 
% % % % % % % % % % %     CarmMAT     = [CarmMAT Carm'];
% % % % % % % % % % %     CforearmMAT = [CforearmMAT Cforearm'];
% % % % % % % % % % %     ChandMAT    = [ChandMAT Chand'];
% % % % % % % % % % %     
% % % % % % % % % % %     phi_F_A_MAT   = [phi_F_A_MAT phi_F_A];
% % % % % % % % % % %     psi_F_A_MAT   = [psi_F_A_MAT psi_F_A];
% % % % % % % % % % %     theta_F_A_MAT = [theta_F_A_MAT theta_F_A];
% % % % % % % % % % %     
% % % % % % % % % % %     phi_F_F_MAT   = [phi_F_F_MAT phi_F_F];
% % % % % % % % % % %     psi_F_F_MAT   = [psi_F_F_MAT psi_F_F];
% % % % % % % % % % %     theta_F_F_MAT = [theta_F_F_MAT theta_F_F];
% % % % % % % % % % %     
% % % % % % % % % % %     phi_F_H_MAT   = [phi_F_H_MAT phi_F_H];
% % % % % % % % % % %     psi_F_H_MAT   = [psi_F_H_MAT psi_F_H];
% % % % % % % % % % %     theta_F_H_MAT = [theta_F_H_MAT theta_F_H];
% % % % % % % % % % % 
% % % % % % % % % % % end
% % % % % % % % % % % %%%%%%% Smoothing %%%%%%%
% % % % % % % % % % % span = 1;
% % % % % % % % % % % CarmMATs(1,:) = smooth(CarmMAT(1,:),span);
% % % % % % % % % % % CarmMATs(2,:) = smooth(CarmMAT(2,:),span);
% % % % % % % % % % % CarmMATs(3,:) = smooth(CarmMAT(3,:),span);
% % % % % % % % % % % 
% % % % % % % % % % % CforearmMATs(1,:) = smooth(CforearmMAT(1,:),span);
% % % % % % % % % % % CforearmMATs(2,:) = smooth(CforearmMAT(2,:),span);
% % % % % % % % % % % CforearmMATs(3,:) = smooth(CforearmMAT(3,:),span);
% % % % % % % % % % % 
% % % % % % % % % % % ChandMATs(1,:) = smooth(ChandMAT(1,:),span);
% % % % % % % % % % % ChandMATs(2,:) = smooth(ChandMAT(2,:),span);
% % % % % % % % % % % ChandMATs(3,:) = smooth(ChandMAT(3,:),span);
% % % % % % % % % % % 
% % % % % % % % % % % phi_F_A_MATs   = smooth(phi_F_A_MAT,span);
% % % % % % % % % % % psi_F_A_MATs   = smooth(psi_F_A_MAT,span);
% % % % % % % % % % % theta_F_A_MATs = smooth(theta_F_A_MAT,span);
% % % % % % % % % % % 
% % % % % % % % % % % phi_F_F_MATs   = smooth(phi_F_F_MAT,span);
% % % % % % % % % % % psi_F_F_MATs   = smooth(psi_F_F_MAT,span);
% % % % % % % % % % % theta_F_F_MATs = smooth(theta_F_F_MAT,span);
% % % % % % % % % % % 
% % % % % % % % % % % phi_F_H_MATs   = smooth(phi_F_H_MAT,span);
% % % % % % % % % % % psi_F_H_MATs   = smooth(psi_F_H_MAT,span);
% % % % % % % % % % % theta_F_H_MATs = smooth(theta_F_H_MAT,span);
% % % % % % % % % % % 
% % % % % % % % % % % %%%%%%% Re-Create Dataset %%%%%%%
% % % % % % % % % % % 
% % % % % % % % % % % MKPosSmoothed = [];
% % % % % % % % % % % for i = 1 : frame
% % % % % % % % % % % %%%%%Define New MK Pos MkSuppDimensions = [15 7]
% % % % % % % % % % %  
% % % % % % % % % % % %%%%%Arm plate
% % % % % % % % % % %     ArmP1 = [-MkSuppDimensions(2) 0  MkSuppDimensions(1)];
% % % % % % % % % % %     ArmP3 = [ MkSuppDimensions(2) 0  MkSuppDimensions(1)];
% % % % % % % % % % %     ArmP2 = [-MkSuppDimensions(2) 0 -MkSuppDimensions(1)];
% % % % % % % % % % %     ArmP4 = [ MkSuppDimensions(2) 0 -MkSuppDimensions(1)];
% % % % % % % % % % %     
% % % % % % % % % % % %%%%%Forearm plate
% % % % % % % % % % %     ForearmP2 = [-MkSuppDimensions(2) 0  MkSuppDimensions(1)];
% % % % % % % % % % %     ForearmP4 = [ MkSuppDimensions(2) 0  MkSuppDimensions(1)];
% % % % % % % % % % %     ForearmP1 = [-MkSuppDimensions(2) 0 -MkSuppDimensions(1)];
% % % % % % % % % % %     ForearmP3 = [ MkSuppDimensions(2) 0 -MkSuppDimensions(1)];
% % % % % % % % % % % %%%%%Hand plate
% % % % % % % % % % %     HandP3 = [-MkSuppDimensions(2) 0 -MkSuppDimensions(1)];
% % % % % % % % % % %     HandP1 = [ MkSuppDimensions(2) 0 -MkSuppDimensions(1)];
% % % % % % % % % % %     HandP4 = [-MkSuppDimensions(2) 0  MkSuppDimensions(1)];
% % % % % % % % % % %     HandP2 = [ MkSuppDimensions(2) 0  MkSuppDimensions(1)];
% % % % % % % % % % %     
% % % % % % % % % % % %%%%%Rotate Arm Mk Pos
% % % % % % % % % % %     R_F_As = EulerRotMatrix(phi_F_A_MATs(i), theta_F_A_MATs(i), psi_F_A_MATs(i));
% % % % % % % % % % %     ArmP1 = R_F_As*ArmP1';
% % % % % % % % % % %     ArmP2 = R_F_As*ArmP2';
% % % % % % % % % % %     ArmP3 = R_F_As*ArmP3';
% % % % % % % % % % %     ArmP4 = R_F_As*ArmP4';
% % % % % % % % % % %     
% % % % % % % % % % % %%%%%Rotate Forearm Mk Pos
% % % % % % % % % % %     R_F_Fs = EulerRotMatrix(phi_F_F_MATs(i), theta_F_F_MATs(i), psi_F_F_MATs(i));
% % % % % % % % % % %     ForearmP1 = R_F_Fs*ForearmP1';
% % % % % % % % % % %     ForearmP2 = R_F_Fs*ForearmP2';
% % % % % % % % % % %     ForearmP3 = R_F_Fs*ForearmP3';
% % % % % % % % % % %     ForearmP4 = R_F_Fs*ForearmP4';
% % % % % % % % % % % 
% % % % % % % % % % % %%%%%Rotate Hand Mk Pos
% % % % % % % % % % %     R_F_Hs = EulerRotMatrix(phi_F_H_MATs(i), theta_F_H_MATs(i), psi_F_H_MATs(i));
% % % % % % % % % % %     HandP1 = R_F_Hs*HandP1';
% % % % % % % % % % %     HandP2 = R_F_Hs*HandP2';
% % % % % % % % % % %     HandP3 = R_F_Hs*HandP3';
% % % % % % % % % % %     HandP4 = R_F_Hs*HandP4';
% % % % % % % % % % %     
% % % % % % % % % % % %%%%%Move Arm Mk Pos
% % % % % % % % % % %     ArmP1 = CarmMATs(:,i) + ArmP1;
% % % % % % % % % % %     ArmP2 = CarmMATs(:,i) + ArmP2;
% % % % % % % % % % %     ArmP3 = CarmMATs(:,i) + ArmP3;
% % % % % % % % % % %     ArmP4 = CarmMATs(:,i) + ArmP4;
% % % % % % % % % % %     
% % % % % % % % % % % %%%%%Move Forearm Mk Pos
% % % % % % % % % % %     ForearmP1 = CforearmMATs(:,i) + ForearmP1;
% % % % % % % % % % %     ForearmP2 = CforearmMATs(:,i) + ForearmP2;
% % % % % % % % % % %     ForearmP3 = CforearmMATs(:,i) + ForearmP3;
% % % % % % % % % % %     ForearmP4 = CforearmMATs(:,i) + ForearmP4;
% % % % % % % % % % % 
% % % % % % % % % % % %%%%%Move Hand Mk Pos
% % % % % % % % % % %     HandP1 = ChandMATs(:,i) + HandP1;
% % % % % % % % % % %     HandP2 = ChandMATs(:,i) + HandP2;
% % % % % % % % % % %     HandP3 = ChandMATs(:,i) + HandP3;
% % % % % % % % % % %     HandP4 = ChandMATs(:,i) + HandP4;
% % % % % % % % % % %     
% % % % % % % % % % %     MKPosSmoothedi = [ArmP1' ArmP2' ArmP3' ArmP4' ForearmP1' ForearmP2' ForearmP3' ForearmP4' HandP1' HandP2' HandP3' HandP4'];
% % % % % % % % % % %     
% % % % % % % % % % %     MKPosSmoothed = [MKPosSmoothed; MKPosSmoothedi];
% % % % % % % % % % % 
% % % % % % % % % % % end
% % % % % % % % % % % 
