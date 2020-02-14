function [I1,Segmentace]=kombinovanie(info,alg,n,MaxGeneration)
%t�to funkcia sluzi na spustenie nieko�ko n�sobnej segmnet�cie obrazu z
%kombinovanej inform�cie  pomocou vybran�ho algoritmu alg. 
%   Vstupom funkcie je vybran� algoritmus (FA,SSO alebo FASSO) po�et
%   h�adac�ch agentov n a po�et iter�ci�/popul�ci� algoritmu MaxGeneration.
%   V�stupom funkcie je 
%   segmentovan� obraz I1 
%   �tuktura segmentace, v ktorej su ulozene parci�lne segmentacie obrazu, 


%% Deklarovanie premenn�ch 
FLAIR=mha_read_volume(info(1));
FLAIR=FLAIR(:,:,1:159); % Vzdy vyberam len obrazy na ktor�ch je nejak� inform�cia
FLAIR=medfilt3(FLAIR,[2,2,2]); % Filtr�cia obrazu medianovym 3D filtrom

T1=mha_read_volume(info(2));
T1=T1(:,:,1:159);
T1=medfilt3(T1,[2,2,2]);

T2=mha_read_volume(info(4));
T2=T2(:,:,1:159);
T2=medfilt3(T2,[2,2,2]);

T1C=mha_read_volume(info(3));
T1C=T1C(:,:,1:159); % tento obraz teraz nefiltrujem, preto�e z neho pou�ijem len malu cast 

POM=zeros(size(T2)); % pomocna premenn� na zapisovanie poz�c patologick�ch tkaniv
Vysledok=ones(size(T2)); % vysledna premenn� do ktorej sa zapisuj� indexy.
                         %musi byt ones aby mohla by� konvertovana na
                         %indexovany obraz 

%Vytvorenie modelov pre morfologick� upravenie
[koule1] = sphere(2);
[koule2] = sphere(1);
[koule3] = sphere(3);
%% Segmentovanie patologick�ch tkan�v
%trojn�sobn� segment�cia obrazov, kde su dobre viditeln� patologick�
%tkaniv�

[best{1},besth{1},befit{1},bfit{1},x]= met_algoritmy(FLAIR,n,MaxGeneration,2,alg,30);
Segmentace{1}=imquantize(FLAIR,x([1,best{1}]),[1,2,3,4]);

[best{2},besth{2},befit{2},bfit{2},x]= met_algoritmy(T1,n,MaxGeneration,3,alg,30); %20
Segmentace{2}=imquantize(T1,x(best{2}),[1,4,3,2]);

[best{3},besth{3},befit{3},bfit{3},x]= met_algoritmy(T2,n,MaxGeneration,3,alg,30);

if best{3}(1)==1 % osetrenie  v pr�pade, �e by prvy prah predsa len bol 1
    Segmentace{3}=imquantize(T2,x([best{3}]),[1,3,2,4,5]);
else
    Segmentace{3}=imquantize(T2,x([1,best{3}]),[1,3,2,4,5]);

end

%% Vybratie patologick�ch tkaniv do T1
%hladanie prieniku medzi flair a T1 A T2. Tento sp�sob bol zvolen� z
%d�vodu, �e T1 a T2 maju podobne prekr�vaj�ce tkaniv�, k�m FLAIR ich m�
%rozdielne 
NADOR_FLAIR=find(Segmentace{1}==3 | Segmentace{1}==4);
NADOR_T1=find(Segmentace{2}==4);
NADOR_T2=find(Segmentace{3}==4);

pozicie_nador00=intersect(NADOR_T2,NADOR_FLAIR);
pozicie_nador01=intersect(NADOR_T1,NADOR_FLAIR);

% kontrola spravneho oznacovania tkaniva tretou segmentaciou, ktora sa
% casto kazi
if (length(pozicie_nador00)/length(pozicie_nador01))<0.7 %pixle v prieniku by mali byt podobne
    NADOR_T2a=find(Segmentace{3}==2);
    NADOR_T2b=find(Segmentace{3}==5);
pozicie_nador00a=intersect(NADOR_T2a,NADOR_FLAIR);
pozicie_nador00b=intersect(NADOR_T2b,NADOR_FLAIR);
velikost=length(pozicie_nador00a)>length(pozicie_nador00b);
switch velikost
    case 1
        pozicie_nador00=pozicie_nador00a;
    case 0
        pozicie_nador00=pozicie_nador00b;
        end

end  
% Spresnenie rie�enia
pozicie_nador=union(pozicie_nador01,pozicie_nador00);

%Uprava vysegmentovaneho nadora morfologickym otvorenim a filtrovan�m
%nen��ch oblast� 
POM(pozicie_nador)=1;
pokus=imopen(POM,koule3);
for i=1:159
    pokus(:,:,i)=bwareafilt(logical(pokus(:,:,i)),[50,10000]);
