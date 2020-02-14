function [I1,befit,bfit,priebeh] = upravene_data(alg,n,MaxGeneration)
% upravene_data je funkcia ktor� vytv�ra 3D segment�ciu upraven�ch d�t z T1C
% v�hovanej sekvencie. Segmentuje sa v�dy mozog HG0015, nako�ko ten bol ako
% jedin� upraven� pre tento typ segment�cie.
%   Vstupom funkcie je vybran� algoritmus (FA,SSO alebo FASSO) po�et
%   h�adac�ch agentov n a po�et iter�ci�/popul�ci� algoritmu MaxGeneration.
% V�stupom funkcie je segmentovan� obraz I1, 
% vektor befit �o s� zapam�tan� hodnoty maxim�lnej entropie po�as  iter�ci� algoritmu
% hodnota bfit �o je hodnota maxim�lnej entropie
% vektor priebeh �o je hodnota n�jdenej maxim�lnej entropie po�as iter�ci� algoritmu
% V pr�pade alg=2 tak, vektor befit a priebeh su tak� ist�
dd=length(nargin);

%Nacitanie obrazu HG0015
        D=load('15a2T1cely.mat');
        Image=reshape(D.rez15a2,[256,256,159]);
        Image=medfilt3(Image,[2,2,2]);


% Spustenie metaheuritick�ho algoritmu
[best{1},besth{1},befit{1},bfit{1},x,priebeh]= met_algoritmy(Image,n,MaxGeneration,6,alg,35);
%prahovanie
Segmentace{1}=imquantize(Image,x([best{1}]),[1,4,3,2,5,6,7]);
% Obraz mus� by� v rovnakom form�te ako s� ground true data
I1 = im2uint8(Segmentace{1},'indexed');

end

