function getFitFromSpectra(filename,t_min,t_max,N)
%Luis Rangel DaCosta, 9/19/18
%uses spectra from solution to return fitline over arbitrary time values
%input is filename base as string, t boundaries for plotting in seconds,
%and N for the number of points one wishes to plot

    spectra = load([filename(1:end-4), '_spectra.mat']); spectra = spectra.spectra;
    coef = load([filename(1:end-4), '_lin_coef.mat']); coef = coef.coef;

    numFits = size(spectra,2);
    
    for i = 1:numFits
        tau_i = spectra(i).Data.ABSCISSA;
        e_i = spectra(i).Data.ORDINATE;
        lin_coef = coef(i).coef;
        t = linspace(t_min,t_max,N);
        temp = -t./tau_i;
        temp = exp(temp)./tau_i;
        temp = e_i.*temp;
        temp = sum(temp);
        
        fit = temp + lin_coef;
        
        semilogx(t,fit)
        hold on
        wait = 1;
    end
    wait = 1;
end 