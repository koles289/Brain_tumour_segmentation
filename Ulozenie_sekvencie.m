function []=Ulozenie_sekvencie(I1,epath)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
for rez=1:size(I1,3)
b=['Obraz%1.0f']; % obecny nazov
subor=[sprintf(b,rez),'.png']; % nazov
% zapisanie indexovaneho obrazu imwrite(obraz, mapa, cesta)
% mapa pre indexovan˝ obraz musÌ maù veæosù (poËet indexov x 3)
imwrite(I1(:,:,rez),repmat([0,0.15,0.3,0.45,0.60,0.75]',[1 3]),fullfile(epath,subor))

end

