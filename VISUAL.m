    close all
    clear all
    clc
for index1 = 1 : 30
    for rep = 1 : 6 
    close all


    Subject = 'Mimma_30';

    %Filename = 'task7.dat';
    Task = ['_' num2str(index1)];
    Repetition = ['_' num2str(rep)];
    Filename = [Subject Task Repetition];    
        
    disp(['Exporting Video ' Filename]);

    existflag = exist(['datasets/' Filename '.dat']);
    
    if existflag ~= 2
        disp([Subject ' ' Filename ' does not exists'])
        continue
    end
    
    data = load(['datasets/' Filename '.dat']);
    IDS_Definition
    %MkSuppDimensions = [15 7]; %MkSuppDimensions = [15 7] = [Suppx Suppy]
    MkSuppDimensions = [15 7 22.5 55]; %MkSuppDimensions = [15 7 22.5 55] = [Suppx Suppy ParX ParZ]

    %dataset_reorg_UpperLimb_NoPlots
    dataset_reorg_UpperLimb_NoPlots
    MKPos=MKPosSmoothed;
    %MKPosSmoothed = MKPos;
    [NumFrame,~] = size(MKPosSmoothed); 
    % MKPos = zeros(NumFrame, 1);
    % 
    % for i = 1 : NumFrame
    %     tmp1 = cell2mat(RotatedData(i)); % export from the cell      
    %     tmp2 = tmp1([find(MkALL==ReferenceIDS(1)) find(MkALL==ReferenceIDS(2))...
    %                  find(MkALL==ReferenceIDS(3)) find(MkALL==ReferenceIDS(4))...
    %                  find(MkALL==ArmIDS(1))       find(MkALL==ArmIDS(2))...
    %                  find(MkALL==ArmIDS(3))       find(MkALL==ArmIDS(4))...
    %                  find(MkALL==ForearmIDS(1))   find(MkALL==ForearmIDS(2))...
    %                  find(MkALL==ForearmIDS(3))   find(MkALL==ForearmIDS(4))...
    %                  find(MkALL==HandIDS(1))      find(MkALL==HandIDS(2))...
    %                  find(MkALL==HandIDS(3))      find(MkALL==HandIDS(4))],:);
    %              
    % 
    %        for j = 1 : MkNOUL
    %            MKPos(i, 1 +(j-1)*3 : 3 +(j-1)*3) = tmp2(j,2:4);
    %        end
    % end
    % 

    load (['EstimatedAngles/EstimatedQArm' Filename '.mat'])
    load (['EstimatedParameters/UpperLimbParametersDEF' Subject '.mat'])
    %UpperLimbParametersDEF = [180 180 -40  0  40  180 0 20 155 50 5 0 300 225];
%UpperLimbParametersDEF = UpperLimbParametersDEF + [-50 80 0     0  0  0    0 0 0     30 0 0     0 0];
%UpperLimbParametersDEF = [30 170 -80     0  40  140    0 20 155    22  5 0    300 225];
%UpperLimbParametersDEF = [108.2569 174.7941 -50.3476 -6.7210 10.9731 131.3430 -14.1185 -0.2734 136.7899 49.4783 20.2631 -18.2123 285.5432 220.2431];


    %fv = stlread('Torso2.stl');
    %fv.vertices = fv.vertices*10;
    %UpperLimbParametersDEF = [40 240 -60 0 0 140 0 0 190 45 0 0 300 270];
        v = VideoWriter(['Videos/Reconstructed',Filename, '.avi']);
        open(v);
             figure;

    for i = 1%:NumFrame

        %close all
        clf;hold on;

        AnglesNow = EstimatedQ(:,i)*0 + [0.5 0 0 0 0 0 0]';
        MeasuresNow = MKPos(i,:)'; %column vector 48 elem
        EstimationsNow = hfun([UpperLimbParametersDEF MkSuppDimensions], AnglesNow); %column vector 36 elem


        %%%%%%%%%%%%%%%%%%%%%% Reference Sys Plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        plot3([0 30],[0 0],[0 0],'r','LineWidth',2)
        plot3([0 0],[0 30],[0 0],'g','LineWidth',2)
        plot3([0 0],[0 0],[0 30],'b','LineWidth',2)

        %%%%%%%%%%%%%%%% Estimated Positions of Joints %%%%%%%%%%%%%%%%%%%%%%%%
        TShoulder = gWorldS1fun([UpperLimbParametersDEF MkSuppDimensions], AnglesNow);
        DistWorldShoulder = TShoulder(1:3,4);
        TElbow = gWorldE1fun([UpperLimbParametersDEF MkSuppDimensions], AnglesNow);
        DistWorldElbow = TElbow(1:3,4);
        TElbow = gWorldE1fun([UpperLimbParametersDEF MkSuppDimensions], AnglesNow);
        DistWorldElbow = TElbow(1:3,4);
        TWrist = gWorldW1fun([UpperLimbParametersDEF MkSuppDimensions], AnglesNow);
        DistWorldWrist = TWrist(1:3,4);
        THand = gWorldHfun([UpperLimbParametersDEF MkSuppDimensions], AnglesNow);
        DistWorldHand = THand(1:3,4);


