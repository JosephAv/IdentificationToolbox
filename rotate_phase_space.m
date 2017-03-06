% Rotate each marker measure (x y z) from phase space reference system to
% a standard reference frame

function[new_PS_data] = rotate_phase_space(old_PS_data,R0)
    new_PS_data = old_PS_data;
    for i = 1:size(old_PS_data.time,1) % dimension of structure
        for j = 1:size(old_PS_data.values{i},1) % number of markers
            new_PS_data.values{i}(j,3:end) = (R0*old_PS_data.values{i}(j,3:end)')';
        end
    end
end