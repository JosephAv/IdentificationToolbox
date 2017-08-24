%% Load Data & organize them in a cell struct

%Here i separe different frames of dataset as given by PS
%data = load('6_1.dat'); %6_1 9_1

[ndata, ~] = size(data);

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

% % % % % % % %             for l = 1 : length(missids)
% % % % % % % %                 aux = MkALL - missids(l);
% % % % % % % %                 index = find(~aux); %Find the position of missing mk in MkIDS
% % % % % % % %                 data2 = [data2(1:index-1,:); [missids(l) zeros(1,3)]; data2(index:end,:)];
% % % % % % % %                 %data2 = [data2; [missids(l) zeros(1,3)]];
% % % % % % % %             end
            
            for l = 1 : length(missids)
                aux = MkALL - missids(l);
                index = find(~aux); %Find the position of missing mk in MkIDS
                if i == 1
                    data2 = [data2(1:index-1,:); [missids(l) zeros(1,3)]; data2(index:end,:)];
                elseif i > 1
                    OldValues = cell2mat(data1);
                    OldVal = OldValues(index,2:4);
                    data2 = [data2(1:index-1,:); [missids(l) OldVal]; data2(index:end,:)];
                end
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

%% Plots

figure;hold on;
for i = 300
    data_frame_i = cell2mat(RotatedData(i));
    for j = 1 : length(data_frame_i(:,1))
        %if data_frame_i(j,1) == 47 || data_frame_i(j,1) == 40 || data_frame_i(j,1) == 42 || data_frame_i(j,1) == 43
        plot3(data_frame_i(j,2),data_frame_i(j,3),data_frame_i(j,4),'r*')
        %[i data_frame_i(j,2),data_frame_i(j,3),data_frame_i(j,4)]
        %end
    end
    
end


plot3([0 100],[0 0],[0 0],'r')
plot3([0 0],[0 100],[0 0],'g')
plot3([0 0],[0 0],[0 100],'b')

%% Plots1
% figure;hold on;
% for i = 20
%     data_frame_i = cell2mat(RotatedData(i));
%     plot3(data_frame_i(j,2),data_frame_i(j,3),data_frame_i(j,4),'r*')
%     %for j = 1 : length(data_frame_i(:,1))
%         %if data_frame_i(j,1) == 47 || data_frame_i(j,1) == 40 || data_frame_i(j,1) == 42 || data_frame_i(j,1) == 43
%         plot3(data_frame_i(2,2),data_frame_i(2,3),data_frame_i(2,4),'r*')  %id 5  %Hand
%         plot3(data_frame_i(7,2),data_frame_i(7,3),data_frame_i(7,4),'g*')  %id 10
%         plot3(data_frame_i(5,2),data_frame_i(5,3),data_frame_i(5,4),'b*')  %id 8
%         plot3(data_frame_i(6,2),data_frame_i(6,3),data_frame_i(6,4),'k*')  %id 9
%         
%         plot3(data_frame_i(31,2),data_frame_i(31,3),data_frame_i(31,4),'r*')  %id 46  %forearm
%         plot3(data_frame_i(30,2),data_frame_i(30,3),data_frame_i(30,4),'g*')  %id 45
%         plot3(data_frame_i(26,2),data_frame_i(26,3),data_frame_i(26,4),'b*')  %id 41
%         plot3(data_frame_i(29,2),data_frame_i(29,3),data_frame_i(29,4),'k*')  %id 44
%         
%         plot3(data_frame_i(27,2),data_frame_i(27,3),data_frame_i(27,4),'r*')  %id 42  %arm
%         plot3(data_frame_i(28,2),data_frame_i(28,3),data_frame_i(28,4),'g*')  %id 43
%         plot3(data_frame_i(25,2),data_frame_i(25,3),data_frame_i(25,4),'b*')  %id 40
%         plot3(data_frame_i(32,2),data_frame_i(32,3),data_frame_i(32,4),'k*')  %id 47
%         
%         plot3(data_frame_i(33,2),data_frame_i(33,3),data_frame_i(33,4),'k*')  %id 52  %star
%         plot3(data_frame_i(34,2),data_frame_i(34,3),data_frame_i(34,4),'k*')  %id 53
%         plot3(data_frame_i(35,2),data_frame_i(35,3),data_frame_i(35,4),'k*')  %id 54
%         plot3(data_frame_i(36,2),data_frame_i(36,3),data_frame_i(36,4),'k*')  %id 56
% 
%         %[i data_frame_i(j,2),data_frame_i(j,3),data_frame_i(j,4)]
%         %end
%     %end
%     
% end


