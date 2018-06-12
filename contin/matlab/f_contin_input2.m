function f_contin_input2(study)

files = dir('*.in');
fileID = fopen('run_all','w');

if study == 1
    s1 = './contin.exe < ';
else
    s1 = './contin_dynamic.exe < ';
end

s2 = ' > ';
s3 = '.out';
for j = 1:length(files)
    name = files(j).name; 
    fprintf(fileID,'%s %s %s %s \n\n',s1,name,s2,strcat(name(1:end-3),s3));
end

fclose(fileID);
end