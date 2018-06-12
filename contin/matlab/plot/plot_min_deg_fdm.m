close all
clearvars

files = dir('*.out');

style = ['*','o','+','x','s','^','v','d'];
figure
hold on
grid on
for iter = 1:length(files)
    M = [];
    f_name = files(iter).name;
    fID = fopen(f_name);
    
    place_holder = fgets(fID);
    current_line = 1;
    while(place_holder ~= -1)
        
        if contains(place_holder,'NG     = ','IgnoreCase',true)
            k = strfind(place_holder, 'NG     = ');
            place_holder(k:k+length('NG     = ')-1) = [];
            num_points = str2num(place_holder);
        end
        
        if contains(place_holder,'ALPHA    ALPHA/S(1)','IgnoreCase', true)
            
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
           current_line = current_line + 1;
           
           place_holder(place_holder == '*') = [];
           reduce  = strfind(place_holder,'  ');
           
           while any(reduce)
               place_holder(reduce(1)) = [];
               reduce = strfind(place_holder,'  ');
           end
           
           fprintf(fID2,strcat(place_holder,'\n'));
           fclose(fID2);
           
           if isempty(M)
                M = readtable('tempfile.txt');
                M.Var9(1,1) = current_line;
                M.Properties.VariableNames{9} = 'Line';
                count = 1;
           else
               count = count+1;
               N = readtable('tempfile.txt');
               N.Var9 = current_line;
               M(count,1:9) = N;
           end
           delete tempfile.txt

        end
        
        place_holder = fgets(fID);
        current_line = current_line + 1;
    end
    fclose(fID);
    
    current_alpha = 0;
    prev_alpha = 0;
    check = 0;
    for i = 1:height(M)
        current_alpha = M.ALPHA(i);
        if i ~= 1
            if current_alpha < prev_alpha
                fine_begin = i;
                check = 1;
            end
        end
        
        if ~check
            prev_alpha = current_alpha;
        else
            break
        end
    end
    M(1:(fine_begin-1),:) =[];
    M = sortrows(M,'DEGFREEDOM','ascend');
    best_line = M.Line(1);
    fID2 = fopen('tempfile2.txt','w');
    fID = fopen(f_name);
    
    for i = 1:best_line+2
        place_holder = fgets(fID);
    end
    
    for i = 1:num_points
        place_holder = fgets(fID);
        fprintf(fID2,strcat(place_holder(1:31),'\n'));
    end
    fclose(fID);
    fclose(fID2);
    data = table2array(readtable('tempfile2.txt'));
    semilogx(data(:,3),data(:,1),strcat('-',style(mod(iter,8)+1)),'LineWidth',0.3);
    fclose('all');
    delete('tempfile2.txt')
end

set(gca,'XScale','log')
ylim([0 0.03])
xlabel('\tau')
ylabel('f(\tau)')
title('All solutions with minimized degrees of freedom for Cu15 tests sample 3')
name_cell = cell(length(files),1);
    files2 = dir('*.out');
    name_list = {files2.name}';
    sort_cell = regexp(name_list,'Test\d{4}','match','once');
legend(sort_cell,'Location','northwest')

savefig(gcf,'min_deg_fdm_soln.fig')