function [best,besth,befit,bfit,x,priebeh] = met_algoritmy(Image,n,MaxGeneration,dims,alg,gamma)
% Úlohou tejto funkcie je výpoèet histogramu obrazu a spustenie vybraného 
% metaheuristického algoritmu a
% Výstupom funkcie sú hodnoty nájdených prahov, hodnota maximálnej
% entropie, priebeh objektívnej funkcie

%% Zistenie histogramu obrazu pre rôzne datové typy
      [ h,x ] = D3_segmentacia(Image);

%% Vybratie algoritmu na spustenie 
switch alg
    case 1
        %Hybridny algoritmus
        [bfit,befit,best,besth,priebeh] = Fasso(n,MaxGeneration,h,dims,gamma);
    case 2 
        %Firefly algorithm 
        [bfit,befit,best,besth]=FA(n,MaxGeneration,h,dims,gamma);
        %priebeh má tie isté hodnoty ako befit, lebo pozícia najlepšej
        %svetlušky sa nemení 
        priebeh=befit;
    case 3
        %Social spider optimization 
        [bfit,befit,best,besth,priebeh] = SSO (n,MaxGeneration,h,dims);
    otherwise
        disp('Výber algoritmu musí byt v rozsahu 1-3')
end
end

