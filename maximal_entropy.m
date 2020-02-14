function [f ] = maximal_entropy(histo,dims)
%maximal_entropy t�to funkcia vytvor� funkciu pre v�po�et hodnoty maxim�lnej
%entropie v obraze
%Vstupom je histogram a pocet prahov
%Vystupom je funkcia, ktora poc�ta hodnotu maxim�lnej entropie v obraze

pixle=sum(histo);
H{1}=@(t)-sum(((histo(1:t(1))/pixle)/sum((histo(1:t(1))/pixle))).*log2((histo(1:t(1))/pixle)/sum((histo(1:t(1))/pixle))));

for d=2:dims
%je tu nastaven� sp�tn� vazba, to znamen�, �e ke� vol�m funkciu f, najprv
%sa mi vytvor� H a v ha�ku u� je vlo�en� premenn�, s ktorou pracuje a v
%ja�ku beriem v�dy len jedno t, t(d), len�e do v�po�tu v t sa tie� pos�va
%len toto t, ale tam potrebujem 2 hodnoty t
% p{d}=@(t)(histogram((t(d-1)+1):t(d))/pixle);
H{d}=@(t)-sum(((histo((t(d-1)+1):t(d))/pixle)/sum((histo((t(d-1)+1):t(d))/pixle))).*log2((histo((t(d-1)+1):t(d))/pixle)/sum((histo((t(d-1)+1):t(d))/pixle))));
end

H{dims+1}=@(t)-sum(((histo((t(d)+1):256)/pixle)/sum((histo((t(d)+1):256)/pixle))).*log2((histo((t(d)+1):256)/pixle)/sum((histo((t(d)+1):256)/pixle))));
 % Nap�sanie funkcie zo struktury
A='';
for ii=1:dims+1
if ii==dims+1
b=['H{%1.0f}(t)'] ;
B=sprintf(b,ii);
str=[A,B];
else
b=['H{%1.0f}(t)+'];
B=sprintf(b,ii);
str=[A,B];
A=str;
end
end
konecne=['@(t)',str];
f=str2func(konecne);
end
