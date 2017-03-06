function [T_filled] = homogeneous_matrix_interp(T)
    T_filled = T;
    
    i = 1;
    tostart = false;
    while i <= size(T,3)
        
        % Find the first NaN matrix, leave the rest as it is
        if ~isnan(T(:,:,i))
            tostart = true;
        end
        
        if (isnan(T(:,:,i)))
            if tostart
                while(isnan(T(:,:,i)))
                    i = i + 1;
                    if i>size(T_filled,3)
                        return
                    end
                end
                i_end = i;
                T_filled(:,:,i_start:i_end) = block_slerp(T(:,:,i_start:i_end));
        
            else
                i = i + 1;
            end
        end
        
        i_start = i;
        i = i +1;
    end
end