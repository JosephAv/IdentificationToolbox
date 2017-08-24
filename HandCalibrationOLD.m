close all
clear 
clc

global   Nframe
%%%%%%%%%%%%%%%
Nframe   = 30; 
%%%%%%%%%%%%%%%
directory = 'datasets/';
Subject = 'Giuseppe';
Thumb_Dataset = 'kmo1.mat';
Index_Dataset = 'kio1.mat';
Middle_Dataset = 'kmo1.mat';
Ring_Dataset = 'kio1.mat';
Little_Dataset = 'kmo1.mat';


geopar      = [];
bestgeopar  = [];
rislsq      = [];
funval      = [];

% calibration for each finger
for d=1:5
    rislsqapp = [];
    funvalapp = [];
    %% thumb finger calibration
    if d==1
        display('Thumb finger calibration...');
        % load thumb finger calibration measurements
        load ([directory Thumb_Dataset]);
        meas=double(frame(:,2:13));
        NTOT = size(meas,1);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % THESE VALUES HAVE TO BE CHANGED 
        % thumb finger marker parameters 
        mi4x = 23; 
        mi3x = 19; 
        mi2x = 26; 
        % phalanges length
        a2 = 52; 
        a3 = 35;
        % offset
        ofx = 0;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    
    %% index finger calibration
    if d==2
        display('Index finger calibration...');
        % load index finger calibration measurements
        load ([directory Index_Dataset]);
        meas=double(frame(:,14:25));
        NTOT = size(meas,1);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % THESE VALUES HAVE TO BE CHANGED 
        % index finger marker parameters  
        mi4x = 19;      
        mi3x = 15;       
        mi2x = 33;        
        % phalanges length
        a2 = 49; 
        a3 = 26;
        % offset
        ofx = 16;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    
    %% middle finger calibration
    if d==3
        display('Middle finger calibration...');
        % load middle finger calibration measurements
        load ([directory Middle_Dataset]);
        meas=double(frame(:,26:37)); 
        NTOT = size(meas,1);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % THESE VALUES HAVE TO BE CHANGED 
        % middle finger marker parameters  
        mi4x = 20; 
        mi3x = 20;      
        mi2x = 31;   
        % phalanges length
        a2 = 52; 
        a3 = 31;
        % offset
        ofx = 23;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end

    %% ring finger calibration
    if d==4
        display('Ring finger calibration...');
        % load ring finger calibration measurements
        load ([directory Ring_Dataset]);
        meas=double(frame(:,38:49));
        NTOT = size(meas,1);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % THESE VALUES HAVE TO BE CHANGED 
        % ring finger marker parameter  
        mi4x = 18;  
        mi3x = 16; 
        mi2x = 30; 
        % phalanges length
        a2 = 51; 
        a3 = 29;
        % offset
        ofx = 23;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    
    %% little finger calibration
    if d==5
        display('Little finger calibration...');
        % load little finger calibration measurements
        load ([directory Little_Dataset]);
        meas=double(frame(:,50:61)); 
        NTOT = size(meas,1);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % THESE VALUES HAVE TO BE CHANGED  
        % little finger marker parameters  
        mi4x = 20; 
        mi3x = 11;       
        mi2x = 24; 
        % phalanges length
        a2 = 35; 
        a3 = 22;
        % offset
        ofx = 20;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    % same initial condition values for all fingers
    mi4y = 0; 
    mi4z = 0;  
    mi3y = 0; 
    mi3z = 0; 
    mi2y = 0; 
    mi2z = 0;
    a4   = 0.02; % not influent for calibration
    ofy  = 0;
    ofz  = 0;

    % i-th finger initial conditions 
    a = [a2,a3];
    mixyz = [mi2x,mi2y,mi2z,mi3x,mi3y,mi3z,mi4x,mi4y,mi4z,a2,a3,ofx,ofy,ofz];
    
    %% 
    for j=1:2

        % random indices 
        index  = randi(NTOT,1,Nframe);

        xu = [];
        xl = [];
        x0a = [];
        for i=1:Nframe
            % upper angles bounds
            xu = [xu [0.4 0.8 1.2 1.2]];
            % initial angles condition
            x0a = [x0a [0 0.4 0.6 0.6]];
        
            if d==1 
                % lower angles bound (thumb)
                xl = [xl [-0.4 0 0 -0.2]];
            else
                % lower angles bound (other fingers)
                xl = [xl [-0.4 0 0 0]];
            end
        end
     
        %% Select nonzero measures for calibration
        m1 = [];
        m2 = [];
        m3 = [];
        m4 = [];
        
        for i=1:Nframe
            if (~meas(index(i),1) || ~meas(index(i),4) || ~meas(index(i),7) || ~meas(index(i),10))
                %display('nullo');
                k1=index(i);
                cont=0;
                while (~meas(k1,1) || ~meas(k1,4) || ~meas(k1,7) || ~meas(k1,10))
                    k1=k1+1;
                    if k1==NTOT
                        k1=1;
                        cont=cont+1;
                        if cont==2
                            display('Non ci sono misure per la calibrazione --> ctrl+c');
                            while k1==1
                            end
                        end
                    end
                end
                %display('non nullo');
                %k1
                m1 = [m1; meas(k1,1:3)];
                m2 = [m2; meas(k1,4:6)];
                m3 = [m3; meas(k1,7:9)];
                m4 = [m4; meas(k1,10:12)];                
            else
                m1 = [m1; meas(index(i),1:3)];
                m2 = [m2; meas(index(i),4:6)];
                m3 = [m3; meas(index(i),7:9)];
                m4 = [m4; meas(index(i),10:12)];  
            end
        end
        % thumb finger initial conditions
