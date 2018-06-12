close all
clearvars

files = dir('*.out');

for iter = 1:length(files)
    
    name = files(iter).name;

    fID = fopen(name);

    place_holder = fgets(fID);

    num_runs = 0;
    while(place_holder ~= -1)
        
        if contains(place_holder,'NG     = ','IgnoreCase',true)
            k = strfind(place_holder, 'NG     = ');
            place_holder(k:k+length('NG     = ')-1) = [];
            num_points = str2num(place_holder);
        end
        
        if contains(place_holder,'ALPHA    ALPHA/S(1)','IgnoreCase', true)
           num_runs = num_runs+1;
           fID2 = fopen('tempfile.txt','w');
           lose = strfind(place_holder,'TO REJECT');
           place_holder(lose(2):lose(2)+length('TO REJECT')-1) = [];
           place_holder(lose(1):lose(1)+length('TO REJECT')-1) = [];
           place_holder = strrep(place_holder,'DEG FREEDOM', 'DEGFREEDOM');
           place_holder = strrep(place_holder,'OBJ. FCT', 'OBJ.FCT');
           place_holder = strrep(place_holder,'STD. DEV', 'STD.DEV');
           
           reduce  = strfind(place_holder,'  ');
           
           while any(reduce)
               place_holder(reduce(1)) = [];
               reduce = strfind(place_holder,'  ');
           end
           
           fprintf(fID2,strcat(place_holder,'\n'));
           
           place_holder = fgets(fID);
           place_holder(place_holder == '*') = [];
           reduce  = strfind(place_holder,'  ');
           
           while any(reduce)
               place_holder(reduce(1)) = [];
               reduce = strfind(place_holder,'  ');
           end
           
           fprintf(fID2,strcat(place_holder,'\n'));
           fclose(fID2);
           
           place_holder = fgets(fID);
           
           fID3 = fopen('tempfile2.txt','w');
           place_holder = fgets(fID);
           fprintf(fID3,strcat(place_holder,'\n'));
           
           for i = 1:num_points
               place_holder = fgets(fID);
               fprintf(fID3,strcat(place_holder(1:31),'\n'));
           end
           
           fclose(fID3);
           
           M = readtable('tempfile.txt');
           N = readtable('tempfile2.txt');
           delete tempfile.txt tempfile2.txt
           
           save(strcat(name(1:end-4),'_alpha_',num2str(num_runs)),'M','N')
           clear M N
        end
        
        place_holder = fgets(fID);
    end
    
    
    fclose(fID);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    legend_cell = cell(num_runs,1);
    style = ['*','o','+','x','s','^','v','d'];
    figure
    for i = 1:num_runs
        load(strcat(name(1:end-4),'_alpha_',num2str(i)));
        data = table2array(N);
        legend_cell{i,1} = strcat('ALPHA = ',num2str(M.ALPHA),' PROB1 = ',num2str(M.PROB1));
        current_alpha = M.ALPHA;
        if i ~= num_runs(end)
           semilogx(data(:,3),data(:,1),strcat('-',style(mod(i,8)+1)),'LineWidth',0.3);
        else
           legend_cell{i,1} = 'CHOSEN SOLN.';
           semilogx(data(:,3),data(:,1),strcat('-','k.'),'MarkerSize',14,'LineWidth',0.3);
        end
        hold on
        
        if i > 2 && i < num_runs
            if prev_alpha > current_alpha
                last_coarse_alpha = i-1;
            end
        end
        
        prev_alpha = current_alpha;
    end
    grid on
    legend(legend_cell,'Location','NorthWest')
    %%%%%%
    files2 = dir('*.mat');
    name_list = {files2.name}';
    sort_cell = regexp(name_list,'_\d+','match','once');
    for i = 1:length(sort_cell)
        sort_cell{i}(sort_cell{i}=='_') = [];
        sort_cell{i} = str2double(sort_cell{i});
    end
    [~,ind] = sort(cell2mat(sort_cell));
    for i = 1:last_coarse_alpha
        delete(files2(ind(i)).name);
    end
    %%%%%%
    savefig(strcat(name(1:end-4),'_all_alpha'))
    close all
end
close all