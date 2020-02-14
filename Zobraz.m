function [] = Zobraz(I1,I2,priebeh,befit)
%Zobraz Sluzi na zobrazenie priebehu objektivnej funkcie 
%   pre vybrany algoritmu. Nemozno zvolit pri segmentacii pomocou
%   kombinovanej informacie
 imshowpair(I1(:,:,50),I2(:,:,50),'montage')
figure(2)
imshowpair(I1(:,:,100),I2(:,:,100),'montage')


osa=linspace(1,length(priebeh),length(priebeh));
figure(3)
plot(osa,priebeh,osa,befit(1:length(priebeh)))
title('Hodnota max. entropie v priebehu vybraneho algoritmu')
legend('Aktualna','Najvyššia')
xlabel('Iterácia')
ylabel('Entropia obrazu')

end
