clear
clc

format long; 
directory_name = uigetdir;
files = dir(directory_name);

fileIndex = find(~[files.isdir]);

for filecount = 1:length(fileIndex)
    clearvars -except files fileIndex filecount
    clc
    
    image_file = files(fileIndex(filecount)).name;
    
    output_name = strcat(image_file(1:end-4), '.csv');
    
    image_matrix = imread(image_file);
    image_matrix = double(image_matrix);
    [rows, col, ~] = size(image_matrix);
    rows = int32(rows);
    col = int32(col);

    squaresize = int32(49);  %parameter
    intensity = int32(25); %parameter

    pic0 = light_level_clean(image_matrix,rows,col,squaresize,intensity);
    
    %imwrite(pic0, strcat(image_file(1:end-4), '-0.jpg'))
    
    w = int32(5); %width of column 
    M = int32(25); %number of particles in given length of sample
    sig1 = int32(35); %paramter used to check if too many pixels in search column
    sig2 = int32(18); %paramter used to check if too few pixels in search column
    sig3 = int32(7); %paramter used to check distance of particles from median
    
    %last argument 1 scans right, 0 scans left
    [pic1, hvec, nvec] = vertical_height_scan(pic0, rows, col, w, M, sig1, sig2, sig3, (rows/2), 0, (w/2), 1);
    %imwrite(pic1, strcat(image_file(1:end-4), '-1.jpg'))
   
    
    middle_height = hvec(col/2);
    middle_N = nvec(col/2);
    
    sig3 = int32(3); %paramter used to check distance of particles from median
    
    pic2 = vertical_height_scan_middle(pic1, rows, col, w, M, sig1, sig2, sig3, middle_height, middle_N, col/2, 1);
    pic2 = vertical_height_scan_middle(pic2, rows, col, w, M, sig1, sig2, sig3, middle_height, middle_N, col/2, 0);
    
    %imwrite(pic2, strcat(image_file(1:end-4), '-2.jpg'))
    
    w = int32(15); %width of column 
    
    pic3 = horizontal_scan(pic2,rows,col,w,1);
    pic3 = horizontal_scan(pic3,rows,col,w,0);
    
    imwrite(pic3, strcat(image_file(1:end-4), '-3.jpg')) 
    
    z = 0;
    for i = (1:1:rows)
        for j = (1:1:col)
            if pic3(i,j) < 90 
                z = z + 1;
            end
        end
    end

    xVec = 1:1:z;
    yVec = 1:1:z;

    xVec = xVec';
    yVec = yVec';

    s = 1;
    for i = (1:1:rows)
        for j = (1:1:col)
            if pic3(i,j) < 90
                xVec(s) = j;
                yVec(s) = i;
                s = s +1;
            end
        end
    end

    
    xVec = xVec - min(xVec);
    yVec = max(yVec) - yVec;
    
    m = [xVec yVec];

    csvwrite(output_name,m);
end