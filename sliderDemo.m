function sliderDemo

    f = figure(1);

    %// Some simple to plot function (with tuneable parameter)
    %x = 0:0.1:2*pi;
    %y = @(A) A*sin(x);

    %// Make initial plot
    %A = 1;
    %p = plot(x, y(A));
    y = @(index) visual_fun(index);
    index = 1;
    %p = visual_fun(index);
    set(gca, 'position', [0.1 0.25 0.85 0.7]);

Subject = 'Giuseppe';
Task = '9';

data = load(['datasets/' Task '.dat']);
ReferenceIDS = [];
ArmIDS = [];
ForearmIDS = [];
HandIDS = [];
ThumbIDS= [];
IndexIDS= [];
MiddleIDS= [];
RingIDS = [];
LittleIDS = [];
MkALL = [];
MkIDS_UL = [];
MkNOALL = [];
MkNOUL = [];
ndata = [];
ndata1 = [];
MkNUMBER = [];
frame = [];
data1 = [];
data2 = [];
i = [];
n1 = [];
n2 = [];
IDnow = [];
missids = [];
l = [];
aux = [];
RotatedData = [];
j = [];
Frame_data = [];
IDs = [];
Pos = [];
ReferencePos = [];
ReferenceNMK = [];
ReferenceNMK1 = [];
Ropt = [];
dopt = [];
dopt1 = [];
T_hom_inv = [];
MkNum = [];
MkNum1 = [];
Rotated_frame_data = [];
k = [];
rotatedv = [];
NewFrame = [];
tmp1 = [];
tmp2 = [];
UpperLimbParametersDEF = [];
IDS_Definition1;

MkSuppDimensions = [15 7 22.5 55];

dataset_reorg_UpperLimb_NoPlots1

MKPosSmoothed = MKPos;
[NumFrame,~] = size(MKPosSmoothed); 