% % %         if d==1
% % %             lb = [mi2x-0.005,mi2y-0.01,mi2z-0.01,mi3x-0.005,mi3y-0.01,mi3z-0.01,mi4x-0.005,mi4y-0.01,mi4z-0.01,a-0.01,ofx-0.005,ofy-0.005,ofz-0.005,xl];
% % %             ub = [mi2x+0.01,mi2y+0.01,mi2z+0.01,mi3x+0.01,mi3y+0.01,mi3z+0.01,mi4x+0.01,mi4y+0.01,mi4z+0.01,a+0.01,ofx+0.005,ofy+0.005,ofz+0.005,xu]; 
% % %         end
% % %         % index finger initial conditions
% % %         if d==2
% % %             lb = [mi2x,mi2y-0.005,mi2z-0.005,mi3x,mi3y-0.005,mi3z-0.005,mi4x,mi4y-0.005,mi4z-0.005,a,ofx,ofy-0.01,ofz-0.01,xl];
% % %             ub = [mi2x+0.005,mi2y+0.007,mi2z+0.01,mi3x+0.01,mi3y+0.005,mi3z+0.01,mi4x+0.005,mi4y+0.005,mi4z+0.007,a+0.005,ofx+0.005,ofy+0.01,ofz+0.01,xu]; 
% % %         end
% % %         % middle finger initial conditions
% % %         if d==3
% % %             lb = [mi2x-0.01,mi2y-0.01,mi2z-0.01,mi3x-0.01,mi3y-0.01,mi3z-0.01,mi4x-0.01,mi4y-0.01,mi4z-0.01,a-0.01,ofx-0.01,ofy-0.01,ofz-0.01,xl];
% % %             ub = [mi2x+0.01,mi2y+0.01,mi2z+0.01,mi3x+0.01,mi3y+0.01,mi3z+0.01,mi4x+0.01,mi4y+0.01,mi4z+0.01,a+0.01,ofx+0.01,ofy+0.01,ofz+0.01,xu]; 
% % %         end
% % %         % ring finger initial conditions
% % %         if d==4 
% % %         	lb = [mi2x,mi2y-0.008,mi2z-0.008,mi3x,mi3y-0.008,mi3z-0.008,mi4x,mi4y-0.008,mi4z-0.008,a,ofx,ofy-0.01,ofz-0.01,xl];
% % %             ub = [mi2x+0.01,mi2y+0.008,mi2z+0.008,mi3x+0.01,mi3y+0.01,mi3z+0.008,mi4x+0.01,mi4y+0.01,mi4z+0.008,a+0.01,ofx+0.01,ofy+0.01,ofz+0.01,xu]; 
% % %         end
% % %         % little finger initial conditions
% % %         if d==5
% % %         	lb = [mi2x,mi2y-0.005,mi2z-0.005,mi3x,mi3y-0.005,mi3z-0.005,mi4x,mi4y-0.005,mi4z-0.005,a,ofx,ofy-0.01,ofz-0.01,xl];
% % %             ub = [mi2x+0.005,mi2y+0.005,mi2z+0.005,mi3x+0.005,mi3y+0.005,mi3z+0.005,mi4x+0.005,mi4y+0.005,mi4z+0.005,a+0.005,ofx+0.005,ofy+0.01,ofz+0.01,xu]; 
% % %         end
        
        % standard initilization
        lb = [mi2x,mi2y-6,mi2z,mi3x,mi3y-6,mi3z,mi4x,mi4y-6,mi4z,a,ofx,ofy-6,ofz,xl];
        ub = [mi2x+8,mi2y+6,mi2z+10,mi3x+6,mi3y+6,mi3z+10,mi4x+6,mi4y+6,mi4z+10,a+6,ofx+6,ofy+6,ofz+10,xu]; 
       
        A = [];
        b = [];
        Aeq = [];
        beq = [];
        x0 = [mixyz,x0a];

        options = optimoptions('fmincon','MaxIter',inf,'MaxFunEvals',inf);
        
        [x fval] = fmincon(@(x) ObjHand(x,m1,m2,m3,m4,d),x0,A,b,Aeq,beq,lb,ub,[],options);
        
        funval = [funval fval];
        rislsq = [rislsq; x];
        
        funvalapp = [funvalapp fval];
        rislsqapp = [rislsqapp; x];
        

    end 
    [s k] = min(funvalapp');
    bestgeopar = [bestgeopar; rislsqapp(k,1:14)];
    
end

save HandPar bestgeopar

dir1 = 'EstimatedParameters/';

estname = [dir1 'HandPar' Subject '.mat'];
save(estname, 'bestgeopar')

save ([dir1 'ErrorHandCalib' Subject], 's')


disp('Calibration Ended')

