clear
clc

format long; 

answer = 'Y';
while(answer == 'Y' || answer == 'y')
    clear
    clc
    
    prompt = 'Enter file name: ';
    img_name = input(prompt, 's');
    file_extension = '.jpg';
    
    csv = '.csv';
    output_name = strcat(img_name, csv);
    image_file = strcat(img_name, file_extension);

    image_matrix = imread(image_file);
    image_matrix = double(image_matrix);
    [rows, col, ~] = size(image_matrix);
    rows = int32(rows);
    col = int32(col);

    squaresize = int32(49);  %parameter
    intensity = int32(18); %parameter

    pic0 = light_level_clean(image_matrix,rows,col,squaresize,intensity);
    
    %imwrite(pic0, strcat(img_name, '-0.jpg'))
    
    w = int32(5); %width of column 
    M = int32(25); %number of particles in given length of sample
    sig1 = int32(35); %paramter used to check if too many pixels in search column
    sig2 = int32(18); %paramter used to check if too few pixels in search column
    sig3 = int32(7); %paramter used to check distance of particles from median
    
    %last argument 1 scans right, 0 scans left
    [pic1, hvec, nvec] = vertical_height_scan(pic0, rows, col, w, M, sig1, sig2, sig3, (rows/2), 0, (w/2), 1);
    %imwrite(pic1, strcat(img_name, '-1.jpg'))
   
    
    middle_height = hvec(col/2);
    middle_N = nvec(col/2);
    
    sig3 = int32(3); %paramter used to check distance of particles from median
    
    pic2 = vertical_height_scan_middle(pic1, rows, col, w, M, sig1, sig2, sig3, middle_height, middle_N, col/2, 1);
    pic2 = vertical_height_scan_middle(pic2, rows, col, w, M, sig1, sig2, sig3, middle_height, middle_N, col/2, 0);
    
    %imwrite(pic2, strcat(img_name, '-2.jpg'))
    
    w = int32(15); %width of column 
    
    pic3 = horizontal_scan(pic2,rows,col,w,1);
    pic3 = horizontal_scan(pic3,rows,col,w,0);
    
    %imwrite(pic3, strcat(img_name, '-3.jpg')) 
    
    [xVec, yVec] = grab_points(pic3,rows,col);
    pic4 = random_remove(pic3,xVec,yVec,5800);
    [xVec, yVec] = grab_points(pic4,rows,col);
    
    xVec = xVec - min(xVec);
    yVec = max(yVec) - yVec;
    
    m = [xVec yVec];

    csvwrite(output_name,m);
    
    repeat = 'Would you like to run another picture? (Y/N): ';
    answer = input(repeat, 's');
end