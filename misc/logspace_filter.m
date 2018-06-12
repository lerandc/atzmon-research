clearvars
%opens up directory list as a structure
files = dir('*.txt');

for j = 1:length(files)
    
    
        name = files(j).name;%.txt';
        name = name(1:end-4);
        %reads in formatted data from nanoindentation file
        data = readtable(strcat(name,'.txt'));
        
        %cutoff values for grabbing analysis data
        ind_start = find(data.Load__N_ > 199.9, 1, 'first');
        ind_end = find(data.Load__N_ > 195, 1, 'last');
        
        %grabs smaller m atrix of only necessary data
        data = data(ind_start:ind_end,:);
        
        
        %indentifier for current 'bucket'
        current = 1;
        list = 1:size(data,1); %list of all indices
        newlist = []; newlist2 = []; %lists of indices
        %exponents for powers of 2
        expo = 5:15;
        
        
        val1 = data.Depth_nm_;
        val2 = data.Time_s_;
        %%%1 from each group
        for iter = expo %iterate through various exponents
            [append,current] = get_first(list,iter,current);
            newlist = [newlist append]; 
        end

        %averages from each group
        current = 1;
        for iter = expo
            [append,current] = get_avg(list,iter,current,val1,val2);
            newlist2 = [newlist2; append];
        end
        
        %indexed filters for data
        depths = data.Depth_nm_(newlist); 
        times = data.Time_s_(newlist);
        
        %perform operations on data to normalize
        depths = (depths-depths(1))./depths(1); 
        times = times-times(1);
        
        %same as above, for averages
        depths2 = newlist2(:,1); depths2(depths2==0) = [];
        times2 = newlist2(:,2); times2(times2==0) = [];
        
        depths2 = (depths2-depths2(1))./depths2(1);
        times2 = times2-times2(1);
        
        %writes data to files
        csvwrite(strcat(name,'1.csv'),[depths times]);
        csvwrite(strcat(name,'2.csv'),[depths2 times2]);


end

function [addons,new_iter] = get_first(master_list, expo, current)
    %seperates groups of 2^N for N >= 5 elements into 32 selected elements
    %using standard interval size so that chosen elements are equally
    %spaced, IE:, every element in N=5, every 2nd element in N=6, every 4th
    %element in N=7
    
    %this function chooses 1st element in every separated group
    len = [];
    if current+2^expo-1 < length(master_list) %checks to see if bin group is larger than # of elements
        bin = master_list(current:current+2^expo-1); %if not, take 2^N sized group of elements
    else
        bin = master_list(current:end); %else take all remaining elements
        len = 2^expo; %arbitrary length to prevent errors
    end
    
    indices = 1:length(bin); 
    if isempty(len) 
        len = length(indices); %create list of indices for bin elements
    end
    
    if length(indices) ~= 32 %for bin size = number of elements needed, skip selection
        selected = ~mod(indices,len/32); %if not, select all elements at beginning of group
        addons = bin(selected);
    else
        addons = bin; %from 87, skip selectiona and add all new elements
    end
    new_iter = current+2^expo; %get start iterator for next selection
end 

function [addons,new_iter] = get_last(master_list, expo, current)
    %seperates groups of 2^N for N >= 5 elements into 32 selected elements
    %using standard interval size so that chosen elements are equally
    %spaced, IE:, every element in N=5, every 2nd element in N=6, every 4th
    %element in N=7
    
    %this function chooses last element in every separated group
    %all comments same as get_first except where noted
    len = [];
    if current+2^expo-1 < length(master_list)
        bin = master_list(current:current+2^expo-1);
    else
        bin = master_list(current:end);
        len = 2^expo;
    end
    
    indices = 1:length(bin);
    if isempty(len)
        len = length(indices);
    end
    
    if length(indices) ~= 32
        selected = ~mod(indices-1,len/32); %selects shifted elements from start of group
        addons = bin(selected);
    else
        addons = bin;
    end
    new_iter = current+2^expo;
end

function [addons,new_iter] = get_avg(master_list, expo, current, val1, val2)
    %seperates groups of 2^N for N >= 5 elements into 32 selected elements
    %using standard interval size so that chosen elements are equally
    %spaced, IE:, every element in N=5, every 2nd element in N=6, every 4th
    %element in N=7
    
    %this function takes the average values of each group as the chosen
    %elements
    
    %comments same as above except where noted
    len = [];
    if current+2^expo-1 < length(master_list) 
        bin = master_list(current:current+2^expo-1);
    else
        bin = master_list(current:end);
        len = 2^expo;
    end
    
    indices = 1:length(bin);
    if isempty(len)
        len = length(indices);
    end
    
    if length(indices) ~= 32
        selected = ~mod(indices-1,len/32);
        %averages values of group for both x and y
        addons = [averages(selected,val1(bin),len)' averages(selected,val2(bin),len)'];
    else
        addons = [val1(bin) val2(bin)];
    end
    
    new_iter = current+2^expo;
end

function means = averages(input_vector,values,len)
    %creates storage vector
    means = zeros(1,32);
    %size of group
    count = len/32;  
    %index for means vector
    mean_ind = 1;
    
    for i = 1:length(input_vector)
        if input_vector(i) == 1 %checks if element is start of group
            if length(input_vector) < i+count-1 %for last group, if # of elements is not 32
                means(mean_ind) = mean(values(i:end)); 
            else
                means(mean_ind) = mean(values(i:i+count-1)); %else take value of elements i through end of group
            end
            mean_ind = mean_ind+1;
        end 
    end
  
end