load (['EstimatedAngles/EstimatedQArm' Subject Task '.mat'])
load (['EstimatedParameters/UpperLimbParametersDEF' Subject '.mat'])


    AnglesNow = EstimatedQ(:,index);%*0 + [0 0 0 0 0 0 0]';
    MeasuresNow = MKPos(index,:)'; %column vector 48 elem
    EstimationsNow = hfun([UpperLimbParametersDEF MkSuppDimensions], AnglesNow); %column vector 36 elem


    %%%%%%%%%%%%%%%%%%%%%% Reference Sys Plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    p1 = plot3([0 30],[0 0],[0 0],'r','LineWidth',2);
    hold on
    p2 = plot3([0 0],[0 30],[0 0],'g','LineWidth',2);
    p3 = plot3([0 0],[0 0],[0 30],'b','LineWidth',2);
    
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


    p4 = plot3([DistWorldShoulder(1) DistWorldElbow(1) DistWorldWrist(1) DistWorldHand(1)],...
          [DistWorldShoulder(2) DistWorldElbow(2) DistWorldWrist(2) DistWorldHand(2)],...
          [DistWorldShoulder(3) DistWorldElbow(3) DistWorldWrist(3) DistWorldHand(3)],'Color',[191/255 191/255 239/255],'LineWidth',10);
          
    p5 = plot3(DistWorldShoulder(1),DistWorldShoulder(2),DistWorldShoulder(3),'ok','MarkerSize',20,'MarkerFaceColor','k');
    p6 = plot3(DistWorldElbow(1),DistWorldElbow(2),DistWorldElbow(3),'ok','MarkerSize',20,'MarkerFaceColor','k');
    p7 = plot3(DistWorldWrist(1),DistWorldWrist(2),DistWorldWrist(3),'ok','MarkerSize',20,'MarkerFaceColor','k');
    
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
                   
    p8 = plot3([StarLocalCoords(1,1) StarLocalCoords(2,1) StarLocalCoords(3,1) StarLocalCoords(4,1)],...
          [StarLocalCoords(1,2) StarLocalCoords(2,2) StarLocalCoords(3,2) StarLocalCoords(4,2)],...
          [StarLocalCoords(1,3) StarLocalCoords(2,3) StarLocalCoords(3,3) StarLocalCoords(4,3)],'kd','LineWidth',2);

    MeasuresNow = [StarLocalCoords(1,:)'; StarLocalCoords(2,:)'; StarLocalCoords(3,:)'; StarLocalCoords(4,:)';MeasuresNow];  
    EstimationsNow = [StarLocalCoords(1,:)'; StarLocalCoords(2,:)'; StarLocalCoords(3,:)'; StarLocalCoords(4,:)';EstimationsNow]; 
    %%%%%%%%%%%%%%%%%%% Star Positions (MEASURED) %%%%%%%%%%%%%%%%%%%%%%%%%
    p9 = plot3([MeasuresNow(1) MeasuresNow(4) MeasuresNow(7) MeasuresNow(10)],...
          [MeasuresNow(2) MeasuresNow(5) MeasuresNow(8) MeasuresNow(11)],...
          [MeasuresNow(3) MeasuresNow(6) MeasuresNow(9) MeasuresNow(12)],'r*','LineWidth',2);

    %%%%%%%%%%%%%% MEASURED Positions of Markers ARM %%%%%%%%%%%%%%%%%%%%%%
    p10 = plot3([MeasuresNow(13) MeasuresNow(16) MeasuresNow(19) MeasuresNow(22) MeasuresNow(25) MeasuresNow(28)],...
          [MeasuresNow(14) MeasuresNow(17) MeasuresNow(20) MeasuresNow(23) MeasuresNow(26) MeasuresNow(29)],...
          [MeasuresNow(15) MeasuresNow(18) MeasuresNow(21) MeasuresNow(24) MeasuresNow(27) MeasuresNow(30)],'r*','LineWidth',2);
    
    %%%%%%%%%%%% MEASURED Positions of Markers FOREARM %%%%%%%%%%%%%%%%%%%%
    p11 = plot3([MeasuresNow(31) MeasuresNow(34) MeasuresNow(37) MeasuresNow(40) MeasuresNow(43) MeasuresNow(46)],...
          [MeasuresNow(32) MeasuresNow(35) MeasuresNow(38) MeasuresNow(41) MeasuresNow(44) MeasuresNow(47)],...
          [MeasuresNow(33) MeasuresNow(36) MeasuresNow(39) MeasuresNow(42) MeasuresNow(45) MeasuresNow(48)],'r*','LineWidth',2);

    %%%%%%%%%%%%% MEASURED Positions of Markers HAND %%%%%%%%%%%%%%%%%%%%%%
    p12 = plot3([MeasuresNow(49) MeasuresNow(52) MeasuresNow(55) MeasuresNow(58)],...
          [MeasuresNow(50) MeasuresNow(53) MeasuresNow(56) MeasuresNow(59)],...
          [MeasuresNow(51) MeasuresNow(54) MeasuresNow(57) MeasuresNow(60)],'r*','LineWidth',2);
            
    %%%%%%%%%%%% ESTIMATED Positions of Markers ARM %%%%%%%%%%%%%%%%%%%%%%%
    p13 = plot3([EstimationsNow(13) EstimationsNow(16) EstimationsNow(19) EstimationsNow(22) EstimationsNow(25) EstimationsNow(28)],...
          [EstimationsNow(14) EstimationsNow(17) EstimationsNow(20) EstimationsNow(23) EstimationsNow(26) EstimationsNow(29)],...
          [EstimationsNow(15) EstimationsNow(18) EstimationsNow(21) EstimationsNow(24) EstimationsNow(27) EstimationsNow(30)],'kd','LineWidth',2);
    
    %%%%%%%%%% ESTIMATED Positions of Markers FOREARM %%%%%%%%%%%%%%%%%%%%%         
    p14 = plot3([EstimationsNow(31) EstimationsNow(34) EstimationsNow(37) EstimationsNow(40) EstimationsNow(43) EstimationsNow(46)],...
          [EstimationsNow(32) EstimationsNow(35) EstimationsNow(38) EstimationsNow(41) EstimationsNow(44) EstimationsNow(47)],...
          [EstimationsNow(33) EstimationsNow(36) EstimationsNow(39) EstimationsNow(42) EstimationsNow(45) EstimationsNow(48)],'kd','LineWidth',2);    
      
     %%%%%%%%%%% ESTIMATED Positions of Markers HAND %%%%%%%%%%%%%%%%%%%%%%
        
    p15 = plot3([EstimationsNow(49) EstimationsNow(52) EstimationsNow(55) EstimationsNow(58)],...
          [EstimationsNow(50) EstimationsNow(53) EstimationsNow(56) EstimationsNow(59)],...
          [EstimationsNow(51) EstimationsNow(54) EstimationsNow(57) EstimationsNow(60)],'kd','LineWidth',2);
  
      
