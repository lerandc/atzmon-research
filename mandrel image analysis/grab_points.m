function [xVec, yVec] = grab_points(old_image_matrix, rows, col)

    z = 0;
    for i = (1:1:rows)
        for j = (1:1:col)
            if old_image_matrix(i,j) < 90 
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
            if old_image_matrix(i,j) < 90
                xVec(s) = j;
                yVec(s) = i;
                s = s +1;
            end
        end
    end
end