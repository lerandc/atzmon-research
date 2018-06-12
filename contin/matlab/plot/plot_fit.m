clearvars
close all
files = dir('*.out');

for iter = 3%1:length(files)
    
    name = files(iter).name;

    fID = fopen(name);

    place_holder = fgets(fID);

    while(place_holder ~= -1)
        if contains(place_holder,'NY ','IgnoreCase',true)
            k = strfind(place_holder, 'NY ');
            place_holder(k:k+length('NY ')-1) = [];
            num_points = str2num(place_holder);
        end
        
        if contains(place_holder,'            T            Y','IgnoreCase', true)
            break;
        end
        place_holder = fgets(fID);
    end
    
    fID2 = fopen('tempfile.txt','w');
    n_rows = ceil(num_points/5);
    for iter2 = 1:n_rows
        place_holder = fgets(fID);
        fprintf(fID2,'%s \n',place_holder);
    end
    
    while(place_holder ~= -1)
        if contains(place_holder,'0PLOT','IgnoreCase', true)
                break;
        end
        place_holder = fgets(fID);
    end
    
    place_holder = fgets(fID); place_holder = fgets(fID);
    fID3 = fopen('tempfile2.txt','w');
    
    for iter2 = 1:num_points
        place_holder = fgets(fID);
        fprintf(fID3,'%s \n', place_holder(1:22));
    end
    
    fclose(fID2);
    fclose(fID3);
    
    remainder = mod(num_points,5);
    orig = readtable('tempfile.txt');
    fit = readtable('tempfile2.txt');
    
    orig = table2array(orig);
    orig = [orig(:,1:2); orig(:,3:4); orig(:,5:6); orig(:,7:8); orig(:,9:10);];
    orig(isnan(orig(:,1)),:) = [];
    
    fit = table2array(fit(:,1:2));
    fit(:,2) = sort(orig(:,1));
    
    plot(orig(:,1),orig(:,2),'k.','MarkerSize',0.1)
    hold on
    plot(fit(:,2),fit(:,1),'r','LineWidth',2)
    fclose('all');
end