x = [DistWorldShoulder(1) DistWorldShoulder(1)      DistWorldShoulder(1)     DistWorldShoulder(1)];
y = [DistWorldShoulder(2) DistWorldShoulder(2)-400  DistWorldShoulder(2)-400 DistWorldShoulder(2)];
z = [DistWorldShoulder(3) DistWorldShoulder(3)      DistWorldShoulder(3)-100 DistWorldShoulder(3)-100];
p16 = fill3(x,y,z,'yellow');

x = [DistWorldShoulder(1) DistWorldShoulder(1)-600  DistWorldShoulder(1)-600 DistWorldShoulder(1)];
y = [DistWorldShoulder(2) DistWorldShoulder(2)      DistWorldShoulder(2)     DistWorldShoulder(2)];
z = [DistWorldShoulder(3) DistWorldShoulder(3)      DistWorldShoulder(3)-100 DistWorldShoulder(3)-100];
p17 = fill3(x,y,z,'yellow');

x = [DistWorldShoulder(1) DistWorldShoulder(1)      DistWorldShoulder(1)-600 DistWorldShoulder(1)-600];
y = [DistWorldShoulder(2) DistWorldShoulder(2)-400  DistWorldShoulder(2)-400 DistWorldShoulder(2)];
z = [DistWorldShoulder(3) DistWorldShoulder(3)      DistWorldShoulder(3)     DistWorldShoulder(3)];
p18 = fill3(x,y,z,'yellow');

%     axis tight
%     axis([0 2*pi -10 10])
axis( [-500 500 -300 500 -200 800])
    %// re-position the axes to make room for the slider
    set(gca, 'position', [0.1 0.25 0.85 0.7]);

    %// initialize the slider
    h = uicontrol(...
        'parent'  , f,...        
        'units'   , 'normalized',...    %// so yo don't have to f*ck with pixels
        'style'   , 'slider',...        
        'position', [0.05 0.05 0.9 0.05],...
        'min'     , 1,...               %// Make the A between 1...
        'max'     , 1500,...              %// and 10, with initial value
        'value'   , index,...           %// as set above.
        'callback', @sliderCallback);   %// This is called when using the arrows
                                        %// and/or when clicking the slider bar


    %// THE MAGIC INGREDIENT
    %// ===========================

    %xhLstn = handle.listener(h,'ActionEvent',@sliderCallback); %#ok<NASGU>
    addlistener(h,'ContinuousValueChange',@sliderCallback);

    %// (variable appears unused, but not assigning it to anything means that 
    %// the listener is stored in the 'ans' variable. If "ans" is overwritten, 
    %// the listener goes out of scope and is thus destroyed, and thus, it no 
    %// longer works.

    %// ===========================


    %// The slider's callback:
    %//    1) clears the old plot
    %//    2) computes new values using the (continuously) updated slider values
    %//    3) re-draw the plot and re-set the axes settings
    function sliderCallback(~,~)
        %delete(p);
        %delete(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18)
        clear p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12 p13 p14 p15 p16 p17 p18
        pippo=floor(get(h,'value'))
        index = pippo
        set(gca, 'position', [0.1 0.25 0.85 0.7]);

Subject = 'Giuseppe';
Task = '9';

data = load(['datasets/' Task '.dat']);
IDS_Definition1;

MkSuppDimensions = [15 7 22.5 55];

dataset_reorg_UpperLimb_NoPlots1

MKPosSmoothed = MKPos;
[NumFrame,~] = size(MKPosSmoothed); 

