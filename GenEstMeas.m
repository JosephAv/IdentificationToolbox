Lt(1) = Link('d', 0, 'a', 0, 'alpha', -pi/2);
if d==1 
    Lt(2) = Link('d', 0, 'a', a2, 'alpha', -pi/2);
else
    Lt(2) = Link('d', 0, 'a', a2, 'alpha', 0);
end
Lt(3) = Link('d', 0, 'a', a3, 'alpha', 0);
Lt(4) = Link('d', 0, 'a', a4, 'alpha', 0);

q1=stateEst(:,1);
q2=stateEst(:,2);
q3=stateEst(:,3);
q4=stateEst(:,4);

mi1x=measData(1+12*(d-1),:);
mi1y=measData(2+12*(d-1),:);
mi1z=measData(3+12*(d-1),:);

R=[1 0 0; 0 0 1; 0 -1 0]; 

% components of each marker in local frames (joint frame)
if d==1 
    mi2=R'*R'*[mi2x mi2y mi2z ]';
    mi3=R'*R'*[mi3x mi3y mi3z ]';
    mi4=R'*R'*[mi4x mi4y mi4z ]';
else
    mi2=R'*[mi2x mi2y mi2z ]';
    mi3=R'*[mi3x mi3y mi3z ]';
    mi4=R'*[mi4x mi4y mi4z ]';
end

mdt1io = [];
mdt2io = [];
mdt3io = [];
mdt4io = [];

%view(-90,90);
%view(160,10);
% generation of marker components from estimated angles
for i = 1:NTOT
    T_a=[1 0 0 mi1x(1,i)+ofx; 0 1 0 mi1y(1,i)+ofy; 0 0 1 mi1z(1,i)+ofz; 0 0 0 1]; 
    
    finger = SerialLink(Lt, 'name', 'I','base',T_a);
    
    [T all]= finger.fkine([q1(i), q2(i), q3(i), q4(i)]);
    
    mdt1=[mi1x(i);mi1y(i);mi1z(i)]; 
    mdt2=all(1:3,4,1)+all(1:3,1:3,2)*mi2;
    mdt3=all(1:3,4,2)+all(1:3,1:3,3)*mi3;
    mdt4=all(1:3,4,3)+all(1:3,1:3,4)*mi4;
    % estimated marker components
    mdt1io = [mdt1io; mdt1'];
    mdt2io = [mdt2io; mdt2'];
    mdt3io = [mdt3io; mdt3'];
    mdt4io = [mdt4io; mdt4'];        
end

% measured marker components 
mdt1i=measData(1+12*(d-1):3+12*(d-1),:)';
mdt2i=measData(4+12*(d-1):6+12*(d-1),:)';
mdt3i=measData(7+12*(d-1):9+12*(d-1),:)';
mdt4i=measData(10+12*(d-1):12+12*(d-1),:)';

for i = 1 : length(mdt1i)
    for j = 1:3
        if mdt1i(i,j) == 0
            mdt1i(i,j) = mdt1io(i,j);
        end
        if mdt2i(i,j) == 0
            mdt2i(i,j) = mdt2io(i,j);
        end
        if mdt3i(i,j) == 0
            mdt3i(i,j) = mdt3io(i,j);
        end
        if mdt4i(i,j) == 0
            mdt4i(i,j) = mdt4io(i,j);
        end        
    end
end


   % plot_sphere(mdt1 , 0.01);
   % plot_sphere(mdt2 , 0.01);
   % plot_sphere(mdt3 , 0.01);
   % plot_sphere(mdt4 , 0.01);