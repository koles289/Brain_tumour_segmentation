function [bfit,befit,spbest,spbesth,priebeh] = Fasso( n,MaxGeneration,histogram,dims,gamma)
%FASSO je hybridn˝ algoritmus pre segment·ciu obrazu kombinuj˙ci schopnosù
%FA algoritmu vyhn˙ù sa zaseknutiu v lok·lnom optime a schopnosù SSO algoritmu 
% presne prehæadÌvaù okolie rieöenia
 % Preliminares
    %  n, spiders number
    % MaxGeneration, iterations number
    % dims, pocet prahov
    % histogram, histogram obrazu
    %gamma = absorpcia svetla prostredÌm
%Vystupy su:
% vektor spbest, Ëo su prahy patriace k hodnote maxim·lnej entropie obrazu, 
% matica spbesth, prahy n·jdenÈ poËas iter·ciÌ algoritmov
% vektor befit Ëo s˙ zapam‰tanÈ hodnoty maxim·lnej entropie poËas  iter·ciÌ algoritmu
% hodnota bfit Ëo je hodnota maxim·lnej entropie
% vektor priebeh Ëo je hodnota n·jdenej maxim·lnej entropie poËas iter·ciÌ algoritmu
    
 %% Maximum enthropy function ---------------------

range = [2,256];%rozsah histogramu
[f ] = maximal_entropy(histogram,dims);
%% Parametre 
% Parametre pre FA algoritmus 
alpha=0.99;      % 0.43 Randomness 0--1 (highly randomvv)
delta=0.90; % 0,965     % Randomness reduction (similar to            
% an annealing schedule)
                
