function [II,II_gray] = fuzia(info,rez,fuzia,metoda)
% T�to funkcia vytvor� fuziu dostupn�ch sekvenc�� z MRI 
%rez v mozgu 1-159 /najlep�ie od 70 do 130
%v�ber fuzie 1-T1,T1C,FLAIR
%            2-T2,T1C,FLAIR
%            3-T2,T1C,FLAIR a T1
%metoda     'diff'
%        	'blend'
%           'falsecolor'

%vybratie sekvencii
FLAIR=mha_read_volume(info(1));
T1=mha_read_volume(info(2));
T1C=mha_read_volume(info(3));
T2=mha_read_volume(info(4));
%z�kladn� fuze
Imfuze_baze=imfuse(T1C(:,:,rez),FLAIR(:,:,rez),metoda);

%Vybratie poctu obrazkov do fuzie
switch fuzia
    case 1
II=imfuse(Imfuze_baze,T1(:,:,rez),metoda);
    case 2
II=imfuse(Imfuze_baze,T2(:,:,rez),metoda);
    case 3
Ii=imfuse(Imfuze_baze,T1(:,:,rez),metoda);
II=imfuse(Ii,T2(:,:,rez),metoda);
    otherwise
II=Imfuze_baze;
end

%prevod do �edotonoveho obrazu
II_gray=rgb2gray(II); 

%Zobrazenie
figure(1)
imshow(II_gray)
figure (2)
imshow(II)
end