load (['EstimatedAngles/EstimatedQArm' Subject Task '.mat'])
load (['EstimatedParameters/UpperLimbParametersDEF' Subject '.mat'])


    AnglesNow = EstimatedQ(:,index);%*0 + [0 0 0 0 0 0 0]';
    MeasuresNow = MKPos(index,:)'; %column vector 48 elem
    EstimationsNow = hfun([UpperLimbParametersDEF MkSuppDimensions], AnglesNow); %column vector 36 elem


    %%%%%%%%%%%%%%%%%%%%%% Reference Sys Plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    p1 = plot3([0 30],[0 0],[0 0],'r','LineWidth',2);
    hold on
    p2 = plot3([0 0],[0 30],[0 0],'g','LineWidth',2);
    p3 = plot3([0 0],[0 0],[0 30],'b','LineWidth',2);
    
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


    p4 = plot3([DistWorldShoulder(1) DistWorldElbow(1) DistWorldWrist(1) DistWorldHand(1)],...
          [DistWorldShoulder(2) DistWorldElbow(2) DistWorldWrist(2) DistWorldHand(2)],...
          [DistWorldShoulder(3) DistWorldElbow(3) DistWorldWrist(3) DistWorldHand(3)],'Color',[191/255 191/255 239/255],'LineWidth',10);
          
    p5 = plot3(DistWorldShoulder(1),DistWorldShoulder(2),DistWorldShoulder(3),'ok','MarkerSize',20,'MarkerFaceColor','k');
    p6 = plot3(DistWorldElbow(1),DistWorldElbow(2),DistWorldElbow(3),'ok','MarkerSize',20,'MarkerFaceColor','k');
    p7 = plot3(DistWorldWrist(1),DistWorldWrist(2),DistWorldWrist(3),'ok','MarkerSize',20,'MarkerFaceColor','k');
    
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
                   
    p8 = plot3([StarLocalCoords(1,1) StarLocalCoords(2,1) StarLocalCoords(3,1) StarLocalCoords(4,1)],...
          [StarLocalCoords(1,2) StarLocalCoords(2,2) StarLocalCoords(3,2) StarLocalCoords(4,2)],...
          [StarLocalCoords(1,3) StarLocalCoords(2,3) StarLocalCoords(3,3) StarLocalCoords(4,3)],'kd','LineWidth',2);

    MeasuresNow = [StarLocalCoords(1,:)'; StarLocalCoords(2,:)'; StarLocalCoords(3,:)'; StarLocalCoords(4,:)';MeasuresNow];  
    EstimationsNow = [StarLocalCoords(1,:)'; StarLocalCoords(2,:)'; StarLocalCoords(3,:)'; StarLocalCoords(4,:)';EstimationsNow]; 
    %%%%%%%%%%%%%%%%%%% Star Positions (MEASURED) %%%%%%%%%%%%%%%%%%%%%%%%%
    p9 = plot3([MeasuresNow(1) MeasuresNow(4) MeasuresNow(7) MeasuresNow(10)],...
          [MeasuresNow(2) MeasuresNow(5) MeasuresNow(8) MeasuresNow(11)],...
          [MeasuresNow(3) MeasuresNow(6) MeasuresNow(9) MeasuresNow(12)],'r*','LineWidth',2);

    %%%%%%%%%%%%%% MEASURED Positions of Markers ARM %%%%%%%%%%%%%%%%%%%%%%
    p10 = plot3([MeasuresNow(13) MeasuresNow(16) MeasuresNow(19) MeasuresNow(22) MeasuresNow(25) MeasuresNow(28)],...
          [MeasuresNow(14) MeasuresNow(17) MeasuresNow(20) MeasuresNow(23) MeasuresNow(26) MeasuresNow(29)],...
          [MeasuresNow(15) MeasuresNow(18) MeasuresNow(21) MeasuresNow(24) MeasuresNow(27) MeasuresNow(30)],'r*','LineWidth',2);
    
    %%%%%%%%%%%% MEASURED Positions of Markers FOREARM %%%%%%%%%%%%%%%%%%%%
    p11 = plot3([MeasuresNow(31) MeasuresNow(34) MeasuresNow(37) MeasuresNow(40) MeasuresNow(43) MeasuresNow(46)],...
          [MeasuresNow(32) MeasuresNow(35) MeasuresNow(38) MeasuresNow(41) MeasuresNow(44) MeasuresNow(47)],...
          [MeasuresNow(33) MeasuresNow(36) MeasuresNow(39) MeasuresNow(42) MeasuresNow(45) MeasuresNow(48)],'r*','LineWidth',2);

    %%%%%%%%%%%%% MEASURED Positions of Markers HAND %%%%%%%%%%%%%%%%%%%%%%
    p12 = plot3([MeasuresNow(49) MeasuresNow(52) MeasuresNow(55) MeasuresNow(58)],...
          [MeasuresNow(50) MeasuresNow(53) MeasuresNow(56) MeasuresNow(59)],...
          [MeasuresNow(51) MeasuresNow(54) MeasuresNow(57) MeasuresNow(60)],'r*','LineWidth',2);
            
    %%%%%%%%%%%% ESTIMATED Positions of Markers ARM %%%%%%%%%%%%%%%%%%%%%%%
    p13 = plot3([EstimationsNow(13) EstimationsNow(16) EstimationsNow(19) EstimationsNow(22) EstimationsNow(25) EstimationsNow(28)],...
          [EstimationsNow(14) EstimationsNow(17) EstimationsNow(20) EstimationsNow(23) EstimationsNow(26) EstimationsNow(29)],...
          [EstimationsNow(15) EstimationsNow(18) EstimationsNow(21) EstimationsNow(24) EstimationsNow(27) EstimationsNow(30)],'kd','LineWidth',2);
    
    %%%%%%%%%% ESTIMATED Positions of Markers FOREARM %%%%%%%%%%%%%%%%%%%%%         
    p14 = plot3([EstimationsNow(31) EstimationsNow(34) EstimationsNow(37) EstimationsNow(40) EstimationsNow(43) EstimationsNow(46)],...
          [EstimationsNow(32) EstimationsNow(35) EstimationsNow(38) EstimationsNow(41) EstimationsNow(44) EstimationsNow(47)],...
          [EstimationsNow(33) EstimationsNow(36) EstimationsNow(39) EstimationsNow(42) EstimationsNow(45) EstimationsNow(48)],'kd','LineWidth',2);    
      
     %%%%%%%%%%% ESTIMATED Positions of Markers HAND %%%%%%%%%%%%%%%%%%%%%%
        
    p15 = plot3([EstimationsNow(49) EstimationsNow(52) EstimationsNow(55) EstimationsNow(58)],...
          [EstimationsNow(50) EstimationsNow(53) EstimationsNow(56) EstimationsNow(59)],...
          [EstimationsNow(51) EstimationsNow(54) EstimationsNow(57) EstimationsNow(60)],'kd','LineWidth',2);
  
      
