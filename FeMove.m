function [fsp] = FeMove(spidn,fn,fsp,msp,spbest,Ibe,spmass,d,lb,ub,pm)
%FEMOVE Summary of this function goes here
%   Detailed explanation goes here
    % Preliminaries
    dt1=zeros(1,fn);
    dt2=zeros(1,spidn-fn);
    % Scale for distance
    scale=(-lb(1)+ub(1));
    % Start looking for any stronger vibration
    for i=1:fn          % Move the females
        for j=1:fn      % Check all the spiders
            if spmass(j)>spmass(i)  % If theres someone more atrractive
                % Calculate the distance
%                 dt1(j)=sqrt(sum((fsp(i,:)-fsp(j,:)).^2));
                dt1(j)=norm(fsp(i,:)-fsp(j,:));
            else
                dt1(j)=0;   % Make sure the value is zero
            end
        end
        for j=1:spidn-fn
            if spmass(fn+j)>spmass(i)
                % Calculate the distance
                dt2(j)=norm(fsp(i,:)-msp(j,:));
                %sqrt(sum((fsp(i,:)-msp(j,:)).^2));
            else
                dt2(j)=0;   % Make sure the value is zero
            end
        end
        % Scaled Distance for the system
        dt=[dt1 dt2]./scale;%%%%&%%
        % Choose the shortest distance
        [~,Ind,val] = find(dt);    % Choose where the distance is non zero
        [~,Imin] = min(val);       % Get the shortest distance
        Ish=Ind(Imin);              % Index of the shortest distance
        %% Check if male or female
        if Ish > fn
        % Is Male
            spaux=msp(Ish-fn,:);   % Assign the shortest distance to spaux
        else
            % Is Female
            spaux=fsp(Ish,:);   % Assign the shortest distance to spaux
        end
        % Calculate the Vibrations
        if isempty(val)     % Check if is the same element
           Vibs=0;          % Vib for the shortest
           spaux=zeros(1,d);
        else
            Vibs=2*(spmass(Ish)*exp(-(rand*dt(Ish).^2)));   % Vib for the shortest
        end
        %% Check if male or female
        if Ibe > fn
            % Is Male
            dt2=norm(fsp(i,:)-msp(Ibe-fn,:));
        else
            % Is Female
            % Vibration of the best
            dt2=norm(fsp(i,:)-fsp(Ibe,:));
        end
        dtb=dt2./scale;
        Vibb=2*(spmass(Ibe)*exp(-(rand*dtb.^2)));
        if rand>=pm
            % Do an atracction
            betha = rand(1,d);
            gamma = rand(1,d);
            tmpf = 2*pm.*(rand(1,d)-0.5);
            fsp(i,:)=fsp(i,:)+(Vibs*(spaux-fsp(i,:)).*betha)+(Vibb*(spbest-fsp(i,:)).*gamma)+tmpf;
        else
            % Do a repulsion
            betha = rand(1,d);
            gamma = rand(1,d);
            tmpf = 2*pm.*(rand(1,d)-0.5);
            fsp(i,:)=fsp(i,:)-(Vibs*(spaux-fsp(i,:)).*betha)-(Vibb*(spbest-fsp(i,:)).*gamma)+tmpf;
        end
    end
   
aboveRange =(fsp(:) > ub(1)); fsp(aboveRange)= round(fsp(aboveRange)-(1.1*(fsp(aboveRange)-ub(1))),0);
%belowRange = (t(:) < range(1)); t(belowRange)= t(belowRange)-(2*(t(belowRange)-range(1)));
belowRange =(fsp(:) < lb(1)); fsp(belowRange)=round(fsp(belowRange)-(1.1*(fsp(belowRange)-lb(1))),0);

end