%         plot3([DistWorldShoulder(1) DistWorldElbow(1) DistWorldWrist(1) DistWorldHand(1)],...
%               [DistWorldShoulder(2) DistWorldElbow(2) DistWorldWrist(2) DistWorldHand(2)],...
%               [DistWorldShoulder(3) DistWorldElbow(3) DistWorldWrist(3) DistWorldHand(3)],'Color',[191/255 191/255 239/255],'LineWidth',10)

        plot3(DistWorldShoulder(1),DistWorldShoulder(2),DistWorldShoulder(3),'ok','MarkerSize',10,'MarkerFaceColor','k')
        plot3(DistWorldElbow(1),DistWorldElbow(2),DistWorldElbow(3),'ok','MarkerSize',10,'MarkerFaceColor','k')
        plot3(DistWorldWrist(1),DistWorldWrist(2),DistWorldWrist(3),'ok','MarkerSize',10,'MarkerFaceColor','k')

        %%%%%%%%%%%%%%%%%%% Star Positions (ESTIMED) %%%%%%%%%%%%%%%%%%%%%%%%%%
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

        plot3([StarLocalCoords(1,1) StarLocalCoords(2,1) StarLocalCoords(3,1) StarLocalCoords(4,1)],...
              [StarLocalCoords(1,2) StarLocalCoords(2,2) StarLocalCoords(3,2) StarLocalCoords(4,2)],...
              [StarLocalCoords(1,3) StarLocalCoords(2,3) StarLocalCoords(3,3) StarLocalCoords(4,3)],'kd','LineWidth',2)

        MeasuresNow = [StarLocalCoords(1,:)'; StarLocalCoords(2,:)'; StarLocalCoords(3,:)'; StarLocalCoords(4,:)';MeasuresNow];  
        EstimationsNow = [StarLocalCoords(1,:)'; StarLocalCoords(2,:)'; StarLocalCoords(3,:)'; StarLocalCoords(4,:)';EstimationsNow]; 
        %%%%%%%%%%%%%%%%%%% Star Positions (MEASURED) %%%%%%%%%%%%%%%%%%%%%%%%%
        plot3([MeasuresNow(1)],...
              [MeasuresNow(2)],...
              [MeasuresNow(3)],'r*','LineWidth',2)
        plot3([MeasuresNow(4)],...
              [MeasuresNow(5)],...
              [MeasuresNow(6)],'g*','LineWidth',2)
        plot3([MeasuresNow(7)],...
              [MeasuresNow(8)],...
              [MeasuresNow(9)],'b*','LineWidth',2)
        plot3([MeasuresNow(10)],...
              [MeasuresNow(11)],...
              [MeasuresNow(12)],'k*','LineWidth',2)  
          
        %%%%%%%%%%%%%% MEASURED Positions of Markers ARM %%%%%%%%%%%%%%%%%%%%%%
        plot3([MeasuresNow(13)],...
              [MeasuresNow(14)],...
              [MeasuresNow(15)],'r*','LineWidth',2)
        plot3([MeasuresNow(16)],...
              [MeasuresNow(17)],...
              [MeasuresNow(18)],'g*','LineWidth',2)
        plot3([MeasuresNow(19)],...
              [MeasuresNow(20)],...
              [MeasuresNow(21)],'b*','LineWidth',2)
        plot3([MeasuresNow(22)],...
              [MeasuresNow(23)],...
              [MeasuresNow(24)],'k*','LineWidth',2)
        plot3([MeasuresNow(25)],...
              [MeasuresNow(26)],...
              [MeasuresNow(27)],'y*','LineWidth',2)
        plot3([MeasuresNow(28)],...
              [MeasuresNow(29)],...
              [MeasuresNow(30)],'m*','LineWidth',2)      
          
        %%%%%%%%%%%% MEASURED Positions of Markers FOREARM %%%%%%%%%%%%%%%%%%%%
        plot3([MeasuresNow(31)],...
              [MeasuresNow(32)],...
              [MeasuresNow(33)],'r*','LineWidth',2)
        plot3([MeasuresNow(34)],...
              [MeasuresNow(35)],...
              [MeasuresNow(36)],'g*','LineWidth',2)
        plot3([MeasuresNow(37)],...
              [MeasuresNow(38)],...
              [MeasuresNow(39)],'b*','LineWidth',2)
        plot3([MeasuresNow(40)],...
              [MeasuresNow(41)],...
              [MeasuresNow(42)],'k*','LineWidth',2)
        plot3([MeasuresNow(43)],...
              [MeasuresNow(44)],...
              [MeasuresNow(45)],'y*','LineWidth',2)
        plot3([MeasuresNow(46)],...
              [MeasuresNow(47)],...
              [MeasuresNow(48)],'m*','LineWidth',2)    
          
        %%%%%%%%%%%%% MEASURED Positions of Markers HAND %%%%%%%%%%%%%%%%%%%%%%
        plot3([MeasuresNow(49)],...
              [MeasuresNow(50)],...
              [MeasuresNow(51)],'r*','LineWidth',2)
        plot3([MeasuresNow(52)],...
              [MeasuresNow(53)],...
              [MeasuresNow(54)],'g*','LineWidth',2)
        plot3([MeasuresNow(55)],...
              [MeasuresNow(56)],...
              [MeasuresNow(57)],'b*','LineWidth',2)
        plot3([MeasuresNow(58)],...
              [MeasuresNow(59)],...
              [MeasuresNow(60)],'k*','LineWidth',2) 
          
        %%%%%%%%%%%% ESTIMATED Positions of Markers ARM %%%%%%%%%%%%%%%%%%%%%%%
        plot3([EstimationsNow(13)],...
              [EstimationsNow(14)],...
              [EstimationsNow(15)],'ro','LineWidth',2)
        plot3([EstimationsNow(16)],...
              [EstimationsNow(17)],...
              [EstimationsNow(18)],'go','LineWidth',2)
        plot3([EstimationsNow(19)],...
              [EstimationsNow(20)],...
              [EstimationsNow(21)],'bo','LineWidth',2)
        plot3([EstimationsNow(22)],...
              [EstimationsNow(23)],...
              [EstimationsNow(24)],'ko','LineWidth',2)
        plot3([EstimationsNow(25)],...
              [EstimationsNow(26)],...
              [EstimationsNow(27)],'yo','LineWidth',2)
        plot3([EstimationsNow(28)],...
              [EstimationsNow(29)],...
              [EstimationsNow(30)],'mo','LineWidth',2)      

        %%%%%%%%%% ESTIMATED Positions of Markers FOREARM %%%%%%%%%%%%%%%%%%%%%         
        plot3([EstimationsNow(31)],...
              [EstimationsNow(32)],...
              [EstimationsNow(33)],'ro','LineWidth',2)
        plot3([EstimationsNow(34)],...
              [EstimationsNow(35)],...
              [EstimationsNow(36)],'go','LineWidth',2)
        plot3([EstimationsNow(37)],...
              [EstimationsNow(38)],...
              [EstimationsNow(39)],'bo','LineWidth',2)
        plot3([EstimationsNow(40)],...
              [EstimationsNow(41)],...
              [EstimationsNow(42)],'ko','LineWidth',2)
        plot3([EstimationsNow(43)],...
              [EstimationsNow(44)],...
              [EstimationsNow(45)],'yo','LineWidth',2)
        plot3([EstimationsNow(46)],...
              [EstimationsNow(47)],...
              [EstimationsNow(48)],'mo','LineWidth',2)  
          
         %%%%%%%%%%% ESTIMATED Positions of Markers HAND %%%%%%%%%%%%%%%%%%%%%%
        plot3([EstimationsNow(49)],...
              [EstimationsNow(50)],...
              [EstimationsNow(51)],'ro','LineWidth',2)
        plot3([EstimationsNow(52)],...
              [EstimationsNow(53)],...
              [EstimationsNow(54)],'go','LineWidth',2)
        plot3([EstimationsNow(55)],...
              [EstimationsNow(56)],...
              [EstimationsNow(57)],'bo','LineWidth',2)
        plot3([EstimationsNow(58)],...
              [EstimationsNow(59)],...
              [EstimationsNow(60)],'ko','LineWidth',2) 
          
    x = [DistWorldShoulder(1) DistWorldShoulder(1)      DistWorldShoulder(1)     DistWorldShoulder(1)];
    y = [DistWorldShoulder(2) DistWorldShoulder(2)-400  DistWorldShoulder(2)-400 DistWorldShoulder(2)];
    z = [DistWorldShoulder(3) DistWorldShoulder(3)      DistWorldShoulder(3)-100 DistWorldShoulder(3)-100];
    fill3(x,y,z,'yellow')

    x = [DistWorldShoulder(1) DistWorldShoulder(1)-600  DistWorldShoulder(1)-600 DistWorldShoulder(1)];
    y = [DistWorldShoulder(2) DistWorldShoulder(2)      DistWorldShoulder(2)     DistWorldShoulder(2)];
    z = [DistWorldShoulder(3) DistWorldShoulder(3)      DistWorldShoulder(3)-100 DistWorldShoulder(3)-100];
    fill3(x,y,z,'yellow')

    x = [DistWorldShoulder(1) DistWorldShoulder(1)      DistWorldShoulder(1)-600 DistWorldShoulder(1)-600];
    y = [DistWorldShoulder(2) DistWorldShoulder(2)-400  DistWorldShoulder(2)-400 DistWorldShoulder(2)];
    z = [DistWorldShoulder(3) DistWorldShoulder(3)      DistWorldShoulder(3)     DistWorldShoulder(3)];
    fill3(x,y,z,'yellow')

    % 
    % h = patch(fv,'FaceColor',       [0.8 0.8 1.0], ...
    %          'EdgeColor',       'none',        ...
    %          'FaceLighting',    'gouraud',     ...
    %          'AmbientStrength', 0.15);
    % camlight('headlight');
    % material('dull');

    %rotate(h,[1 0 0],-90)
    %rotate(h,[0 0 1],-90)

    axis( [-500 500 -300 500 -200 800])
    %view(91.6000,-50.8000) %back view
    %view(0,0) %top view
    %view(-83.6000,69.2000) %feet view
    %view(-90, 90) %front view
    %view(88.000, -15.6)
    view ( 130.8000,10)
    %view ( 90.4, -27.6)
    xlabel x; ylabel y; zlabel z;


    frame = getframe(gca,[0 0 450 420]);
    writeVideo(v,frame);  
    %disp (['Exported ' mat2str(i) ' of ' mat2str(NumFrame)])
    end
    %movie2avi(F,'myavifile.avi')
    close (v);
    end
end