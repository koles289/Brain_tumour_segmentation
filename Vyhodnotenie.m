function [JACCARD,C,JACCARD_2] = Vyhodnotenie(I1,I2)
%Vyhodnotenie je funkcia ktorá sluzi na kvantitatívne ohodnotenie segmentácie
%vstupom funkcie je indexovaný obraz I1, ktorý vznikol po
%prahovaní a obraz I2 ktorý je groud true
%   Výstupom funkcie je skóre JACCARD pre všetky tkanivá v mozgu a
%   confusion matrix C kde sú vidite¾né zámeny tkanív pri segmentovaní
I1=uint8(I1);
dims=length(unique(I1));
C=confusionmat(I1(:),I2(:));
JACCARD=zeros(1,dims);

for q=1:dims
JACCARD(q)=length(intersect(find(I1==q-1),find(I2==q-1)))/length(union(find(I1==q-1),find(I2==q-1)));
end

%Vyhodnotenie vytvorené pre porovnanie whole tkaniva s výsledkami z èlánku
whole1=find(I1==4 | I1==5 );
whole2=find(I2==4 | I2==5 );
JACCARD_2=length(intersect(whole1,whole2))/length(union(whole1,whole2));
end

