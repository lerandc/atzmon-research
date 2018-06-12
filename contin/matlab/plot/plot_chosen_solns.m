clearvars
close all
files = dir('*.out');

for iter = 1:length(files)
    f_name = files(iter).name;
    
    fID = fopen(f_name);
    place_holder = fgets(fID);
    
    while(place_holder ~= -1)
        if contains(place_holder,'NG     = ','IgnoreCase',true)
            k = strfind(place_holder, 'NG     = ');
            place_holder(k:k+length('NG     = ')-1) = [];
            num_points = str2num(place_holder);
        end
        
        if contains(place_holder,'CHOSEN SOLUTION','IgnoreCase', true)
            break;
        end
        place_holder = fgets(fID);
    end 
    
    for i = 1:7
        place_holder = fgets(fID);
    end
    
    fID2 = fopen('tempfile.txt','w');
    for i = 1:num_points
        place_holder = fgets(fID);
        fprintf(fID2, strcat(place_holder(1:31),'\n'));
    end
    fclose(fID2);
    
    M = readtable('tempfile.txt');
    save(strcat('file',num2str(iter)),'M')
    delete tempfile.txt
    clearvars M
    fclose(fID);
end

    style = ['*','o','+','x','s','^','v','d'];
    figure
    hold on
    grid on
    
for iter = 1:length(files)
    load(strcat('file',num2str(iter)))
    data = table2array(M);
    semilogx(data(:,3),data(:,1),strcat('-',style(mod(iter,8)+1)),'LineWidth',0.3);
end

set(gca,'XScale','log')
ylim([0, 0.03])
xlabel('\tau')
ylabel('f(\tau)')
title('All chosen solutions for Cu15 tests sample 3')
name_cell = cell(length(files),1);
    files2 = dir('*.out');
    name_list = {files2.name}';
    sort_cell = regexp(name_list,'Test\d{4}','match','once');
legend(sort_cell,'Location','northwest')

savefig(gcf,'all_chosen_soln.fig')

files = dir('*.mat');
for i = 1:length(files)
    delete(files(i).name)
end