% Parametre pre SSO algoritmus
 %rand('state',0');  % Reset the random generator
 %   % Define the poblation of females and males
    fpl = 0.65;     % Lower Female Percent %malo by byt min. 0.7%
    fpu = 0.8;      % Upper Female Percent %horna hranica mnozstva samiciek
    fp = fpl+(fpu-fpl)*rand;	% Aleatory Percent
    fn = round(n*fp);   % Number of females
    mn = n-fn;          % Number of males
    % Probabilities of attraction or repulsion in SSO algorithm 
	% Proper tunning for better results
   %pm = exp(-(0.85:(5-0.3)/(MaxGeneration+40):6));
   %pm=linspace(0.15,0,MaxGeneration);
    %pm=flip((logspace(1,6,MaxGeneration))/10^6.3);
    pm=flip((logspace(1,6,MaxGeneration))/10^6);
   % pm=linspace(0.3,0.0005,MaxGeneration);
   %pm=flip((logspace(2,5,itern))/10^4.9);

%% Initialization of vectors and positions
%Generating vector for entropy calculation in FA algorithm 
Lightn=zeros(size(1,n)); 
% generating the initial locations of n fireflies in FA algorithm 
xrange=range(2)-range(1);
t(1:dims,:)=round(rand(dims,n)*xrange+range(1),0);
lb=repmat(range(1),1,dims);
ub=repmat(range(2),1,dims);

% Initialization of vectors for SSO algorithm 
fsp = zeros(fn,dims);   % Initlize females
msp = zeros(mn,dims);   % Initlize males
fefit = zeros(fn,1);    % Initlize fitness females
mafit = zeros(mn,1);    % Initlize fitness males
spwei = zeros(n,1); % Initlize weigth spiders
fewei = zeros(fn,1); % Initlize weigth spiders
mawei = zeros(mn,1); % Initlize weigth spiders
priebeh=zeros(1,n);
befit = zeros(1,MaxGeneration);
  
    
%% Iterations or pseudo time marching
for iter=1:MaxGeneration   %%%%% start iterations
% Evaluate new solutions
for k=1:length(t)
    if isequal(t(:,k),sort(t(:,k)))
        zn(k)=f(t(:,k));
    else
        t(:,k)=sort(t(:,k));
        zn(k)=f(t(:,k));
    end
end
% Ranking the fireflies by their light intensity
[Lightn,Index]=sort(zn); %porovnanie hodnot intenzity svetlusiek

t(:)=t(:,Index);

to=t;
Lighto=Lightn;
%% Move all fireflies to the better locations
ni=size(t,2); nj=size(to,2);
for i=1:ni
% The attractiveness parameter beta=exp(-gamma*r)
    for j=1:nj,     
r=sqrt(sum((t(:,i)-t(:,j)).^2));
if Lightn(i)<Lighto(j)
   % Brighter and more attractive
beta0=1;     beta=beta0*exp(-gamma*(r/256).^2);

t(:,i)=round(((t(:,i)/256).*(1-beta)+(to(:,j)/256).*beta+alpha.*(rand(dims,1)-0.5))*256,0);

end
    end % end for j
end % end for i
clear i j
%% Osetrenie pokial by sa svetlusky ocitli mimo rangu
aboveRange = (t(:) > range(2)); t(aboveRange)= round(t(aboveRange)-(1.1*(t(aboveRange)-range(2))),0);
belowRange = (t(:) < range(1)); t(belowRange)=round(t(belowRange)-(1.1*(t(belowRange)-range(1))),0);
    
% Redukcia nahodnosti
alpha=alpha*delta;  
   %% Zaciatok SSO algoritmu 
   % ***** Assign weigth or sort ***********
	% Obtain weight for every spider
    msp(:,:)=t(:,fn+1:n)';
    fsp(:,:)=t(:,1:fn)';

bfitw = max(zn);
bfit=max(befit);% best fitness
 wfit=min(zn);
   % Memory of the best
    %Check the best position
    [~,Ibe] = max(spwei);
    % Check if female or male
    if Ibe > fn
        % Is Male
        spbest=msp(Ibe-fn,:);   % Asign best position to spbest
            % Get best fitness for memory
    else
        % Is Female
        spbest=fsp(Ibe,:);      % Asign best position to spbest
      
    end  
    
    spwei(:) = 0.001+((zn(:)-wfit)/(bfitw-wfit));

     %% ***** Movement of spiders *****
        % Move Females
        [fsp] = FeMove(n,fn,fsp,msp,spbest,Ibe,spwei,dims,lb,ub,pm(iter));
       fsp=round(fsp,0);
        % Move Males
        [msp] = MaMove(fn,mn,fsp,msp,fewei,mawei,dims,lb,ub,pm(iter));
        msp=round(msp,0);
        
pom=find(round(mean(fsp)./fsp(1,:),2)==1);
pom2=find(round(mean(msp)./msp(1,:),2)==1);

   cat1=(0<length(pom) && length(pom)<dims);
cat2=(0<length(pom2) && length(pom2)<dims);

    if length(pom)== dims || length(pom2)== dims  || mean(isnan(msp(:)))==1
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
                catch ME
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
        zn = [fefit' mafit']';   % Mix Females and Males
        bfitw = max(zn);          % best fitness
        wfit = min(zn);          % worst fitness
        % Obtain weight for every spider
      
            spwei(:) = 0.0001+((zn(:)-wfit)/(bfitw-wfit));
        
        fewei = spwei(1:fn);      % Separate the female mass
        mawei = spwei(fn+1:n);% Separate the male mass
        %% Mating Operator
        [ofspr] = Mating(fewei,mawei,fsp,msp,dims);
        %% Selection of the Mating
        if isempty(ofspr)
%             % Do nothing
        else
            [fsp,msp,fefit,mafit] = Survive(fsp,msp,ofspr,fefit,mafit,zn,f,fn);
            % ***** Recalculate the weigth or sort ***********
            zn = [fefit' mafit']';   % Mix Females and Males
            bfitw = max(zn);          % best fitness
            wfit = min(zn);          % worst fitness
            % Obtain weight for every spider
            spwei(:) = 0.0001+((zn(:)-wfit)/(bfitw-wfit));
            
            fewei = spwei(1:fn);      % Separate the female mass
            mawei = spwei(fn+1:n);% Separate the male mass
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
        priebeh(iter)=bfit2;
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
       
        
        %podanie premenn˝ch 
    t(:,fn+1:n)=msp(:,:)';
    t(:,1:fn)=fsp(:,:)';

end   %%%%% end of iterations

end

