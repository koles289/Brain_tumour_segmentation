function [ info,Info ] = Import_files_from_folder(Path,cislo) 
%UNTITLED2 Summary of this function goes here
%   path='C:\Moje data\škola\Bákalárská práca\BRATS-1\Images\'
folders=dir(Path);
cislo=cislo+2;
folder_index=folders(cislo).name;
folder_data=strcat(Path,folder_index,'\');
fold=dir(folder_data);
sekv_vah=fold(4).name;
sekv_truth=fold(3).name;

files=strcat(Path,folder_index,'\',sekv_vah,'\','*.mha');
files2=strcat(Path,folder_index,'\',sekv_truth,'\','*.mha');
file=strcat(Path,folder_index,'\',sekv_vah,'\');
file2=strcat(Path,folder_index,'\',sekv_truth,'\');
%H¾adanie
matfiles = dir(fullfile(files));
matfiles2 = dir(fullfile(files2));
% vytvorenie premenných 
% info=zeros(1,length(matfiles));
% Info=zeros(1,length(matfiles2));
%obrázky na segmentovanie
 for i=1:length(matfiles)
 info(i)= mha_read_header(strcat(file,matfiles(i).name));
 end
 %správne výsledky
 for i=1:length(matfiles2)
 Info(i)= mha_read_header(strcat(file2,matfiles2(i).name));
 end
 
end

