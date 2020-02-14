function [I1,befit,bfit,priebeh] = Rez_po_reze(info,n,MaxGeneration,alg)
%FA 15

T1C=mha_read_volume(info(3));
Image=T1C(:,:,1:159);
Segmentace=ones(size(Image));
for ii=1:size(Image,3)
    I=Image(:,:,ii);
    I=medfilt2(I,[2,2]);
   [best,besth,befit,bfit(ii),x,priebeh] = met_algoritmy(I,n,MaxGeneration,6,alg,11);
    Segmentace(:,:,ii)=imquantize(I,x(best),[1,4,3,2,5,6,7]);
end
[koule] = sphere(2);
POM=imclose(Segmentace(:,:,80:120)==3,koule);
POM2=imclose(Segmentace(:,:,80:120)==4,koule);
Segm=Segmentace(:,:,80:121);
Segm(POM)=3;
Segm(POM2)=4;
% kontrola=unique(Segmentace);
I1 = im2uint8(Segm,'indexed');
end