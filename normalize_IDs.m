function [organized_data] = normalize_IDs(mixed_data,ID_list)
% normalize_IDs - rearranges IDs in Phase Space data to a standard format
% This function takes data which is imported by load_phase_space_data, and
% rearranges the IDs in such a way that they correspond to a standard
% convention.
%
% This is the standard convention for the IDs (right hand as seen from the
% back).
%
%                   19 20
% 		            17 18
% 		   15 16     .-.      23 24
%          13 14 .-.|   |.-.  21 22
%               |   |   |   |    
%               |   |   |   |__  27 28
%               |   |   |   |  | 25 26
%               |   |   |   |  |
%     11 12 .-. |   |   |   |  |
%      9 10 \  \|              |
%            \  \              |
%             \                |
%              \              /
%               |  3      7  |
%               |2.|.4  6.|.8|
% 			       1      5
%
% LEDs will not in general follow it, this function modifies data so that
% they do.
%
% Syntax:  [organized_data] = normalize_IDs(mixed_data,ID_list)
%
% Inputs:
%    mixed_data - raw data imported by load_phase_space_data, which will in
%    general have IDs assigned randomly (how they are assigned must be
%    known);
%    ID_list - array (row or column) that defines how the IDs are assigned 
%    to LEDs in Phase Space. If the LEDs already follow the convention, 
%    ID_list will be qual to 1:33. If for some reason one of the LEDs was 
%    not working or not present during acquisition (and thus has no ID at 
%    all), ID_list is expected to contain NaN for that LED.

% Outputs:
%    organized_data - data with IDs conformed to the convention.
%
% Other m-files required: none.
% Subfunctions: none.
% MAT-files required: none.
%
% See also: load_phase_space_data.

% Author: Edoardo Battaglia
% email: e.battaglia@centropiaggio.unipi.it
% April 2013; Last revision: 08/22/2013

%------------- BEGIN CODE --------------
    organized_data = mixed_data;
    
    
    for i = 1:size(mixed_data.values,2) %number of cells
        
        % Counter for lost LEDs.
        lost_LEDs = 0;
        
        for j = 1:max(size(ID_list))
            current_ID_index = find(mixed_data.values{i}(:,1) == ID_list(j));
            
            if current_ID_index
                organized_data.values{i}(j-lost_LEDs,1) = j;                
            
                organized_data.values{i}(j-lost_LEDs,2:end) = ...
                    mixed_data.values{i}(current_ID_index,2:end);
            else
                % if current_ID_index returns false then it means that the 
                % LED was lost. It doesn't matter if it was lost only for
                % one step or always, the lost_LEDs counter needs to be
                % increased.
                lost_LEDs = lost_LEDs + 1;
            end
            
        end
        
        % Check if data has the required size. If there were excess LEDs
        % the size will be greater, and the last rows will be dropped.
        if size(organized_data.values{i},1) > ( j- lost_LEDs)
%             diff = size(organized_data.values{i},1) - ( j- lost_LEDs);
            organized_data.values{i}(j - lost_LEDs + 1:end,:) = [];
        end
        
    end


%------------- END OF CODE --------------
end