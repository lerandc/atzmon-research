function [noise] = applyLinearNoise(max_noise,min_noise,N,direction)

    if direction == 'increasing'
        noise = linspace(min_noise,max_noise,N);
    elseif direction == 'decreasing'
        noise = linspace(max_noise,min_noise,N);
    end

end