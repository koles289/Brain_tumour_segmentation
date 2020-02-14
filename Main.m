clc
clear all
close all

%% Hlavny skript

% Tento skript sluzi na segmentovanie MRI obrazu mozgu pomocou
% metaheuristick�ch algoritmov. Je mozn� si vybra� mozog na segmentovanie,
% vybra� algoritmus(FA, FASSO alebo SSO), typ segment�cie (rez po reze, 3D
% segment�cia upraven�ch d�t a kombinovan� 3D segment�cia)
% V�stupom skriptu je vypo��tan� sk�re JACCARD a zobrazenie segmentovan�ho
% obrazu
%
% VYU�IT� OPTIMALIZA�N�CH METOD PRO SEGMENTACI MRI DAT
% Autor: Krist�na Ole�ov� 
% 25.05.2018
%% Urcenie premennych
index=7;   % Vyber obrazu na segmentovanie/len nep�rne ��sla 1 az 42

n=30;       % Pocet svetlusiek a pavukov/pocet p�tracich agentov
MaxGeneration=100; % Pocet iteracii algoritmu
alg=1;     %Vyber algoritmu na segmentovanie 
%           1-Fasso
%           2-FA
%           3-SSO
nac_obrazy='D:\�kola\B�kal�rsk� pr�ca\BRATS-1\Simulovan� data s rie�en�m\'; %cesta na na��tanie obrazov
uloz_obrazy='D:\�kola\B�kal�rsk� pr�ca\AnimaciaFASSO'; %cesta na ulozenie obrazov

uloha=3; %vybratie typu segmentacie
%           1 kombinovana informacia
%           2 3D segmentacia upravenych dat
%           3 Rez po reze

vystup=3; %vybratie ulohy pre segmentovan� obraz 
%           2 mont� pre kazdy jeden rez a ukazka objektivnej funkcie
%           3 v�po�et JACCARD
%           1 ulozenie obrazkov
         
% Nacitavanie obrazu na segmentovanie

%% Na��tanie d�t z prie�inka
 % Nacitavanie obrazu na segmentovanie
[info,Info] = Import_files_from_folder(nac_obrazy,index);

%Ground true
V2=mha_read_volume(Info(1)); 
I2=V2(:,:,1:159); 
%% Segmentovanie obrazu 
%v�ber ulohy na segmentovanie

tic % po�iatok sledovania v�po�tov�ho �asu 
switch uloha
    case 1
%3D segmentacia pomocou kombinovanej inform�cie
[I1,Segmentace]=kombinovanie(info,alg,n,MaxGeneration);

    case 2
% 3D segmentacia dat vyuzitim dat T1C upraven�ch pomocou ground true
[I1,befit,bfit,priebeh] = upravene_data(alg,n,MaxGeneration);

    case 3
%Segment�cia rez po reze
[I1,befit,bfit,priebeh] = Rez_po_reze(info,n,MaxGeneration,alg);

    otherwise
         disp('Nespravne zadana hodnota �lohy. Nutne cisla od 1 - 3')
         break
end
toc %Ukoncenie sledovania v�po�tov�ho �asu
%% Rozhodnutie o vystupe algoritmu
close all

switch vystup
    
    case 1
%  Ulozenie sekvencie vo vybranom priecinku
Ulozenie_sekvencie(I1,uloz_obrazy)
    
    case 2
% Vizualne porovnanie segmentovaneho a indexovaneho obrazu
if uloha==1
    disp('Pre tento typ segmentacie sa nezobrazuje objektivna funkcia')
else
Zobraz(I1,I2,priebeh,befit{1})
end 
    case 3 
% Vyhodnocovanie segmentacie pomocou jaccardu pre jednotlive oblasti
[JACCARD,~,JACCARD_2] = Vyhodnotenie(I1,I2);

    case 4
        [II,II_gray] = fuzia(info,rez,2,'falsecolor');
    otherwise
        disp('Nespravne zadana hodnota vystupu. Nutne cisla od 1 - 4')
        break
end

imshow4(I1)

disp('koniec algoritmu')