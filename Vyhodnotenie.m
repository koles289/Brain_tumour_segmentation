function [JACCARD,C,JACCARD_2] = Vyhodnotenie(I1,I2)
%Vyhodnotenie je funkcia ktor� sluzi na kvantitat�vne ohodnotenie segment�cie
%vstupom funkcie je indexovan� obraz I1, ktor� vznikol po
%prahovan� a obraz I2 ktor� je groud true
%   V�stupom funkcie je sk�re JACCARD pre v�etky tkaniv� v mozgu a
%   confusion matrix C kde s� vidite�n� z�meny tkan�v pri segmentovan�
I1=uint8(I1);
dims=length(unique(I1));
C=confusionmat(I1(:),I2(:));
JACCARD=zeros(1,dims);

for q=1:dims
JACCARD(q)=length(intersect(find(I1==q-1),find(I2==q-1)))/length(union(find(I1==q-1),find(I2==q-1)));
end

%Vyhodnotenie vytvoren� pre porovnanie whole tkaniva s v�sledkami z �l�nku
whole1=find(I1==4 | I1==5 );
whole2=find(I2==4 | I2==5 );
JACCARD_2=length(intersect(whole1,whole2))/length(union(whole1,whole2));
end

