function [I1,befit,bfit,priebeh] = upravene_data(alg,n,MaxGeneration)
% upravene_data je funkcia ktorá vytvára 3D segmentáciu upravenıch dát z T1C
% váhovanej sekvencie. Segmentuje sa vdy mozog HG0015, nako¾ko ten bol ako
% jedinı upravenı pre tento typ segmentácie.
%   Vstupom funkcie je vybranı algoritmus (FA,SSO alebo FASSO) poèet
%   h¾adacích agentov n a poèet iterácií/populácií algoritmu MaxGeneration.
% Vıstupom funkcie je segmentovanı obraz I1, 
% vektor befit èo sú zapamätané hodnoty maximálnej entropie poèas  iterácií algoritmu
% hodnota bfit èo je hodnota maximálnej entropie
% vektor priebeh èo je hodnota nájdenej maximálnej entropie poèas iterácií algoritmu
% V prípade alg=2 tak, vektor befit a priebeh su také isté
dd=length(nargin);

%Nacitanie obrazu HG0015
        D=load('15a2T1cely.mat');
        Image=reshape(D.rez15a2,[256,256,159]);
        Image=medfilt3(Image,[2,2,2]);


% Spustenie metaheuritického algoritmu
[best{1},besth{1},befit{1},bfit{1},x,priebeh]= met_algoritmy(Image,n,MaxGeneration,6,alg,35);
%prahovanie
Segmentace{1}=imquantize(Image,x([best{1}]),[1,4,3,2,5,6,7]);
% Obraz musí by v rovnakom formáte ako sú ground true data
I1 = im2uint8(Segmentace{1},'indexed');

end