% plot3([0 100],[0 0],[0 0],'r')
% plot3([0 0],[0 100],[0 0],'g')
% plot3([0 0],[0 0],[0 100],'b')

%% Occlusion Statistics
dirName = 'plots/ARM/';

OcclMK = [MkALL; zeros(1,MkNOALL)];
MKNOFR = [];
for i = 1 : frame
    data_frame_i = cell2mat(RotatedData(i));
    IDs = data_frame_i(:,1);
    Pos = data_frame_i(:,2:end);     
    [MkNum, ~] = size(data_frame_i);
    MkNum1 = MkNum;
    for k = 1:MkNum
        if Pos(k,1) == 0
            OcclMK(2,k) = OcclMK(2,k)+1;
            MkNum1 = MkNum1-1;
        end
    end
    MKNOFR = [MKNOFR MkNum1];
end

plotName = ['MkOcclusionStatistics' Subject Filename];
figure; bar(OcclMK(1,:),OcclMK(2,:)/frame*100);title('Statistics of Marker Occlusions in % of time span')

axis([0 72 0 100])
ax = gca;
ax.XTick = MkALL;
ax.YTick = 0:10:100;
xlabel ('Marker Number')
ylabel ('% of occlusion time')

saveas(gcf,strcat(dirName,plotName,'.fig'));
saveas(gcf,strcat(dirName,plotName,'.jpg'));


plotName = ['NumberMkSeen' Subject Filename];

figure; plot(MKNOFR,'r*');title('Number of Marker Seen')
xlabel ('Marker Number')
ylabel ('Number of Marker Seen')
saveas(gcf,strcat(dirName,plotName,'.fig'));
saveas(gcf,strcat(dirName,plotName,'.jpg'));

%% Filtering 

%Find central point for each support at frame i
CarmMAT     = [];
CforearmMAT = [];
ChandMAT    = [];

phi_F_A_MAT   = [];
psi_F_A_MAT   = [];
theta_F_A_MAT = [];

phi_F_F_MAT   = [];
psi_F_F_MAT   = [];
theta_F_F_MAT = [];

phi_F_H_MAT   = [];
psi_F_H_MAT   = [];
theta_F_H_MAT = [];
    
for i = 1 : frame
    
%%%%%Arm plate
    ArmP1 = MKPos(i,1:3);
    ArmP2 = MKPos(i,4:6);
    ArmP3 = MKPos(i,7:9);
    ArmP4 = MKPos(i,10:12);
    ArmP5 = MKPos(i,13:15);
    ArmP6 = MKPos(i,16:18);
    
%%%%%Forearm plate
    ForearmP1 = MKPos(i,19:21);
    ForearmP2 = MKPos(i,22:24);
    ForearmP3 = MKPos(i,25:27);
    ForearmP4 = MKPos(i,28:30);
    ForearmP5 = MKPos(i,31:33);
    ForearmP6 = MKPos(i,34:36);
    
%%%%%Hand plate
    HandP1 = MKPos(i,37:39);
    HandP2 = MKPos(i,40:42);
    HandP3 = MKPos(i,43:45);
    HandP4 = MKPos(i,46:48);
    
%%%%%Fixed Ref Sys
    Xfixed = [1 0 0];
    Yfixed = [0 1 0];
    Zfixed = [0 0 1];
    
