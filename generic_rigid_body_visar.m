%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Obtain motion of a rigid body from PhaseSpace data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Author: Edoardo Battaglia
% email: e.battaglia@centropiaggio.unipi.it
% Modified on 26/02/2016

% clear all;
% close all;
% clc;

[folder,~,~] = fileparts(mfilename('fullpath'));
cd(folder);


%% Generate CAD data
% Note: remember to set the .stl file reference properly.
stl_name = ('dorsal_reference_decimated4p.stl');
disp('*********************');
disp('Loading STL...');
[CAD_F_rb, CAD_V_rb, CAD_C_rb] = load_cad(stl_name);
disp('Done!');
disp('*********************');
disp(' ')

%% Prepare marker data
% LED coordinates
% Each row is a marker x-y-z coordinate in the local .stl reference frame
% I suggest adding a comment to better identify the marker
nmarkers = 4;

M = [ 7.00000   15.5217  2.50000; ... %P1
      7.00000  -15.5217  2.50000; ... %P2
     -7.00000   15.5217  2.50000; ... %P3
     -7.00000  -15.5217  2.50000];    %P4
 
%% Load PhaseSpace data
% dat_name = 'tazzina'; %only BracceletMotiton 
disp('*********************');
disp('Loading PS data...');
first_imported_raw_PS_data = load_phase_space_data(dat_name); % OK (8x5 struct + time)
disp('Done!'); 
disp('*********************');
disp(' ')



%% If reference system is different from phase space system, apply rotation 
% Rotate all markers to move them in a standard reference frame
th=0;
R0 = [1     0           0 ; 
      0     cos(th)    -sin(th) ; 
      0     sin(th)     cos(th) ];
imported_raw_PS_data = rotate_phase_space(first_imported_raw_PS_data,R0);

% Structure with two fields:
%   - imported_raw_PS_data.time -> array containing N time entries;
%   - imported_raw_PS_data.values -> array of N cells, each cell contains
%   n_lx5 arrays, where n_l is the number of LEDs. The first column contains
%   LED IDs, the second column contains the conditioning number, the third,
%   4th and 5h columns contain x,y,z coordinates of the LED.



%% Rigid motion estimation
disp('*********************');
disp('Processing PS data...');
% Use the following lines to briefly describe the rigid body you wish to
% track.

% Rigid body: bracelet with 4 LED markers.
% This is the convention for LEDs IDs. 
%
%                    
% 		             
% 		             .-.  
%                .-.|   |.-. 
%               |   |   |   |    
%               |   |   |   |__  
%               |   |   |   |  | 
%               |   |   |   |  |
%           .-. |   |   |   |  |
%           \  \|              |
%            \  \              |
%             \                |
%              \              /
%               |            |
%               |            |
% 			             

% These are IDs as they actually were during acquisition.
% If desired you can put NaN for some markers to drop them.
ID_list = [ 8 10 ...
            9 5];

% capture2 list        
ID_list_marker = [ 4    6   11   7 ...
                   18   17  19  22 ...
                   31   29  35  34 ...
                   16   21  23  20 ...
                   33   32  28  30];
        
processed_PS_data = normalize_IDs(imported_raw_PS_data,ID_list);

processed_PS_data_marker = normalize_IDs(imported_raw_PS_data,ID_list_marker);

% Now processed_PS_data has the markers with IDs organized in such a way
% that the LED that appears in ID_list(i) has ID i.

