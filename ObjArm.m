function ObjVal = ObjArm( x, meas, IND_for_Calib,MkSuppDimensions)
%objective function
%x = [par, angles]

syms q1 q2 q3 q4 q5 q6 q7 
syms L1 L2 DX DY DZ DX1 DY1 DZ1 DX2 DY2 DZ2 DX3 DY3 DZ3 Suppx Suppy ParX ParZ

%remember SymbolicParameters = [DX DY DZ DX1 DY1 DZ1 DX2 DY2 DZ2 DX3 DY3 DZ3 L1 L2 Suppx Suppy];


SymbolicParameters = [DX DY DZ DX1 DY1 DZ1 DX2 DY2 DZ2 DX3 DY3 DZ3 L1 L2 Suppx Suppy ParX ParZ];
qsym = [q1 q2 q3 q4 q5 q6 q7];
Nframe = length(IND_for_Calib);
NumericParameters = [x(1:14) MkSuppDimensions]; %MkSuppDimensions = [15 7] = [Suppx Suppy]
Error=[];

%AddedAngle = x(15);

j = 0;
KinVectAll = [];
for i = IND_for_Calib
    j=j+1;
    qnum = x(15+(j-1)*7 : 14+(j)*7);
    %qnum = x(16+(j-1)*7 : 15+(j)*7);
    
    hn = hfun(NumericParameters, qnum);
    
%     hn(1) = hn(1) + 50*sin(AddedAngle); hn(2) = hn(2) + 50*cos(AddedAngle);
%     hn(4) = hn(4) + 50*sin(AddedAngle); hn(5) = hn(5) + 50*cos(AddedAngle);
%     hn(7) = hn(7) + 50*sin(AddedAngle); hn(8) = hn(8) + 50*cos(AddedAngle);
%     hn(10) = hn(10) + 50*sin(AddedAngle); hn(11) = hn(11) + 50*cos(AddedAngle);
%     hn(13) = hn(13) + 50*sin(AddedAngle); hn(14) = hn(14) + 50*cos(AddedAngle);
%     hn(16) = hn(16) + 50*sin(AddedAngle); hn(17) = hn(17) + 50*cos(AddedAngle);


    
%     measnow = meas(:,i);
% 
%     for k = 1 : length (hn)
%         if measnow(k) == 0
%             measnow(k) = hn(k);
%         end
%     end
    
%     error = hn-measnow;
%     i
%     [error(1:3) error(end-2:end)] ;
%     error(end-12:end) = error(end-12:end)*100;
% 
%     Error = [Error; error];
    KinVectAll = [KinVectAll; hn];
end 
    Error = zeros(length(KinVectAll),1);
    for j = 1 : length(KinVectAll)
        if meas(j) ~= 0
            Error(j) = KinVectAll(j) - meas(j);
        end
    end
    %Error = KinVectAll - meas;

    ObjVal = sum(abs(Error))/Nframe;
    %ObjVal
end