%%%%%Arm Ref Sys
    if ArmP2(1) ~= 0 && ArmP1(1) ~= 0
        Xarm = ArmP1-ArmP2;
    elseif ArmP4(1) ~= 0 && ArmP3(1) ~= 0
        Xarm = ArmP3-ArmP4;
    elseif ArmP6(1) ~= 0 && ArmP5(1) ~= 0
        Xarm = ArmP5-ArmP6;
    else
        Xarm = XarmOLD;
    end
    Xarm = Xarm/norm(Xarm);
    XarmOLD = Xarm;
    
    if ArmP1(1) ~= 0 && ArmP3(1) ~= 0
        Zarm = ArmP3-ArmP1;
    elseif ArmP2(1) ~= 0 && ArmP4(1) ~= 0
        Zarm = ArmP4-ArmP2;
    elseif ArmP1(1) ~= 0 && ArmP5(1) ~= 0
        Zarm = ArmP5-ArmP1;
    elseif ArmP2(1) ~= 0 && ArmP6(1) ~= 0
        Zarm = ArmP6-ArmP2;
    elseif ArmP3(1) ~= 0 && ArmP5(1) ~= 0
        Zarm = ArmP5-ArmP3;
    elseif ArmP4(1) ~= 0 && ArmP6(1) ~= 0
        Zarm = ArmP6-ArmP4;
    else
        Zarm = ZarmOLD;
    end
    Zarm = Zarm/norm(Zarm);
    ZarmOLD = Zarm;
    
    Yarm = cross(Zarm,Xarm);
    Yarm = Yarm/norm(Yarm);
    
%%%%%Forearm Ref Sys
    if ForearmP2(1) ~= 0 && ForearmP1(1) ~= 0
        Xforearm = ForearmP1-ForearmP2;
    elseif ForearmP4(1) ~= 0 && ForearmP3(1) ~= 0
        Xforearm = ForearmP3-ForearmP4;
    elseif ForearmP6(1) ~= 0 && ForearmP5(1) ~= 0
        Xforearm = ForearmP5-ForearmP6;
    else
        Xforearm = XforearmOLD;
    end
    Xforearm = Xforearm/norm(Xforearm);
    XforearmOLD = Xforearm;
    

    if ForearmP1(1) ~= 0 && ForearmP3(1) ~= 0
        Zforearm = ForearmP3-ForearmP1;
    elseif ForearmP2(1) ~= 0 && ForearmP4(1) ~= 0
        Zforearm = ForearmP4-ForearmP2;
    elseif ForearmP1(1) ~= 0 && ForearmP5(1) ~= 0
        Zforearm = ForearmP5-ForearmP1;
    elseif ForearmP2(1) ~= 0 && ForearmP6(1) ~= 0
        Zforearm = ForearmP6-ForearmP2;
    elseif ForearmP3(1) ~= 0 && ForearmP5(1) ~= 0
        Zforearm = ForearmP5-ForearmP3;
    elseif ForearmP4(1) ~= 0 && ForearmP6(1) ~= 0
        Zforearm = ForearmP6-ForearmP4;
    else
        Zforearm = ZforearmOLD;
    end
    Zforearm = Zforearm/norm(Zforearm);
    ZforearmOLD = Zforearm;

    Yforearm = cross(Zforearm,Xforearm);
    Yforearm = Yforearm/norm(Yforearm);
    
%%%%%Hand Ref Sys    
    if HandP1(1) ~= 0 && HandP2(1) ~= 0
        Xhand = HandP1-HandP2;
    elseif HandP3(1) ~= 0 && HandP4(1) ~= 0
        Xhand = HandP3-HandP4;
    else
        Xhand = XhandOLD;
    end
    Xhand = Xhand/norm(Xhand);
    XhandOLD = Xhand;
    
    if HandP3(1) ~= 0 && HandP1(1) ~= 0
        Zhand = HandP3-HandP1;
    elseif HandP4(1) ~= 0 && HandP2(1) ~= 0
        Zhand = HandP4-HandP2;
    else
        Zhand = ZhandOLD;
    end
    Zhand = Zhand/norm(Zhand);
    ZhandOLD = Zhand;
    
    Yhand = cross(Zhand,Xhand);
    Yhand = Yhand/norm(Yhand);
    
