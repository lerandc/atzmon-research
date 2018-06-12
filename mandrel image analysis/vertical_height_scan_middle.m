function [new_image_matrix] = vertical_height_scan_middle(orig_image_matrix, rows, col, width, part_dens, upper_limit, lower_limit, height_diff, height_prev, n_init, start_col, dir)

    height_prev = int32(height_prev); %initial height parameter
    height_vec = 1:1:col; %vector storing heights
    height_vec(1:1:(width-width/2)) = height_prev;
    
    n_vec = 1:1:col;  %vector storing number of pixels in one search column
    n_vec(1:1:(width-width/2)) = n_init;
    
    method_vec = 1:1:col; %vector storing which height determination method used (for debugging)
    method_vec(1:1:(width-width/2)) = 0;
    height = 0; 
    flip = 0;
    orig_height_diff = height_diff;
    height_diff_vec = 1:1:col;
    
    
    new_image_matrix = orig_image_matrix;
    
    if dir == 1
        final_col = col-width/2+1;
        move = 1;
        offset_col = start_col - width/2;
    elseif dir == 0
        final_col = width/2;
        move = -1;
        offset_col = start_col + width/2;
    end
    
    for k = (start_col:move:final_col)
        kDiff = abs(k-offset_col);
        
        if kDiff > 10
            height_diff = orig_height_diff + round(abs(height_vec(kDiff-1)-height_vec(kDiff-5)))+kDiff/500;
        end
        
        N = int32(0);
        for j = ((k- width/2 + 1):1:(k+width/2 - 1))
            for i = (1:1:rows)
                if orig_image_matrix(i,j) < 20
                    N = N + 1;
                end
            end
        end
    
        Nx = 1:1:N;
        Ny = 1:1:N;
    
        pt = 1;
        for j = ((k- width/2 + 1):1:(k+width/2 - 1))
            for i = (1:1:rows)
                if orig_image_matrix(i,j) < 20
                    Ny(pt) = i;
                    Nx(pt) = j;
                    pt = pt + 1;
                end
            end
        end
    
        if (abs(kDiff) > 100) && (n_vec(kDiff-1) < 7)
            height = mean(diff(height_vec((kDiff-8):kDiff-1)))+height_vec(kDiff-1);
            method_vec(kDiff) = 1;
        elseif (N > part_dens + upper_limit) && (kDiff > 20)
            height = mean(diff(height_vec((kDiff-20):kDiff-1)))+height_vec(kDiff-1);
            method_vec(kDiff) = 2;
        elseif N < part_dens - lower_limit
            flip = 1;
        elseif abs(kDiff) > (col/2-20+width/2)
            height = mean(diff(height_vec((kDiff-8):kDiff-1)))+height_vec(kDiff-1);
            method_vec(kDiff) = 9;           
        else
            if (((N - n_vec(kDiff-2)) > n_vec(kDiff-2)*1.3) && (kDiff > 8))
                height = mean(diff(height_vec((kDiff-8):kDiff-1)))+height_vec(kDiff-1);
                method_vec(kDiff) = 5;
            else
                height = median(Ny);
                method_vec(kDiff) = 3;
            end
        end
    
        if flip == 0
            for i = (1:1:N)
                if abs(Ny(i)-height) > height_diff 
                    new_image_matrix(Ny(i), Nx(i)) = 255;
                end
            end
        elseif flip == 1
            for i = (1:1:N)
                new_image_matrix(Ny(i), Nx(i)) = 255;
            end
        
            if kDiff < 10
            height = (height_vec(kDiff-1) - height_vec(kDiff-2)) + height_vec(kDiff-1);
            else
            height = mean(diff(height_vec((kDiff-8):(kDiff-1))))+height_vec(kDiff-1);
            end
        
            method_vec(kDiff) = 4;
            flip = 0;
        end
    
        height_vec(kDiff) = height;
        n_vec(kDiff) = N;
        height_diff_vec(kDiff) = height_diff;
    end
    
end