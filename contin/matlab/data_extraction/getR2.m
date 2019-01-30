function Rsquared = calc_Rsquared(orig_data,fit)
%Luis Rangel DaCosta 9/26/18
%calculate R^2 measure of goodness of fit
%input is the original data and the fit data as vectors of the same length
%fitting assumes that the original y and the fit y have the same
%independent variable correspondence

    y_bar = mean(fit);
    SS_tot = sum((fit-y_bar).^2);
    SS_res = sum((fit-orig_data).^2);
    Rsquared = 1 - SS_res./SS_tot;
end