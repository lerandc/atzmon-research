function [new_image_matrix] = horizontal_scan(old_image_matrix, rows, col, width, dir)
    new_image_matrix = old_image_matrix;
    n_vec = 1:1:rows;
    n_vec = 0.*n_vec;
    flip = 0;
    
    middle_column = col/2;
    
    if dir == 1
        move = 1;
        final_col = col;
    elseif dir == 0
        move = -1;
        final_col = 1;
    end
    
    
    %this is used for not deleting large chunks of data
        for k = ((width/2):1:(rows-width/2))
        N = int32(0);
            for j = (middle_column:move:final_col)
                for i = ((k-width/2+1):1:(k+width/2-1))
                    if old_image_matrix(i,j) < 20
                    	N = N + 1;
                    end
                end
            end
        n_vec(k) = N;
        end
     
     for k = ((width/2):10:(rows-width/2))
        N = int32(0);
    
        for j = (middle_column:move:final_col)
            for i = ((k-width/2+1):1:(k+width/2-1))
                if old_image_matrix(i,j) < 20
                    N = N + 1;
                end
            end
        end
        
        Nx = 1:1:N;
        Ny = 1:1:N;
    
        pt = 1;
        for j = (middle_column:move:final_col)
            for i = ((k-width/2+1):1:(k+width/2-1))
                if old_image_matrix(i,j) < 20
                    Ny(pt) = i;
                    Nx(pt) = j;
                    pt = pt + 1;
                end
            end
        end
    
        if N < 40
            if n_vec(k-width/3) < 40 && n_vec(k+width/3) < 40
                 flip = 1;
            end
        end
    
        if flip == 0;
            horiz_dist = median(Nx);
            for i = (1:1:N)
                if abs(Nx(i)-horiz_dist) > 250
                    new_image_matrix(Ny(i), Nx(i)) = 255;
                end
            end
        elseif flip == 1;
            for i = (1:1:N)
                new_image_matrix(Ny(i), Nx(i)) = 255;
            end
            flip = 0;
        end
     end
     
end