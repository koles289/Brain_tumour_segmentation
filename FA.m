function [bfit,befit,best,besth]=FA(n,MaxGeneration,histogram,dims,gamma)
% Táto funkcia je Firefly algorithm (FA). Sluzi na najdenie prahov
% pomocou optimalizovanie objektívnej funkcie. Vstupy su:
% n=pocet svetlusiek
% MaxGeneration=pocet populacií svetlusiek 
% histogram = histogram segmentovaného obrazu
% dims = pocet tresholdov
% gamma = absorpcia svetla prostredím
% Vıstupom funkcie je vektor best, èo su prahy patriace k hodnote maximálnej entropie obrazu, 
% matica besth, prahy nájdené poèas iterácií algoritmov
% vektor befit èo sú zapamätané hodnoty maximálnej entropie poèas  iterácií algoritmu
% hodnota bfit èo je hodnota maximálnej entropie
% vektor priebeh èo je hodnota nájdenej maximálnej entropie poèas iterácií algoritmu

% Funkcia bola stiahnutá z https://www.mathworks.com/matlabcentral/fileexchange/29693-firefly-algorithm
% a modifikovaná Kristínou Olešovou
 %% Maximum enthropy function ---------------------
range =[2,256] ; %rozsah histogramu, rozsah hladania riešenie
%2 sluzi ako automaticke ošetrenie v prípade nastavovanie prahov na 1
[f ] = maximal_entropy(histogram,dims); %maximálna entropia

%% Urèenie Premennıch vo vnútri algoritmu
alpha=0.43;      % ve¾kos náhodného pohybu
delta=0.99;     % Redukcia náhodnosti
%% Inicializácia
% Pozície svetlušiek
t=zeros(dims,n);
% Hodnoty entropie
zn=zeros(1,n);
% Prahy
besth=zeros(dims,MaxGeneration);
%Hodnota maximálnej entropie
befit=zeros(1,MaxGeneration);

xrange=range(2)-range(1);
% generovanie poèiatoènıch pozíc n svetlušiek
t(1:dims,:)=round(rand(dims,n)*xrange+range(1),0);

%% Zaèiatok iterácii
for iter=1:MaxGeneration,   

for k=1:length(t)
    if isequal(t(:,k),sort(t(:,k))) %Zjednodušenie problemu zaistením, aby prahy boli vzdy 
        zn(k)=f(t(:,k)); % za sebou
    else
        t(:,k)=sort(t(:,k));
        zn(k)=f(t(:,k));
    end
end

% Preusporiadanie svetlušiek na základe ich intenzity svetla/entropie
[Lightn,Index]=sort(zn); %porovnanie hodnot intenzity svetlusiek

t(:)=t(:,Index);

%vytvorenie premennıch na uloenie pôvodnıch pozícii svetlušiek
to=t; 
Lighto=Lightn;

%% Move all fireflies to the better locations

ni=size(t,2); nj=size(to,2);
% Porovnáva sa jedna svetluška ku všetkım ostatnım 
for i=1:ni,
    for j=1:nj,  
        %vzdialenos
            r=sqrt(sum((t(:,i)-t(:,j)).^2));
% Nišia hodnota entropie
if Lightn(i)<Lighto(j), 
   % Vıpoèet atraktivity
beta0=1;     beta=beta0*exp(-gamma*(r/256).^2);%% tu je problem 

%Pohyb menej atraktívnej svetlušky
%Jednotky by mali by pribline v rovnakıch rozmeroch tj od 1 do 0 pre
% normalizovany histogram
t(:,i)=round((((t(:,i)/256).*(1-beta))+((to(:,j)/256).*beta)+(alpha.*(rand(dims,1)-0.5)))*256,0);
end
    end % end for j
end % end for i

%osetrenie pokial svetlusky skoncia mimo rozsahu
aboveRange = (t(:) > range(2)); t(aboveRange)= t(aboveRange)-(2*(t(aboveRange)-range(2)));
belowRange = (t(:) < range(1)); t(belowRange)= 5;

%Zmenšovanie náhodného pohybu
alpha=alpha*delta; 

besth(:,iter)=to(:,n); %posledná/najlepšia pozícia svetlušky nako¾ko tá sa nehıbe
befit(iter)=Lighto(n); %Hodnota entropie poslednej svetlušky
end  
%koniec iterácii

best=transpose(to(:,n)); % osetrenie pre beh algoritmu v kombinovanej segmentacií
bfit=Lighto(n); %najvyššia hodnota entropie
