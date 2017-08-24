function [T] = LEDadaptive_rigid_transform_3D(bodyIDs,PSdatak1,PSdatak2)
    % Step 1: find set of common LEDs between PSdatak1IDs and PSdatak2IDs
    T = NaN(4);
    PSdatak1IDs = PSdatak1(:,1)';
    PSdatak2IDs = PSdatak2(:,1)';
    
    
    IDandk1 = intersect(bodyIDs,PSdatak1IDs);
    IDandk2 = intersect(bodyIDs,PSdatak2IDs);
    target = intersect(IDandk1, IDandk2);
   
    if (max(size(target)) < 3)
        % then you can't do rigid3dtransform, and you keep T as NaN matrix
        return
    end
    
    % Step 2: find the rows to be used for rigid motion estimation
    [~,~,targetinK1] = intersect(target,PSdatak1IDs);
    [~,~,targetinK2] = intersect(target,PSdatak2IDs);
    
    T = rigid_transform_3D(PSdatak1(targetinK1,3:5), PSdatak2(targetinK2,3:5));
%T_IDs    
% sync_PS_data.values{i}(:,1)'
% You need a function that from these arguments can give you the rows of
% sync_PS_data.values{i} to take for the rigid transform estimation. It
% must also check if there are at least 3 valid rows.
end