% Retain only the desired LED markers. 
IMPORTANT_LEDs = find(~isnan(ID_list));
% Initial rigidbody posture
% Initial position for the LEDs in a PS like fashion
RB_0_PSlike = [(1:nmarkers)' ones(nmarkers,1) M];
% Rigid transform
t_0_RB = LEDadaptive_rigid_transform_3D(...
        1:nmarkers,RB_0_PSlike,processed_PS_data.values{1});
T_RB_ABS(:,:,1) = t_0_RB; 

for i = 2:size(processed_PS_data.values,2)
    T_RB_ABS(:,:,i) = LEDadaptive_rigid_transform_3D(...
        1:nmarkers,RB_0_PSlike,processed_PS_data.values{i});
end

disp('Done!');
disp('*********************');
disp(' ')


%% Smoothing and slerp
disp('*********************');
disp('Smoothing and slerp...')
% Interpolation with slerp (homogeneous matrices are converted by the
% function in quaternions, then converted back)
T_RB_ABS = homogeneous_matrix_interp(T_RB_ABS);

% Smoothing
for i = 1:size(T_RB_ABS,3)
    temp_Rot = T_RB_ABS(1:3,1:3,i);
    quat_RB_ABS(i,:) = dcm2quat(temp_Rot);
    pos_RB_ABS(i,:) = T_RB_ABS(1:3,4,i); 
end

quat_RB_ABS(:,1) = smooth(quat_RB_ABS(:,1));
quat_RB_ABS(:,2) = smooth(quat_RB_ABS(:,2));
quat_RB_ABS(:,3) = smooth(quat_RB_ABS(:,3));
quat_RB_ABS(:,4) = smooth(quat_RB_ABS(:,4));

pos_RB_ABS(:,1) = smooth(pos_RB_ABS(:,1));
pos_RB_ABS(:,2) = smooth(pos_RB_ABS(:,2));
pos_RB_ABS(:,3) = smooth(pos_RB_ABS(:,3));

for i = 1:size(T_RB_ABS,3)
    quat_RB_ABS(i,:) = quatnormalize(quat_RB_ABS(i,:));
    T_RB_ABS(1:3,1:3,i) = quat2dcm(quat_RB_ABS(i,:));
    T_RB_ABS(1:3,4,i) = pos_RB_ABS(i,:);
end
disp('Done!');
disp('*********************');
disp(' ')

% Convert marker components relative to bracelet
for i=1:size(processed_PS_data_marker.values,2)
    for j=1:size(processed_PS_data_marker.values{i},1)
        prov = inv(T_RB_ABS(:,:,i))*[processed_PS_data_marker.values{i}(j,3:5) 1]';
        processed_PS_data_marker.values{i}(j,3:5)=prov(1:3)';
    end 
end
frame = createFrame(processed_PS_data_marker);
ext = '.mat';
full_name = [dat_name ext];
save(full_name,'frame');

%% Motion visualization
% % Preliminary operations
% figure
% hold on;
% 
% x_col = [227 26 28]/255;
% y_col = [51 160 44]/255;
% z_col = [178 223 138]/255;
% coord_syst_colors = [x_col; y_col; z_col];
% draw_coordinate_system(35,eye(3),[0 0 0],coord_syst_colors)
% 
% grid on;
% 
% xmin = -600; 
% xmax = 600; 
% ymin = -600; 
% ymax = 600; 
% zmin = -600; 
% zmax = 600; 
% axis([xmin xmax ymin ymax zmin zmax])
% 
% % Define rigid body transformations
% t_RB = hgtransform('Parent',gca);
% set(t_RB,'Matrix',T_RB_ABS(:,:,1));
% 
% % Generate patch 3D representation from CAD data
% p_RB = patch('faces', CAD_F_rb, 'vertices' ,CAD_V_rb);
% set(p_RB,'Parent',t_RB);
% set(p_RB, 'facec', 'y');             % Set the face color (force it)
% set(p_RB, 'EdgeColor','none');       % Set the edge color
% light                                % add a default light
% daspect([1 1 1])                     % Setting the aspect ratio
% view(3)          
% 
% % Create sphere data for LEDs and contact point
% [x, y, z] = sphere(10);
% scaleLED = 3;
% xLED = scaleLED*x; yLED = scaleLED*y; zLED = scaleLED*z;
% LED_surf = surf(xLED, yLED, zLED);
% 
% % Obtain coordinates for LED points
% for i = 1:size(processed_PS_data.values,2)
%     for j = 1:size(processed_PS_data.values{i}(:,3:5),1)
%         LED_points_ABS{i}(j,:) = ...
%            processed_PS_data.values{i}(j,3:5);
%     end
%     
%     % Add NaN to complete the marker set when necessary (needed to handle
%     % missed markers)
%     for j = size(processed_PS_data.values{i}(:,3:5),1):nmarkers
%        if size(processed_PS_data.values{i}(:,3:5),1)<nmarkers
%            LED_points_ABS{i}(j,:) = ...
%            NaN(1,3);
%        end
%     end
% end
% 
% for i = 1:nmarkers
%     LED_points{i} = patch(surf2patch(LED_surf));
%     set(LED_points{i}, 'facec', 'r'); 
%     set(LED_points{i}, 'EdgeColor','none');       % Set the edge color
%     light                               % add a default light
% 
%     t_LED_points{i} = hgtransform('Parent',gca);
%     set(t_LED_points{i},'Matrix',[eye(3) LED_points_ABS{1}(i,:)';0 0 0 1])
%     set(LED_points{i},'Parent',t_LED_points{i});
% end
% delete(LED_surf);
% 
% scrsz = get(0, 'MonitorPositions');
% boxpos = [scrsz(3)*(1.8/3) scrsz(4)*(1.8/3) 120 70];
% stoploopmessage = [sprintf('Press to start.\n\nTime is: ') num2str(0) ...
%     sprintf(',\nSample is: 0.')];
% Fbox = stoploop(stoploopmessage, boxpos);
% while true
%     boxpos = get(Fbox.Handle(),'Position');
%     if Fbox.Stop()
%         stoploopmessage = [sprintf('Press to pause.\n\nTime is: ') num2str(0) ...
%     sprintf(',\nSample is: 0.')];
%         Fbox = stoploop(stoploopmessage, boxpos);
%         break;
%     end
% end
% 
% drawnow  
% 
% if ~exist('memorized_samples')
%     memorized_samples = [];
% end
% 
% while true
%     toskip = 1;
%     for i=2:toskip:size(processed_PS_data.values,2)
%         set(t_RB,'Matrix',T_RB_ABS(:,:,i));
% 
%         for j=1:nmarkers
%             set(t_LED_points{j},'Matrix',[eye(3) LED_points_ABS{i}(j,:)';0 0 0 1])
%         end
%        
%         msg_str = [sprintf('Press to pause.\n\nTimes is: ') ...
%             num2str(processed_PS_data.time(i)) '.'];
%     
%         Fbox.Message(msg_str);
%         boxpos = get(Fbox.Handle(),'Position');
% 
%         drawnow
%         
%         if Fbox.Stop()
% 
%             % Code to save time samples
%             ts_choice = MFquestdlg([0.8 0.8],...
%             [sprintf('Choose one.\n\nTime is: ') ...
%             num2str(processed_PS_data.time(i)) sprintf(',\n') ...
%             'Sample is: ' num2str(i) '.'], ...
%             'Paused', ...
%             'Save sample and continue', 'Continue without saving sample',...
%             'Continue without saving sample');
%                 
%             if strcmp(ts_choice, 'Save sample and continue')
%                 disp('Saving sample!');
%                 memorized_samples = [memorized_samples i];
%             end
%             Fbox = stoploop(msg_str, boxpos);   
%         end
%     end
% 
%     Fbox.Clear();
% 
%     quitflag = false;
%     scnsize=get(0,'ScreenSize');
%     choice = MFquestdlg([0.8 0.8],...
%         [sprintf('Done! Do you wish to continue?\n\nTime is: ') ...
%             num2str(processed_PS_data.time(i)) sprintf(',\nSample is: ') ...
%             num2str(i-1) '.'], ...
% 	'End', ...
% 	'Replay', 'Finish','Replay'); 
% 
%     switch choice
%         case 'Replay'
%             quitflag = false;
%         case 'Finish'
%             quitflag = true;
%     end    
%     if quitflag
%                 break
%     else
%         stoploopmessage = [sprintf('Press to pause.\n\nTime is: ') num2str(0) ',\n'...
%             sprintf('\nSample is: ') num2str(0) '.'];
%         Fbox = stoploop(stoploopmessage, boxpos);
%     end
    
                    
% end



