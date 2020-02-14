function [f ] = maximal_entropy(histo,dims)
%maximal_entropy táto funkcia vytvorí funkciu pre výpoèet hodnoty maximálnej
%entropie v obraze
%Vstupom je histogram a pocet prahov
%Vystupom je funkcia, ktora pocíta hodnotu maximálnej entropie v obraze

pixle=sum(histo);
H{1}=@(t)-sum(((histo(1:t(1))/pixle)/sum((histo(1:t(1))/pixle))).*log2((histo(1:t(1))/pixle)/sum((histo(1:t(1))/pixle))));

for d=2:dims
%je tu nastavená spätná vazba, to znamená, že keï volám funkciu f, najprv
%sa mi vytvorí H a v haèku už je vložená premenná, s ktorou pracuje a v
%jaèku beriem vždy len jedno t, t(d), lenže do výpoètu v t sa tiež posúva
%len toto t, ale tam potrebujem 2 hodnoty t
% p{d}=@(t)(histogram((t(d-1)+1):t(d))/pixle);
H{d}=@(t)-sum(((histo((t(d-1)+1):t(d))/pixle)/sum((histo((t(d-1)+1):t(d))/pixle))).*log2((histo((t(d-1)+1):t(d))/pixle)/sum((histo((t(d-1)+1):t(d))/pixle))));
end

H{dims+1}=@(t)-sum(((histo((t(d)+1):256)/pixle)/sum((histo((t(d)+1):256)/pixle))).*log2((histo((t(d)+1):256)/pixle)/sum((histo((t(d)+1):256)/pixle))));
 % Napísanie funkcie zo struktury
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
