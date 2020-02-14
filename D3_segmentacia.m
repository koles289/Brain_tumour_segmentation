function [ h,x ] = D3_segmentacia(Image)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
h=histogram(double(Image(:)),256); 

x=h.BinEdges;
h=h.Values+10; % Zabezpecenie aby nikde nebol nulový odtieò sedi/ nutné pre 
               %výpocet entropie
% h(1)=h(1)-1.5e+06; %Bulharska konstanta na zaistenie podobnych tvarov histogramov

end

