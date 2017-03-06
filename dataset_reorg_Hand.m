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
    if data(i,3) ~= 0
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

%% Define Local coords (h supp) % Mk IDs
               
StarLocalCoords = [ 7.00000   15.5217  2.50000; ... %P1
                    7.00000  -15.5217  2.50000; ... %P2
                   -7.00000   15.5217  2.50000; ... %P3
                   -7.00000  -15.5217  2.50000];    %P4
%% Rotate Data

RotatedData = cell(1,1);
aaa = [];
for j = 1:frame
    
    Frame_data = cell2mat(data1(j));
    IDs = Frame_data(:,1);
    Pos = Frame_data(:,2:end);    
     
    ReferencePos = Pos([find(IDs==HandIDS(1)) find(IDs==HandIDS(2)) find(IDs==HandIDS(3)) find(IDs==HandIDS(4))], :);
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
figure;hold on;
for i = 20
    data_frame_i = cell2mat(RotatedData(i));
    plot3(data_frame_i(j,2),data_frame_i(j,3),data_frame_i(j,4),'r*')
    %for j = 1 : length(data_frame_i(:,1))
        %if data_frame_i(j,1) == 47 || data_frame_i(j,1) == 40 || data_frame_i(j,1) == 42 || data_frame_i(j,1) == 43
        plot3(data_frame_i(2,2),data_frame_i(2,3),data_frame_i(2,4),'r*')  %id 5  %Hand
        plot3(data_frame_i(7,2),data_frame_i(7,3),data_frame_i(7,4),'g*')  %id 10
        plot3(data_frame_i(5,2),data_frame_i(5,3),data_frame_i(5,4),'b*')  %id 8
        plot3(data_frame_i(6,2),data_frame_i(6,3),data_frame_i(6,4),'k*')  %id 9
        
        plot3(data_frame_i(31,2),data_frame_i(31,3),data_frame_i(31,4),'r*')  %id 46  %forearm
        plot3(data_frame_i(30,2),data_frame_i(30,3),data_frame_i(30,4),'g*')  %id 45
        plot3(data_frame_i(26,2),data_frame_i(26,3),data_frame_i(26,4),'b*')  %id 41
        plot3(data_frame_i(29,2),data_frame_i(29,3),data_frame_i(29,4),'k*')  %id 44
        
        plot3(data_frame_i(27,2),data_frame_i(27,3),data_frame_i(27,4),'r*')  %id 42  %arm
        plot3(data_frame_i(28,2),data_frame_i(28,3),data_frame_i(28,4),'g*')  %id 43
        plot3(data_frame_i(25,2),data_frame_i(25,3),data_frame_i(25,4),'b*')  %id 40
        plot3(data_frame_i(32,2),data_frame_i(32,3),data_frame_i(32,4),'k*')  %id 47
        
        plot3(data_frame_i(33,2),data_frame_i(33,3),data_frame_i(33,4),'k*')  %id 52  %star
        plot3(data_frame_i(34,2),data_frame_i(34,3),data_frame_i(34,4),'k*')  %id 53
        plot3(data_frame_i(35,2),data_frame_i(35,3),data_frame_i(35,4),'k*')  %id 54
        plot3(data_frame_i(36,2),data_frame_i(36,3),data_frame_i(36,4),'k*')  %id 56

        %[i data_frame_i(j,2),data_frame_i(j,3),data_frame_i(j,4)]
        %end
    %end
    
end


plot3([0 100],[0 0],[0 0],'r')
plot3([0 0],[0 100],[0 0],'g')
plot3([0 0],[0 0],[0 100],'b')

%% Occlusion Statistics
% dirName = 'plots/ARM/';
% 
% OcclMK = [MkALL; zeros(1,MkNOALL)];
% MKNOFR = [];
% for i = 1 : frame
%     data_frame_i = cell2mat(RotatedData(i));
%     IDs = data_frame_i(:,1);
%     Pos = data_frame_i(:,2:end);     
%     [MkNum, ~] = size(data_frame_i);
%     MkNum1 = MkNum;
%     for k = 1:MkNum
%         if Pos(k,1) == 0
%             OcclMK(2,k) = OcclMK(2,k)+1;
%             MkNum1 = MkNum1-1;
%         end
%     end
%     MKNOFR = [MKNOFR MkNum1];
% end
% 
% plotName = ['MkOcclusionStatistics' Subject Filename];
% figure; bar(OcclMK(1,:),OcclMK(2,:)/frame*100);title('Statistics of Marker Occlusions in % of time span')
% 
% axis([0 60 0 100])
% ax = gca;
% ax.XTick = MkALL;
% ax.YTick = 0:10:100;
% xlabel ('Marker Number')
% ylabel ('% of occlusion time')
% 
% saveas(gcf,strcat(dirName,plotName,'.fig'));
% saveas(gcf,strcat(dirName,plotName,'.jpg'));
% 
% 
% plotName = ['NumberMkSeen' Subject Filename];
% 
% figure; plot(MKNOFR,'r*');title('Number of Marker Seen')
% xlabel ('Marker Number')
% ylabel ('Number of Marker Seen')
% saveas(gcf,strcat(dirName,plotName,'.fig'));
% saveas(gcf,strcat(dirName,plotName,'.jpg'));