%%%%%Centers
    if ArmP1(1) ~= 0 && ArmP6(1) ~= 0
        Carm = ArmP1 + (ArmP6-ArmP1)/2;
    elseif ArmP2(1) ~= 0 && ArmP5(1) ~= 0
        Carm = ArmP2 + (ArmP5-ArmP2)/2;
    elseif ArmP4(1) ~= 0 && ArmP3(1) ~= 0
        Carm = ArmP4 + (ArmP3-ArmP4)/2;
    else
        Carm = CarmOLD;
    end
    CarmOLD = Carm;
    
    if ForearmP1(1) ~= 0 && ForearmP6(1) ~= 0
        Cforearm = ForearmP1 + (ForearmP6-ForearmP1)/2;
    elseif ForearmP2(1) ~= 0 && ForearmP5(1) ~= 0
        Cforearm = ForearmP2 + (ForearmP5-ForearmP2)/2;
    elseif ForearmP4(1) ~= 0 && ForearmP3(1) ~= 0
        Cforearm = ForearmP4 + (ForearmP3-ForearmP4)/2;
    else
        Cforearm = CforearmOLD;
    end
    CforearmOLD = Cforearm;

    if HandP4(1) ~= 0 && HandP1(1) ~= 0
        Chand = HandP4 + (HandP1-HandP4)/2;
    elseif HandP2(1) ~= 0 && HandP3(1) ~= 0
        Chand = HandP2 + (HandP3-HandP2)/2;
    else
        Chand = ChandOLD;
    end
    ChandOLD = Chand;