end

clear pozicie_nador
% morfologicke uzavretie na spojenie aktivnej a nektrotizovanej casti
% n�dora
pokus=imclose(pokus,koule3);
pozicie_nador=(pokus==1);

POM=zeros(size(T2));

%% Rozli�ovanie nadorovych tkaniv
%aktivny nador, nekrotizovan� n�dor a ed�m s� rozlisiteln� len na T1C,
%preto su vybran� len patologick� pixle na tuto segment�ciu
pixle_T1C=medfilt3(T1C(pozicie_nador),[2,2,2]);
% pixle_T1C=medfilt2(pixle_T1C,[2,2]);
[best{4},besth{4},befit{4},bfit{4},x]= met_algoritmy(pixle_T1C,n,MaxGeneration,4,alg,30);
Segmentace{4}=imquantize(pixle_T1C,x([20,best{4}]),[1,5,6,3,2,4]);

%indexovanie tkaniv s dodatocnymi morfologick�mi upravami
POM(pozicie_nador)=Segmentace{4};
% TUMOR=(POM==2 |POM==3|POM==4|POM==1|POM==6);
% POM1=imclose(TUMOR,koule2);
% POM(POM1)=4;

%vyuzivanie inform�cie z in�ch vahovac�ch sekvenci�ch zabr�nenie
%indexovanie ed�mu ako nekrotizovan�ho nadoru zo znalosti FLAIR 
% vymena=intersect(find(POM==5),find(Segmentace{1}==4));
% POM(vymena)=6;
POM3=imclose((POM==2 |POM==3|POM==4|POM==1|POM==6),koule2);
for i=1:159
    POM3(:,:,i)=imfill(logical(POM3(:,:,i)),'holes');
    POM3(:,:,i)=bwareafilt(logical(POM3(:,:,i)),[100,10000]);
end

POM(POM3)=4;
POM2=imclose(POM==5|POM==6,koule2); 
POM(POM2)=5;

% vymena=intersect(find(POM==4),find(Segmentace{1}==4));
% POM2(vymena)=1;

TUMOR=POM3==1;
EDEM=POM2==1;

pozicie_nador=find((POM3==1|POM2==1));
clear POM
%% segmentace ciev
T1C(pozicie_nador)=0;
[ h,x ] = D3_segmentacia(T1C);
% najdenie hranice od ktorej treba hladat cievy, pr�li� �irok� spektrum na
% segmentovanie pomocou metaheuristick�ch algoritmov

prah=100; % priblizny prah, aby sa nemuselo ist od nuly 
hranica=0;
while  hranica<=0.998; %cievy zaberaju len asi 0,001% obrazu
   hranica=sum(h(1:prah))/sum(h);
prah=prah+1;
end

CIEVY=(T1C>x(prah)); %iba v T1C viditeln�
pom=intersect(find(CIEVY==1),NADOR_FLAIR); %osetrenie, mo�e sa tu nach�dza� aktivny nador a edem
CIEVY(pom)=0;
EDEM(pom)=1;

%% Indexovanie lebky a jej n�sledn� odstr�nenie
T1(pozicie_nador)=0;
T1(CIEVY)=0;
[best{5},besth{5},befit{5},befit{5},x]= met_algoritmy(T1,n,MaxGeneration,3,alg,30);
if best{5}(1)==1
    Segmentace{5}=imquantize(T1,x([best{5}]),[1,3,2,4,5]);
else
    Segmentace{5}=imquantize(T1,x([1,best{5}]),[1,3,2,4,5]);
end


LEBKA=(Segmentace{5}==3 | Segmentace{5}==2);
T1(LEBKA)=0;
%% Segmentovanie �edej a bielej hmoty bez n�dorov a lebky
[best{6},besth{6},befit{6},bfit{6},x]= met_algoritmy(T1,n,MaxGeneration,4,alg,30);
Segmentace{6}=imquantize(T1,x([best{6}]),[1,3,2,4,5]);

SEDA_HMOTA= imclose((Segmentace{6}==2|Segmentace{6}==3),koule2);
BIELA_HMOTA=imclose((Segmentace{6}==4| Segmentace{6}==5),koule2);

%% Indexovanie tkaniv
% Indexovanie segmentovanych tkaniv do vysledku a morfologick� upravy
% TUMOR=(POM==4 |POM==5|POM==3); 
% TUMOR=imclose(TUMOR,koule3);
Vysledok(SEDA_HMOTA)=3;
Vysledok(BIELA_HMOTA)=2;
Vysledok(TUMOR)=6;
Vysledok(EDEM)=5;
Vysledok(LEBKA)=4;
Vysledok(CIEVY)=7;

%% kontrola pritomnosti v�etk�ch indexov a premena indexovan� obraz
kontrola=unique(Vysledok);
I1 = im2uint8(Vysledok,'indexed');

end