function [noise] = applySinusoidalNoise(phase,frequency,mean,amplitude,N)
%Luis Rangel DaCosta 11/13/2018
%unction to generate non-uniform gaussian noise to anelastic strain data
%phase, frequency, mean, amplitude have their normal definitons
%frequency in Hz, phase in seconds, mean and amplitude in units of strain
%give all values as scalar floats
%N is the number of points in the strain curve
%inputs are converted to integer values through 300 points/second sampling
%rate of nanoindenter
points = (1:N).*(2*pi/300);
phase = phase*2*pi;
noise = mean+amplitude*sin(frequency.*points+phase);

end

