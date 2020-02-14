function [bfit,befit,best,besth]=FA(n,MaxGeneration,histogram,dims,gamma)
% T�to funkcia je Firefly algorithm (FA). Sluzi na najdenie prahov
% pomocou optimalizovanie objekt�vnej funkcie. Vstupy su:
% n=pocet svetlusiek
% MaxGeneration=pocet populaci� svetlusiek 
% histogram = histogram segmentovan�ho obrazu
% dims = pocet tresholdov
% gamma = absorpcia svetla prostred�m
% V�stupom funkcie je vektor best, �o su prahy patriace k hodnote maxim�lnej entropie obrazu, 
% matica besth, prahy n�jden� po�as iter�ci� algoritmov
% vektor befit �o s� zapam�tan� hodnoty maxim�lnej entropie po�as  iter�ci� algoritmu
% hodnota bfit �o je hodnota maxim�lnej entropie
% vektor priebeh �o je hodnota n�jdenej maxim�lnej entropie po�as iter�ci� algoritmu

% Funkcia bola stiahnut� z https://www.mathworks.com/matlabcentral/fileexchange/29693-firefly-algorithm
% a modifikovan� Krist�nou Ole�ovou
 %% Maximum enthropy function ---------------------
range =[2,256] ; %rozsah histogramu, rozsah hladania rie�enie
%2 sluzi ako automaticke o�etrenie v pr�pade nastavovanie prahov na 1
[f ] = maximal_entropy(histogram,dims); %maxim�lna entropia

%% Ur�enie Premenn�ch vo vn�tri algoritmu
alpha=0.43;      % ve�kos� n�hodn�ho pohybu
delta=0.99;     % Redukcia n�hodnosti
%% Inicializ�cia
% Poz�cie svetlu�iek
t=zeros(dims,n);
% Hodnoty entropie
zn=zeros(1,n);
% Prahy
besth=zeros(dims,MaxGeneration);
%Hodnota maxim�lnej entropie
befit=zeros(1,MaxGeneration);

xrange=range(2)-range(1);
% generovanie po�iato�n�ch poz�c n svetlu�iek
t(1:dims,:)=round(rand(dims,n)*xrange+range(1),0);

%% Za�iatok iter�cii
for iter=1:MaxGeneration,   

for k=1:length(t)
    if isequal(t(:,k),sort(t(:,k))) %Zjednodu�enie problemu zaisten�m, aby prahy boli vzdy 
        zn(k)=f(t(:,k)); % za sebou
    else
        t(:,k)=sort(t(:,k));
        zn(k)=f(t(:,k));
    end
end

% Preusporiadanie svetlu�iek na z�klade ich intenzity svetla/entropie
[Lightn,Index]=sort(zn); %porovnanie hodnot intenzity svetlusiek

t(:)=t(:,Index);

%vytvorenie premenn�ch na ulo�enie p�vodn�ch poz�cii svetlu�iek
to=t; 
Lighto=Lightn;

%% Move all fireflies to the better locations

ni=size(t,2); nj=size(to,2);
% Porovn�va sa jedna svetlu�ka ku v�etk�m ostatn�m 
for i=1:ni,
    for j=1:nj,  
        %vzdialenos�
            r=sqrt(sum((t(:,i)-t(:,j)).^2));
% Ni��ia hodnota entropie
if Lightn(i)<Lighto(j), 
   % V�po�et atraktivity
beta0=1;     beta=beta0*exp(-gamma*(r/256).^2);%% tu je problem 

%Pohyb menej atrakt�vnej svetlu�ky
%Jednotky by mali by� pribli�ne v rovnak�ch rozmeroch tj od 1 do 0 pre
% normalizovany histogram
t(:,i)=round((((t(:,i)/256).*(1-beta))+((to(:,j)/256).*beta)+(alpha.*(rand(dims,1)-0.5)))*256,0);
end
    end % end for j
end % end for i

%osetrenie pokial svetlusky skoncia mimo rozsahu
aboveRange = (t(:) > range(2)); t(aboveRange)= t(aboveRange)-(2*(t(aboveRange)-range(2)));
belowRange = (t(:) < range(1)); t(belowRange)= 5;

%Zmen�ovanie n�hodn�ho pohybu
alpha=alpha*delta; 

besth(:,iter)=to(:,n); %posledn�/najlep�ia poz�cia svetlu�ky nako�ko t� sa neh�be
befit(iter)=Lighto(n); %Hodnota entropie poslednej svetlu�ky
end  
%koniec iter�cii

best=transpose(to(:,n)); % osetrenie pre beh algoritmu v kombinovanej segmentaci�
bfit=Lighto(n); %najvy��ia hodnota entropie
