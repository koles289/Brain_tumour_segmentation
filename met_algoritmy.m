function [best,besth,befit,bfit,x,priebeh] = met_algoritmy(Image,n,MaxGeneration,dims,alg,gamma)
% �lohou tejto funkcie je v�po�et histogramu obrazu a spustenie vybran�ho 
% metaheuristick�ho algoritmu a
% V�stupom funkcie s� hodnoty n�jden�ch prahov, hodnota maxim�lnej
% entropie, priebeh objekt�vnej funkcie

%% Zistenie histogramu obrazu pre r�zne datov� typy
      [ h,x ] = D3_segmentacia(Image);

%% Vybratie algoritmu na spustenie 
switch alg
    case 1
        %Hybridny algoritmus
        [bfit,befit,best,besth,priebeh] = Fasso(n,MaxGeneration,h,dims,gamma);
    case 2 
        %Firefly algorithm 
        [bfit,befit,best,besth]=FA(n,MaxGeneration,h,dims,gamma);
        %priebeh m� tie ist� hodnoty ako befit, lebo poz�cia najlep�ej
        %svetlu�ky sa nemen� 
        priebeh=befit;
    case 3
        %Social spider optimization 
        [bfit,befit,best,besth,priebeh] = SSO (n,MaxGeneration,h,dims);
    otherwise
        disp('V�ber algoritmu mus� byt v rozsahu 1-3')
end
end

