# Brain_tumour_segmentation
Dátum 25.05.2018
This thesis deals with a segmentation of brain tissues from MRI image data and its implementation in MATLAB. <br>
Segmentation problematic is described with attention to formulating segmentation as optimization problem and segmentation of given images with different metaheuristic algorithm consequently. This approach was chosen due to information from last specialized publications, where it was accentuated for its fast computational speed and universality. This thesis tries to prove this statement with segmentation of brain images with brain tumours that have different types, number, stage of illness and phase of therapy.



Pokyny k spusteniu programu
Segmentácia obrazu sa spúšťa v skripte Main. V tomto skripte je nutné vybrať si cestu k načítaniu obrazových dát, premenná nac_obrazy, ktoré sa nachádzajú v priečinku BRATS a sú súčasťou priloženého CD. Algoritmus je schopný načítať len súbory končiace príponou .mha. Algoritmus je defaultne nastavený na segmentovanie obrazu mozgu HG0015 pomocou 3D kombinovanej informácie a algoritmu FASSO Výstupom funkcie je vizuálne zobrazenie výslednej segmentácie vybraného mozgu a výpočet hodnoty JACCARD. V skripte Main je možné meniť veľkosť populácie, premenná n, počet iterácií algoritmu, premenná MaxGene-ration, metaheuristický algoritmus, premenná alg, spôsob segmentácie, premenná uloha a vybraný výstup, premenná vystup. Ako výstup je možné si vybrať 3 možnosti. Možnosť 1 je uloženie výsledku segmentovanej sekvencie do vybraného priečinka určeného v premennej uloz_obrazy.
Možnosť 2 je zobrazenie priebehu objektívnej funkcie vybraného algoritmu a zobrazenie re-zov 50 a 100 segmentovaného mozgu.
Možnosť 3 je výpočet hodnoty JACCARD, kde výsledkom je vektor JACCARD o dĺžke 7 pre indexy okolie, šedá hmota, biela hmota, lebka, edém, tumor, cievy.
V prípade príliš zlého výsledného skóre segmentácie, prípadne chyby, je vhodné skúsiť spustiť algoritmus ešte raz. Nakoľko sa jedná o metaheuristické algoritmy, je možné ich zaseknutie v lokálnom optime, ktoré môže viesť až k objaveniu chybovej hlášky
