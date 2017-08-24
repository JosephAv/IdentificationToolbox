function [c,ceq] = NonLinConstr(x, MeasHand,IND_for_Calib, MkSuppDimensions)

NumericParameters = [x(1:14) MkSuppDimensions];

j = 0;
KinVectHAND = [];
for i = IND_for_Calib
    j=j+1;
    qnum = x(9+(j-1)*7 : 8+(j)*7);
    
    hn = hfun(NumericParameters, qnum);

    KinVectHAND = [KinVectHAND; hn];%hn(end-12:end)];
end 


ceq = KinVectHAND -  MeasHand;   % Compute nonlinear equalities at x.


c = [];     % Compute nonlinear inequalities at x.
end