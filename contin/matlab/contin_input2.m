%Script for generating contin input files from CSVs
files = dir('*.in');

% fileID = fopen('run_all','w');
% fprintf(fileID,'%s \n \n','#!/bin/bash');
% s1 = './contin < ';
% s2 = ' > ';
% s3 = '.out';
% for j = 1:length(files)
%     name = files(j).name; 
%     fprintf(fileID,'%s %s %s %s \n\n',s1,name,s2,strcat(name(1:end-3),s3));
% end
% 
% fclose(fileID);

fileID = fopen('run_all','w');
s1 = 'contin.exe < ';
s2 = ' > ';
s3 = '.out';
for j = 1:length(files)
    name = files(j).name; 
    fprintf(fileID,'%s %s %s %s \n\n',s1,name,s2,strcat(name(1:end-3),s3));
end

fclose(fileID);