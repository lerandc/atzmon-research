function [new_image_matrix, hvec, nvec] = vertical_height_scan(orig_image_matrix, rows, col, width, part_dens, upper_limit, lower_limit, height_diff, height_prev, n_init, start_col, dir)

    height_prev = int32(height_prev); %initial height parameter
    height_vec = 1:1:col; %vector storing heights
    height_vec(1:1:(width-width/2)) = height_prev;
    
    n_vec = 1:1:col;  %vector storing number of pixels in one search column
    n_vec(1:1:(width-width/2)) = n_init;
    
    method_vec = 1:1:col; %vector storing which height determination method used (for debugging)
    method_vec(1:1:(width-width/2)) = 0;
    height = 0; 
    flip = 0;
    
    new_image_matrix = orig_image_matrix;
    
    if dir == 1
        final_col = col-width/2+1;
        move = 1;
    elseif dir == 0
        final_col = width/2;
        move = -1;
    end
    
    for k = (start_col:move:final_col)
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
    
        if (k > 100) && (n_vec(k-1) < 7)
            height = mean(diff(height_vec((k-8):(k-1))))+height_vec(k-1);
            method_vec(k) = 1;
        elseif (N > part_dens + upper_limit) && (k > 20)
            height = mean(diff(height_vec((k-20):(k-10))))+height_vec(k-1);
            method_vec(k) = 2;
        elseif N < part_dens - lower_limit
            flip = 1;
        else
            if (N - n_vec(k-2)) > 35 && k > 9;
                height = mean(diff(height_vec((k-8):(k-1))))+height_vec(k-1);
                method_vec(k) = 5;
            else
                height = median(Ny);
                method_vec(k) = 3;
                

                if k > 100 %you are so close buddy
                    
                    special_case_check = method_vec(k-10:k-1);
                    special_case_check = special_case_check - 3;
                    SCC = any(special_case_check);
                    
                    seventeen_check = method_vec(k-10:k-1);
                    seventeen_check = seventeen_check - 17;
                    seventeen_check = ~seventeen_check;
                    STC = any(seventeen_check);
                    
                    if (abs(height - mean(height_vec(k-10:k-1))) > 30) && (~SCC || STC)
                       height = mean(diff(height_vec((k-10):(k-3))))+height_vec(k-3);
                       method_vec(k) = 17;
                    end
                    
                end
                
                
            end
        end
    
        if flip == 0;
            for i = (1:1:N)
                if abs(Ny(i)-height) > height_diff 
                    new_image_matrix(Ny(i), Nx(i)) = 255;
                end
            end
        elseif flip == 1;
            for i = (1:1:N)
                new_image_matrix(Ny(i), Nx(i)) = 255;
            end
        
            if k < 10
            height = (height_vec(k-1) - height_vec(k-2)) + height_vec(k-1);
            else
            height = mean(diff(height_vec((k-8):(k-1))))+height_vec(k-1);
            end
        
            method_vec(k) = 4;
            flip = 0;
        end
    
        height_vec(k) = height;
        n_vec(k) = N;
    end
    
    for i = 1:1:col
        if n_vec(i) > (part_dens + upper_limit + 10)
           new_image_matrix(:, i) = 255;
        end    
    end
    
    hvec = height_vec;
    nvec = n_vec;
end