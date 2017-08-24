function [data] = load_phase_space_data(filename)
% load_phase_space_data - load Phase Space data from filename.dat.
% This function loads phase space data from a .dat file called
% filename.dat.
%
% Syntax:  [data] = load_phase_space_data(filename)
%
% Inputs:
%    filename - name of the .dat file to be loaded, must be on path.
%
% Outputs:
%    data - data structure containing two fields:
%        .time = N time samples;
%        .values = N cells, each cell contains an nIDs x 5 matrix, where
%        nIDS is the number of LEDs (and thus IDs) that were used. The
%        first column contains IDs, the second column contains
%        conditioning numbers, while columns 3-5 contain x,y,z coordinates
%        for each LED (it is the native structure from the Phase Space
%        system).
%
% Other m-files required: none.
% Subfunctions: none.
% MAT-files required: none.
%

% Author: Edoardo Battaglia
% email: e.battaglia@centropiaggio.unipi.it
% April 2013; Last revision: 04/02/2013

%------------- BEGIN CODE --------------

    % Load raw data
    extension = '.dat';
    full_name = [filename extension];
    if ~(exist('RawData','var'))
        RawData = load(full_name);
    end
    
    % Move all points toward the global centroid (to make visualization
    % simpler if reference frame changes)
%    nonzeroRawDataPoints = RawData(:,3:end);
%    dropzeros = [];
%    for i = 1:size(RawData,1)
%        if ~nonzeroRawDataPoints(i,:)
%            dropzeros = [dropzeros i];
%        end
%    end
%    nonzeroRawDataPoints(dropzeros,:) = [];
%    centroid = point_centroid(nonzeroRawDataPoints);
%    for i = 1:size(RawData,1)
%        if RawData(i,3:end)
%            RawData(i,3:end) = RawData(i,3:end) - centroid;
%            RawData(i,4) = RawData(i,4) + 300;
%        end
%    end
    
    
    % delete last row (contains zero LEDs)
    % Not true anymore!
%     RawData(end,:) = [];
    
    %% Organize data for position tracking
    % First step: reorganize PS coordinates to make more sense form a
    % physical point of view.
%     RawData_buffer = RawData;
%     RawData(:,3) = RawData_buffer(:,5); % x = z_PS;
%     RawData(:,4) = RawData_buffer(:,3); % y = x_PS;
%     RawData(:,5) = -RawData_buffer(:,4); % z = y_PS;
%     
    % Extract time vector
    time = zeros(1);
    for i = 1:size(RawData,1)
        if norm(RawData(i,3:5)) == 0
            time = [time; RawData(i,1)];
        end
    end
    time(1) = [];

    % Extrac led IDs
    %RawData_1st = RawData(:,1);
    %isID = logical(RawData(:,3));
    %IDs = unique(RawData_1st(isID));

    % Extract position data: uses the native Phase Space structure, but divides
    % data into cells (a cell for each frame)
    % Note that not every frame has all LEDs, and therefore not every frame has
    % all IDs
    i = 1;
    k = 1;
    pos_data = cell(1,size(time,1));
    
    while i <= size(RawData,1)
        while norm(RawData(i,3:5)) 
            pos_data{k} = [pos_data{k}; RawData(i,:)];
            i = i + 1;
        end
    % size(pos_data{k})
    k = k + 1;
    i = i + 1;
    end
    
    data.time = time;
    data.values = pos_data;
    
%------------- END OF CODE --------------
end