x = [DistWorldShoulder(1) DistWorldShoulder(1)      DistWorldShoulder(1)     DistWorldShoulder(1)];
y = [DistWorldShoulder(2) DistWorldShoulder(2)-400  DistWorldShoulder(2)-400 DistWorldShoulder(2)];
z = [DistWorldShoulder(3) DistWorldShoulder(3)      DistWorldShoulder(3)-100 DistWorldShoulder(3)-100];
p16 = fill3(x,y,z,'yellow');

x = [DistWorldShoulder(1) DistWorldShoulder(1)-600  DistWorldShoulder(1)-600 DistWorldShoulder(1)];
y = [DistWorldShoulder(2) DistWorldShoulder(2)      DistWorldShoulder(2)     DistWorldShoulder(2)];
z = [DistWorldShoulder(3) DistWorldShoulder(3)      DistWorldShoulder(3)-100 DistWorldShoulder(3)-100];
p17 = fill3(x,y,z,'yellow');

x = [DistWorldShoulder(1) DistWorldShoulder(1)      DistWorldShoulder(1)-600 DistWorldShoulder(1)-600];
y = [DistWorldShoulder(2) DistWorldShoulder(2)-400  DistWorldShoulder(2)-400 DistWorldShoulder(2)];
z = [DistWorldShoulder(3) DistWorldShoulder(3)      DistWorldShoulder(3)     DistWorldShoulder(3)];
p18 = fill3(x,y,z,'yellow');

        %delete( p)
        %p = plot(x, y(get(h,'value')));
        p = visual_fun(floor(get(h,'value')))
%         axis tight
%         axis([0 2*pi -10 10])
%axis( [-500 500 -300 500 -200 800])
%view ( 109.2000,-3.6)
    %set(gca, 'position', [0.1 0.25 0.85 0.7]);

    end

    function IDS_Definition1
        IDS_Definition
    end
    function dataset_reorg_UpperLimb_NoPlots1
        dataset_reorg_UpperLimb_NoPlots
    end
end