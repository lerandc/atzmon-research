clear
clc

format long; 
answer = 'Y';
while(answer == 'Y' ||  answer == 'y')
    clear
    clc
    
    nprompt = 'Enter file name: ';
    iname = input(nprompt, 's');

    eprompt = 'Enter file extension: ';
    extension = input(eprompt, 's');

    csv = '.csv';
    oname = strcat(iname, csv);
    iImage = strcat(iname, extension);

    image = imread(iImage);
    image = double(image);
    [rows, col, ~] = size(image);
    
    bwIm2(1:1:rows, 1:1:col) = (image(1:1:rows, 1:1:col, 1) + image(1:1:rows, 1:1:col, 2) + image(1:1:rows, 1:1:col, 3))/3;
    bwIm2 = uint8(bwIm2); %overloads green color intensity and turns into black and white
    
    output = strcat(iname, 'BW', extension);
    %imwrite(bwIm2, output); 
    
    index_list = bwIm2 < 80;
    a = find(index_list);
    xVec = ceil(a/double(size(bwIm2,1)));
    yVec = mod(a,size(bwIm2,1));
    
    xVec = xVec - min(xVec);
    yVec = max(yVec) - yVec;
    m = [xVec yVec];

    csvwrite(oname,m);
        
    repeat = 'Would you like to run another picture? (Y/N): ';
    answer = input(repeat, 's');
end
