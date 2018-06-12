function [new_image_matrix] = random_remove(old_image_matrix, x_vec, y_vec, limit)

    if length(x_vec) < limit
        new_image_matrix = old_image_matrix;
    else
        remove_set = randperm(length(x_vec), (length(x_vec)-limit));
        for i = 1:1:(length(x_vec)-limit)
            old_image_matrix(y_vec(remove_set(i)),x_vec(remove_set(i))) = 255;
        end
        new_image_matrix = old_image_matrix;
    end
    
end