%%%%%Rotations
    RefFix     = [Xfixed'   Yfixed'   Zfixed'];
    RefArm     = [Xarm'     Yarm'     Zarm'];
    RefForearm = [Xforearm' Yforearm' Zforearm'];
    RefHand    = [Xhand'    Yhand'    Zhand'];
    
%%%%%%%%%%%%%%%%%%%%%%%%%%% Wahba's problem %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    BA = RefArm';
    BF = RefForearm';
    BH = RefHand';
    
    [UA, SA, VA] = svd(BA);
    [UF, SF, VF] = svd(BF);
    [UH, SH, VH] = svd(BH);
    
    MA = [1 0 0; 0 1 0; 0 0 det(UA)*det(VA)];
    MF = [1 0 0; 0 1 0; 0 0 det(UF)*det(VF)];
    MH = [1 0 0; 0 1 0; 0 0 det(UH)*det(VH)];
    
    R_F_A = UA*MA*VA';
    R_F_F = UF*MF*VF';
    R_F_H = UH*MH*VH';
    
%     R_F_A = RefArm/RefFix;%RefArm*inv(RefFix);     %Rotation from Fixed ref sys to Arm ref sys
%     R_F_F = RefForearm/RefFix;%RefForearm*inv(RefFix); %Rotation from Fixed ref sys to Forearm ref sys
%     R_F_H = RefHand/RefFix;%RefHand*inv(RefFix);    %Rotation from Fixed ref sys to Hand ref sys

    phi_F_A   = atan2(R_F_A(1,3),-R_F_A(2,3));
    psi_F_A   = atan2(-cos(phi_F_A)*R_F_A(1,2)-sin(phi_F_A)*R_F_A(2,2), cos(phi_F_A)*R_F_A(1,1)+sin(phi_F_A)*R_F_A(2,1));
    theta_F_A = atan2(sin(phi_F_A)*R_F_A(1,3)-cos(phi_F_A)*R_F_A(2,3),R_F_A(3,3));
    
    phi_F_F   = atan2(R_F_F(1,3),-R_F_F(2,3));
    psi_F_F   = atan2(-cos(phi_F_F)*R_F_F(1,2)-sin(phi_F_F)*R_F_F(2,2), cos(phi_F_F)*R_F_F(1,1)+sin(phi_F_F)*R_F_F(2,1));
    theta_F_F = atan2(sin(phi_F_F)*R_F_F(1,3)-cos(phi_F_F)*R_F_F(2,3),R_F_F(3,3));
    
    phi_F_H   = atan2(R_F_H(1,3),-R_F_H(2,3));
    psi_F_H   = atan2(-cos(phi_F_H)*R_F_H(1,2)-sin(phi_F_H)*R_F_H(2,2), cos(phi_F_H)*R_F_H(1,1)+sin(phi_F_H)*R_F_H(2,1));
    theta_F_H = atan2(sin(phi_F_H)*R_F_H(1,3)-cos(phi_F_H)*R_F_H(2,3),R_F_H(3,3));

    
%%%%%Export values for filtering

    CarmMAT     = [CarmMAT Carm'];
    CforearmMAT = [CforearmMAT Cforearm'];
    ChandMAT    = [ChandMAT Chand'];
    
    phi_F_A_MAT   = [phi_F_A_MAT phi_F_A];
    psi_F_A_MAT   = [psi_F_A_MAT psi_F_A];
    theta_F_A_MAT = [theta_F_A_MAT theta_F_A];
    
    phi_F_F_MAT   = [phi_F_F_MAT phi_F_F];
    psi_F_F_MAT   = [psi_F_F_MAT psi_F_F];
    theta_F_F_MAT = [theta_F_F_MAT theta_F_F];
    
    phi_F_H_MAT   = [phi_F_H_MAT phi_F_H];
    psi_F_H_MAT   = [psi_F_H_MAT psi_F_H];
    theta_F_H_MAT = [theta_F_H_MAT theta_F_H];

end
%%%%%%% Smoothing %%%%%%%
span = 15;
CarmMATs = [];
CforearmMATs = [];
ChandMATs = [];
phi_F_A_MATs = [];
psi_F_A_MATs = [];
theta_F_A_MATs = [];
phi_F_F_MATs = [];
psi_F_F_MATs = [];
theta_F_F_MATs = [];
phi_F_H_MATs = [];
psi_F_H_MATs = [];
theta_F_H_MATs = [];

CarmMATs(1,:) = smooth(CarmMAT(1,:),span);
CarmMATs(2,:) = smooth(CarmMAT(2,:),span);
CarmMATs(3,:) = smooth(CarmMAT(3,:),span);

CforearmMATs(1,:) = smooth(CforearmMAT(1,:),span);
CforearmMATs(2,:) = smooth(CforearmMAT(2,:),span);
CforearmMATs(3,:) = smooth(CforearmMAT(3,:),span);

ChandMATs(1,:) = smooth(ChandMAT(1,:),span);
ChandMATs(2,:) = smooth(ChandMAT(2,:),span);
ChandMATs(3,:) = smooth(ChandMAT(3,:),span);

phi_F_A_MATs   = smooth(phi_F_A_MAT,span);
psi_F_A_MATs   = smooth(psi_F_A_MAT,span);
theta_F_A_MATs = smooth(theta_F_A_MAT,span);

phi_F_F_MATs   = smooth(phi_F_F_MAT,span);
psi_F_F_MATs   = smooth(psi_F_F_MAT,span);
theta_F_F_MATs = smooth(theta_F_F_MAT,span);

phi_F_H_MATs   = smooth(phi_F_H_MAT,span);
psi_F_H_MATs   = smooth(psi_F_H_MAT,span);
theta_F_H_MATs = smooth(theta_F_H_MAT,span);

%%%%%%% Re-Create Dataset %%%%%%%

MKPosSmoothed = [];
for i = 1 : frame
%%%%%Define New MK Pos MkSuppDimensions = [15 7]

LargeBaseX = MkSuppDimensions(3);
LargeBaseZ = MkSuppDimensions(4);
SmallBaseX = MkSuppDimensions(1);
SmallBaseZ = MkSuppDimensions(2);

%%%%%Arm plate
    ArmP1 = [ LargeBaseX 0 -LargeBaseZ];
    ArmP2 = [-LargeBaseX 0 -LargeBaseZ];
    ArmP3 = [ LargeBaseX 0 0];
    ArmP4 = [-LargeBaseX 0 0];
    ArmP5 = [ LargeBaseX 0 LargeBaseZ];
    ArmP6 = [-LargeBaseX 0 LargeBaseZ];
    
%%%%%Forearm plate
    ForearmP1 = [ LargeBaseX 0 -LargeBaseZ];
    ForearmP2 = [-LargeBaseX 0 -LargeBaseZ];
    ForearmP3 = [ LargeBaseX 0 0];
    ForearmP4 = [-LargeBaseX 0 0];
    ForearmP5 = [ LargeBaseX 0 LargeBaseZ];
    ForearmP6 = [-LargeBaseX 0 LargeBaseZ];

%%%%%Hand plate
    HandP1 = [ SmallBaseX 0 -SmallBaseZ];
    HandP2 = [-SmallBaseX 0 -SmallBaseZ];
    HandP3 = [ SmallBaseX 0  SmallBaseZ];
    HandP4 = [-SmallBaseX 0  SmallBaseZ];
    
%%%%%Rotate Arm Mk Pos
    R_F_As = EulerRotMatrix(phi_F_A_MATs(i), theta_F_A_MATs(i), psi_F_A_MATs(i));
    ArmP1 = R_F_As*ArmP1';
    ArmP2 = R_F_As*ArmP2';
    ArmP3 = R_F_As*ArmP3';
    ArmP4 = R_F_As*ArmP4';
    ArmP5 = R_F_As*ArmP5';
    ArmP6 = R_F_As*ArmP6';   
    
%%%%%Rotate Forearm Mk Pos
    R_F_Fs = EulerRotMatrix(phi_F_F_MATs(i), theta_F_F_MATs(i), psi_F_F_MATs(i));
    ForearmP1 = R_F_Fs*ForearmP1';
    ForearmP2 = R_F_Fs*ForearmP2';
    ForearmP3 = R_F_Fs*ForearmP3';
    ForearmP4 = R_F_Fs*ForearmP4';
    ForearmP5 = R_F_Fs*ForearmP5';
    ForearmP6 = R_F_Fs*ForearmP6';
    
%%%%%Rotate Hand Mk Pos
    R_F_Hs = EulerRotMatrix(phi_F_H_MATs(i), theta_F_H_MATs(i), psi_F_H_MATs(i));
    HandP1 = R_F_Hs*HandP1';
    HandP2 = R_F_Hs*HandP2';
    HandP3 = R_F_Hs*HandP3';
    HandP4 = R_F_Hs*HandP4';
    
%%%%%Move Arm Mk Pos
    ArmP1 = CarmMATs(:,i) + ArmP1;
    ArmP2 = CarmMATs(:,i) + ArmP2;
    ArmP3 = CarmMATs(:,i) + ArmP3;
    ArmP4 = CarmMATs(:,i) + ArmP4;
    ArmP5 = CarmMATs(:,i) + ArmP5;
    ArmP6 = CarmMATs(:,i) + ArmP6;
    
%%%%%Move Forearm Mk Pos
    ForearmP1 = CforearmMATs(:,i) + ForearmP1;
    ForearmP2 = CforearmMATs(:,i) + ForearmP2;
    ForearmP3 = CforearmMATs(:,i) + ForearmP3;
    ForearmP4 = CforearmMATs(:,i) + ForearmP4;
    ForearmP5 = CforearmMATs(:,i) + ForearmP5;
    ForearmP6 = CforearmMATs(:,i) + ForearmP6;
    
%%%%%Move Hand Mk Pos
    HandP1 = ChandMATs(:,i) + HandP1;
    HandP2 = ChandMATs(:,i) + HandP2;
    HandP3 = ChandMATs(:,i) + HandP3;
    HandP4 = ChandMATs(:,i) + HandP4;
    
    MKPosSmoothedi = [ArmP1' ArmP2' ArmP3' ArmP4' ArmP5' ArmP6' ForearmP1' ForearmP2' ForearmP3' ForearmP4' ForearmP5' ForearmP6' HandP1' HandP2' HandP3' HandP4'];
    
    MKPosSmoothed = [MKPosSmoothed; MKPosSmoothedi];

end

%% Plotting Filtering Effects
figure;
subplot(3,6,1); plot(MKPos(:,1),'r'); hold on;plot(MKPosSmoothed(:,1),'g'); title('Mk1 Arm x');grid;
subplot(3,6,7); plot(MKPos(:,2),'r'); hold on;plot(MKPosSmoothed(:,2),'g'); title('Mk1 Arm y');grid;
subplot(3,6,13);plot(MKPos(:,3),'r'); hold on;plot(MKPosSmoothed(:,3),'g'); title('Mk1 Arm z');grid;
subplot(3,6,2); plot(MKPos(:,4),'r'); hold on;plot(MKPosSmoothed(:,4),'g'); title('Mk2 Arm x');grid;
subplot(3,6,8); plot(MKPos(:,5),'r'); hold on;plot(MKPosSmoothed(:,5),'g'); title('Mk2 Arm y');grid;
subplot(3,6,14);plot(MKPos(:,6),'r'); hold on;plot(MKPosSmoothed(:,6),'g'); title('Mk2 Arm z');grid;
subplot(3,6,3); plot(MKPos(:,7),'r'); hold on;plot(MKPosSmoothed(:,7),'g'); title('Mk3 Arm x');grid;
subplot(3,6,9); plot(MKPos(:,8),'r'); hold on;plot(MKPosSmoothed(:,8),'g'); title('Mk3 Arm y');grid;
subplot(3,6,15);plot(MKPos(:,9),'r'); hold on;plot(MKPosSmoothed(:,9),'g'); title('Mk3 Arm z');grid;
subplot(3,6,4); plot(MKPos(:,10),'r');hold on;plot(MKPosSmoothed(:,10),'g');title('Mk4 Arm x');grid;
subplot(3,6,10);plot(MKPos(:,11),'r');hold on;plot(MKPosSmoothed(:,11),'g');title('Mk4 Arm y');grid;
subplot(3,6,16);plot(MKPos(:,12),'r');hold on;plot(MKPosSmoothed(:,12),'g');title('Mk4 Arm z');grid;
subplot(3,6,5); plot(MKPos(:,13),'r');hold on;plot(MKPosSmoothed(:,13),'g');title('Mk5 Arm x');grid;
subplot(3,6,11);plot(MKPos(:,14),'r');hold on;plot(MKPosSmoothed(:,14),'g');title('Mk5 Arm y');grid;
subplot(3,6,17);plot(MKPos(:,15),'r');hold on;plot(MKPosSmoothed(:,15),'g');title('Mk5 Arm z');grid;
subplot(3,6,6); plot(MKPos(:,16),'r');hold on;plot(MKPosSmoothed(:,16),'g');title('Mk6 Arm x');grid;
subplot(3,6,12);plot(MKPos(:,17),'r');hold on;plot(MKPosSmoothed(:,17),'g');title('Mk6 Arm y');grid;
subplot(3,6,18);plot(MKPos(:,18),'r');hold on;plot(MKPosSmoothed(:,18),'g');title('Mk6 Arm z');grid;

figure;
subplot(3,6,1); plot(MKPos(:,19),'r');hold on;plot(MKPosSmoothed(:,19),'g');title('Mk1 Forearm x');grid;
subplot(3,6,7); plot(MKPos(:,20),'r');hold on;plot(MKPosSmoothed(:,20),'g');title('Mk1 Forearm y');grid;
subplot(3,6,13);plot(MKPos(:,21),'r');hold on;plot(MKPosSmoothed(:,21),'g');title('Mk1 Forearm z');grid;
subplot(3,6,2); plot(MKPos(:,22),'r');hold on;plot(MKPosSmoothed(:,22),'g');title('Mk2 Forearm x');grid;
subplot(3,6,8); plot(MKPos(:,23),'r');hold on;plot(MKPosSmoothed(:,23),'g');title('Mk2 Forearm y');grid;
subplot(3,6,14);plot(MKPos(:,24),'r');hold on;plot(MKPosSmoothed(:,24),'g');title('Mk2 Forearm z');grid;
subplot(3,6,3); plot(MKPos(:,25),'r');hold on;plot(MKPosSmoothed(:,25),'g');title('Mk3 Forearm x');grid;
subplot(3,6,9); plot(MKPos(:,26),'r');hold on;plot(MKPosSmoothed(:,26),'g');title('Mk3 Forearm y');grid;
subplot(3,6,15);plot(MKPos(:,27),'r');hold on;plot(MKPosSmoothed(:,27),'g');title('Mk3 Forearm z');grid;
subplot(3,6,4); plot(MKPos(:,28),'r');hold on;plot(MKPosSmoothed(:,28),'g');title('Mk4 Forearm x');grid;
subplot(3,6,10);plot(MKPos(:,29),'r');hold on;plot(MKPosSmoothed(:,29),'g');title('Mk4 Forearm y');grid;
subplot(3,6,16);plot(MKPos(:,30),'r');hold on;plot(MKPosSmoothed(:,30),'g');title('Mk4 Forearm z');grid;
subplot(3,6,5); plot(MKPos(:,31),'r');hold on;plot(MKPosSmoothed(:,31),'g');title('Mk5 Forearm x');grid;
subplot(3,6,11);plot(MKPos(:,32),'r');hold on;plot(MKPosSmoothed(:,32),'g');title('Mk5 Forearm y');grid;
subplot(3,6,17);plot(MKPos(:,33),'r');hold on;plot(MKPosSmoothed(:,33),'g');title('Mk5 Forearm z');grid;
subplot(3,6,6); plot(MKPos(:,34),'r');hold on;plot(MKPosSmoothed(:,34),'g');title('Mk6 Forearm x');grid;
subplot(3,6,12);plot(MKPos(:,35),'r');hold on;plot(MKPosSmoothed(:,35),'g');title('Mk6 Forearm y');grid;
subplot(3,6,18);plot(MKPos(:,36),'r');hold on;plot(MKPosSmoothed(:,36),'g');title('Mk6 Forearm z');grid;

figure;
subplot(3,4,1); plot(MKPos(:,37),'r');hold on;plot(MKPosSmoothed(:,37),'g');title('Mk1 Hand x');grid;
subplot(3,4,5); plot(MKPos(:,38),'r');hold on;plot(MKPosSmoothed(:,38),'g');title('Mk1 Hand y');grid;
subplot(3,4,9); plot(MKPos(:,39),'r');hold on;plot(MKPosSmoothed(:,39),'g');title('Mk1 Hand z');grid;
subplot(3,4,2); plot(MKPos(:,40),'r');hold on;plot(MKPosSmoothed(:,40),'g');title('Mk2 Hand x');grid;
subplot(3,4,6); plot(MKPos(:,41),'r');hold on;plot(MKPosSmoothed(:,41),'g');title('Mk2 Hand y');grid;
subplot(3,4,10);plot(MKPos(:,42),'r');hold on;plot(MKPosSmoothed(:,42),'g');title('Mk2 Hand z');grid;
subplot(3,4,3); plot(MKPos(:,43),'r');hold on;plot(MKPosSmoothed(:,43),'g');title('Mk3 Hand x');grid;
subplot(3,4,7); plot(MKPos(:,44),'r');hold on;plot(MKPosSmoothed(:,44),'g');title('Mk3 Hand y');grid;
subplot(3,4,11);plot(MKPos(:,45),'r');hold on;plot(MKPosSmoothed(:,45),'g');title('Mk3 Hand z');grid;
subplot(3,4,4); plot(MKPos(:,46),'r');hold on;plot(MKPosSmoothed(:,46),'g');title('Mk4 Hand x');grid;
subplot(3,4,8); plot(MKPos(:,47),'r');hold on;plot(MKPosSmoothed(:,47),'g');title('Mk4 Hand y');grid;
subplot(3,4,12);plot(MKPos(:,48),'r');hold on;plot(MKPosSmoothed(:,48),'g');title('Mk4 Hand z');grid;

drawnow
%MKPosSmoothed = MKPos;