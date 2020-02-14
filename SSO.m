function [bfit,befit,spbest,spbesth,priebeh] = SSO (spidn,itern,histogram,dims)
%Táto funkcia je Social Spider Optimization (SSO). Sluzi na najdenie prahov
% pomocou optimalizovanie objektívnej funkcie. Vstupy su:
  % Preliminares
    % spidn, spiders number
    % itern, iterations number
    % dims, pocet prahov
    % histogram, histogram obrazu
%Vystupy su:
% vektor spbest, èo su prahy patriace k hodnote maximálnej entropie obrazu, 
% matica spbesth, prahy nájdené poèas iterácií algoritmov
% vektor befit èo sú zapamätané hodnoty maximálnej entropie poèas  iterácií algoritmu
% hodnota bfit èo je hodnota maximálnej entropie
% vektor priebeh èo je hodnota nájdenej maximálnej entropie poèas iterácií algoritmu

%Funkcia bola stiahnutá z https://www.mathworks.com/matlabcentral/fileexchange/46942-a-swarm-optimization-algorithm-inspired-in-the-behavior-of-the-social-spider
% a modifikovaná Kristínou Olešovou
	%% Urèenie rozsahu
  
  range = [2,256]; %rozsah histogramu, rozsah hladania riešenie
%2 sluzi ako automaticke ošetrenie v prípade nastavovania prahov na 1
  [f ] = maximal_entropy(histogram,dims);
  lb=repmat(range(1),1,dims); %uprava rangu pre poziadavky algoritmu
  ub=repmat(range(2),1,dims);%uprava rangu pre poziadavky algoritmu

    %% Iniciálizácia parametrov
    %rand('state',0');  % Reset the random generator
    
    % Define the poblation of females and males
    fpl = 0.65;     % Dolný limit percenta samièiek
    fpu = 0.9;      % Horný limit percenta samièiek
    fp = fpl+(fpu-fpl)*rand;	% Aktuálne percento
    fn = round(spidn*fp);   % Poèet samièiek
    mn = spidn-fn;          % Poèet samcov
	%% PPravdepodobnos atraktivity alebo odporu samièiek voèi populácii
	% Nastavené na viac ako 100 hodnôt. Treba vždy zmeni, pokia¾ je iný
	% poèet iterácii
    %pm = exp(-(0.1:(3-0.1)/(itern-1):3));
    pm=flip((logspace(2,5,itern))/10^4.9);
    %% Initialization of vectors
    fsp = zeros(fn,dims);   % Initlize females
    msp = zeros(mn,dims);   % Initlize males
    fefit = zeros(fn,1);    % Initlize fitness females
    mafit = zeros(mn,1);    % Initlize fitness males
    spwei = zeros(spidn,1); % Initlize weigth spiders
    fewei = zeros(fn,1); % Initlize weigth spiders
    mawei = zeros(mn,1); % Initlize weigth spiders
    spbesth = zeros(itern,dims);
    befit= zeros(1,itern);
    
    %% Population Initialization
    % Generate Females
    for j=1:dims
    for i=1:fn
        fsp(i,j)=round(lb(j)+rand(1,1).*(ub(j)-lb(j)),0);
    end
    end

    % Generate Males
      for j=1:dims
    for i=1:mn
      msp(i,j)=round(lb(j)+rand(1,1).*(ub(j)-lb(j)),0);
    end
      end
    %% **** Evaluations *****
	% Evaluation of function for females
    for i=1:fn
        % Výpoèet entropie
         if isequal(fsp(i,:),sort(fsp(i,:)))
        fefit(i)=f(fsp(i,:));
    else
        if i==1
            fefit(i)=2;
        else
        fefit(i)=0;
        end
    end
    end
    
	% Evaluation of function for males
    for i=1:mn
        mafit(i)=f(msp(i,:));
    end
    %% ***** Assign weigth or sort ***********
	% Obtain weight for every spider
    spfit = [fefit' mafit']';   % Mix Females and Males
    bfitw = max(spfit);          % best fitness
    wfit = min(spfit);          % worst fitness
    for i=1:spidn
        spwei(i) =0.0001+((spfit(i)-wfit)/(bfitw-wfit));
    end
    fewei = spwei(1:fn);      % Separate the female mass
    mawei = spwei(fn+1:spidn);% Separate the male mass
    %% Memory of the best
    % Check the best position
    [~,Ibe] = max(spwei);
    % Check if female or male
    if Ibe > fn
        % Is Male
        spbest=msp(Ibe-fn,:);   % Asign best position to spbest
        bfit = mafit(Ibe-fn);      % Get best fitness for memory
    else
        % Is Female
        spbest=fsp(Ibe,:);      % Asign best position to spbest
        bfit = fefit(Ibe);      % Get best fitness for memory
    end
    %% Start the iterations
    for iter=1:itern 
        %% ***** Movement of spiders *****
        % Move Females
        [fsp] = FeMove(spidn,fn,fsp,msp,spbest,Ibe,spwei,dims,lb,ub,pm(iter));
       fsp=round(fsp,0);
        % Move Males
        [msp] = MaMove(fn,mn,fsp,msp,fewei,mawei,dims,lb,ub,pm(iter));
        msp=round(msp,0);

%% zastavenie algoritmu pokial su vsetky pavuky na svojom mieste         
pom=find(round(mean(fsp)./fsp(2,:),2)==1);
pom2=find(round(mean(msp)./msp(1,:),2)==1);

cat1=(0<length(pom) && length(pom)<dims);
cat2=(0<length(pom2) && length(pom2)<dims);

    if length(pom)== dims || length(pom2)== dims || mean(isnan(msp(:)))==1
    befit(iter) = bfit;
    spbesth(iter,:)=spbest;
    break
    elseif (cat1==1 && cat2==0)
    fsp(1,:)=fsp(1,:)-1;
    elseif (cat1==0 && cat2==1)
    msp(1,:)=msp(1,:)-1;   
    elseif (cat1==1 && cat2==1)
    fsp(1,:)=fsp(1,:)-1;
    msp(1,:)=msp(1,:)-1;
    end
        %% **** Evaluations *****
        % Evaluation of function for females
       for j=1:fn
            if isequal(fsp(j,:),sort(fsp(j,:)))
                try fefit(j)=f(fsp(j,:));
                catch ME % Hladanie chyb
                    disp(pom)
                    disp(iter)
                end
            else 
            fsp(j,:)=sort(fsp(j,:));
            try fefit(j)=f(fsp(j,:));
              catch ME
                    disp(pom)
                    disp(iter)  
            end
            end
        end

        % Evaluation of function for males
        for j=1:mn
           if isequal(msp(j,:),sort(msp(j,:)))
                mafit(j)=f(msp(j,:));
                try mafit(j)=f(msp(j,:));
                catch ME
                    disp(pom2)
%                     disp(iter)
                end
            else 
            msp(j,:)=sort(msp(j,:));
            try mafit(j)=f(msp(j,:));
                catch ME
                    disp(pom2)
                    
                end
            mafit(j)=f(msp(j,:));
            end
        end
        %% ***** Assign weigth or sort ***********
        spfit = [fefit' mafit']';   % Mix Females and Males
        bfitw = max(spfit);          % best fitness
        wfit = min(spfit);          % worst fitness
        % Obtain weight for every spider
        for j=1:spidn
            spwei(j) =0.0001+((spfit(j)-wfit)/(bfitw-wfit));
        end
        fewei = spwei(1:fn);      % Separate the female mass
        mawei = spwei(fn+1:spidn);% Separate the male mass
        %% Mating Operator
        [ofspr] = Mating(fewei,mawei,fsp,msp,dims);
        %% Selection of the Mating
        if isempty(ofspr)
%             % Do nothing
        else
            [fsp,msp,fefit,mafit] = Survive(fsp,msp,ofspr,fefit,mafit,spfit,f,fn);
            % ***** Recalculate the weigth or sort ***********
            spfit = [fefit' mafit']';   % Mix Females and Males
            bfitw = max(spfit);          % best fitness
            wfit = min(spfit);          % worst fitness
            % Obtain weight for every spider
            for j=1:spidn
                spwei(j) = 0.001+((spfit(j)-wfit)/(bfitw-wfit));
            end
            fewei = spwei(1:fn);      % Separate the female mass
            mawei = spwei(fn+1:spidn);% Separate the male mass
        end
        %% Memory of the best
        % Check if best position belongs to male or female
        [~,Ibe2] = max(spwei);
        if Ibe2 > fn
            % Is Male
            spbest2=msp(Ibe2-fn,:);      % Asign best position to spbest
            bfit2 = mafit(Ibe2-fn);      % Get best fitness for memory
        else
            % Is Female
            spbest2 = fsp(Ibe2,:);  % Asign best position to spbest
            bfit2 = fefit(Ibe2);    % Get best fitness for memory
        end
        %% Global Memory
         priebeh(iter) = bfit2;
        
        if bfit>=bfit2
            bfit = bfit;
            spbest = spbest;      % Asign best position to spbest
            befit(iter) = bfit;
        else
            bfit = bfit2;
            spbest = spbest2;      % Asign best position to spbest
            befit(iter) = bfit;
        end
        spbesth(iter,:)=spbest;

    end

end