function T = rigid_transform_3D(A, B)
% rigid_transform_3D - obtains rigid motion given two sets of 3D points.
% Given a starting set of 3D points A, this function obtains the rigid
% transformation that maps them in a new set of 3D points B. Points are
% supposed to be organized in rows.
%
% Syntax:  [T] = rigid_transform_3D(A, B)
%
% Inputs:
%    A - starting set of 3D points;
%    B - final set of 3D points.
%
% Outputs:
%    T - rigid transformation that maps the set A into set B.
%
% Other m-files required: none.
% Subfunctions: none.
% MAT-files required: none.
%

% Author: Nghia Kien Ho
% email: nghiaho12 @ yahoo.com
% website: http://nghiaho.com/
% See also http://nghiaho.com/?page_id=671.

% header and description by: Edoardo Battaglia
% email: edoardobattaglia@yahoo.com


%------------- BEGIN CODE --------------

	if nargin ~= 2

		error('Missing parameters');

	end
	% Skipping error checking of input to reduce code clutter
	centroid_A = mean(A);

	centroid_B = mean(B);

    H = zeros(3,3);

	for i=1:size(A,1)
		H = H + ((A(i,:) - centroid_A)' * (B(i,:) - centroid_B));
        % NOTE: the transpose is on A, different to my tutorial due to convention used
	end

	[U,C,V] = svd(H);
 
	R = V*U';
    
    if det(R) < 0
		R(:,3) = R(:,3) * (-1);
    end
	C_A = eye(4,4);

	C_B = eye(4,4);

	R_new = eye(4,4);



	C_A(1:3, 4) = -centroid_A';

	R_new(1:3, 1:3) = R;

	C_B(1:3, 4) = centroid_B;



	T = C_B * R_new * C_A;

    
%------------- END of CODE --------------
end


