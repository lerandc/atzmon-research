clear

directory_name = uigetdir;
files = dir(directory_name);

fileIndex = find(~[files.isdir]);

pic_info = cell(length(fileIndex),2);
start_time = input('Enter the starting date in DD-MMM-YYYY HH:MM:SS format: ', 's');

for i= 1:1:length(fileIndex)
    pic_info{i,1} = files(fileIndex(i)).name;
    pic_time = imfinfo(files(fileIndex(i)).name);
    end_time = pic_time.DateTime;
    end_time(5) = '-';
    end_time(8) = '-';
    pic_info{i,2} = elapsed_time(start_time, end_time);
end

[not_used, sort_index] = sort([pic_info{:,2}], 'ascend');
sorted_pic_info = pic_info(sort_index, :);
xlswrite('name_list.xls',sorted_pic_info);