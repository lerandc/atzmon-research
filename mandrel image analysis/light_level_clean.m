function [new_image_matrix] = light_level_clean(orig_image_matrix, rows, col, square_size, intensity_limit)

    grey_scale(1:1:rows, 1:1:col) = (1*orig_image_matrix(1:1:rows, 1:1:col, 1) + 1*orig_image_matrix(1:1:rows, 1:1:col, 2)...
        + 1*orig_image_matrix(1:1:rows, 1:1:col, 3))/3;
    %3, 1, and 10 are parameters
    brightest = max(max(grey_scale));
    grey_scale(1:1:rows, 1:1:col) = ((grey_scale(1:1:rows, 1:1:col)-brightest)/(-brightest))*(-255) + 255;
    grey_scale = uint8(grey_scale);
  
    grey_scale_copy = grey_scale;
    

    for i = (1:1:rows)
        for j = (1:1:col)
            if (i-1) < (square_size/2 - 1) && (j-1) < (square_size/2 - 1) %corner
                if grey_scale_copy(i,j) < sum(sum(grey_scale(1:1:square_size, 1:1:square_size)))/(square_size.^2) - intensity_limit
                    grey_scale_copy(i,j) = 0;
                else
                    grey_scale_copy(i,j) = 255;
                end
            elseif (i-1) < (square_size/2 - 1) && (col - j) < (square_size/2 - 1) %corner 
                if grey_scale_copy(i,j) < sum(sum(grey_scale(1:1:square_size, (col-(square_size-1)):1:col)))/(square_size.^2) - intensity_limit
                    grey_scale_copy(i,j) = 0;
                else
                    grey_scale_copy(i,j) = 255;        
                end
            elseif (rows - i) < (square_size/2 - 1) && (j-1) < (square_size/2 - 1) %corner
                if grey_scale_copy(i,j) < sum(sum(grey_scale((rows-(square_size-1)):1:rows, 1:1:square_size)))/(square_size.^2) - intensity_limit
                    grey_scale_copy(i,j) = 0;
                else
                    grey_scale_copy(i,j) = 255;              
                end      
            elseif (rows - i) < (square_size/2 - 1) && (col - j) < (square_size/2 - 1) %corner
                if grey_scale_copy(i,j) < sum(sum(grey_scale((rows-(square_size-1)):1:rows, (col-(square_size-1)):1:col)))/(square_size.^2) - intensity_limit
                    grey_scale_copy(i,j) = 0;
                else
                    grey_scale_copy(i,j) = 255;              
                end            
            elseif (i-1) < (square_size/2 - 1) %border far from other border
                if grey_scale_copy(i,j) < sum(sum(grey_scale(1:1:square_size, (j-(square_size/2 - 1)):1:(j+(square_size/2 - 1)))))/(square_size.^2) - intensity_limit
                    grey_scale_copy(i,j) = 0;
                else
                    grey_scale_copy(i,j) = 255;             
                end        
            elseif (rows - i) < (square_size/2 - 1) %border far from other border
                if grey_scale_copy(i,j) < sum(sum(grey_scale((rows-(square_size-1)):1:(rows), (j-(square_size/2 - 1)):1:(j+(square_size/2 - 1)))))/(square_size.^2) - intensity_limit
                    grey_scale_copy(i,j) = 0;
                else
                    grey_scale_copy(i,j) = 255;               
                end        
            elseif (j - 1) < (square_size/2 - 1) %border far from other border
                if grey_scale_copy(i,j) < sum(sum(grey_scale((i-(square_size/2 - 1)):1:(i+(square_size/2 - 1)), 1:1:square_size)))/(square_size.^2) - intensity_limit
                    grey_scale_copy(i,j) = 0;
                else
                    grey_scale_copy(i,j) = 255;             
                end        
            elseif (col - j) < (square_size/2 - 1) %border far from other border
                if grey_scale_copy(i,j) < sum(sum(grey_scale((i-(square_size/2 - 1)):1:(i+(square_size/2 - 1)), (col-(square_size-1)):1:col)))/(square_size.^2) - intensity_limit
                    grey_scale_copy(i,j) = 0;
                else
                    grey_scale_copy(i,j) = 255;               
                end        
            else
                if grey_scale_copy(i,j) < sum(sum(grey_scale((i-(square_size/2 - 1)):1:(i+(square_size/2 - 1)), (j-(square_size/2 - 1)):1:(j+(square_size/2 - 1)))))/(square_size.^2) - intensity_limit
                    grey_scale_copy(i,j) = 0;
                else
                    grey_scale_copy(i,j) = 255;               
                end            
            end
        end
    end
    
    new_image_matrix = grey_scale_copy;
    
end