gWorldS2=[cos(q1),(-1).*cos(q2).*sin(q1),sin(q1).*sin(q2),DX.*(1+(-1).*cos(q1))+ ...
  DX.*cos(q1)+DY.*sin(q1)+(-1).*DY.*cos(q2).*sin(q1)+DZ.*sin(q1).*sin(q2)+ ...
  (-1).*sin(q1).*(DY.*(1+(-1).*cos(q2))+DZ.*sin(q2));sin(q1),cos(q1).*cos( ...
  q2),(-1).*cos(q1).*sin(q2),DY.*(1+(-1).*cos(q1))+DY.*cos(q1).*cos(q2)+( ...
  -1).*DZ.*cos(q1).*sin(q2)+cos(q1).*(DY.*(1+(-1).*cos(q2))+DZ.*sin(q2)); ...
  0,sin(q2),cos(q2),DZ.*(1+(-1).*cos(q2))+DZ.*cos(q2);0,0,0,1];
