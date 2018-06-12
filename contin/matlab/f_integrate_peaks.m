close all
clearvars

files = dir('*.mat');

filename = 'spreadsheet.xls';

char_list = char([68:90 97:122])';
tic
for iter = 1:length(files)
    name = files(iter).name;
    load(name);
    data = table2array(N);
    row = 1;
    
    for N_peaks = 1:7
        [coef, fitresult, gof] = fitLogNormal(data,N_peaks,char_list);
        areas = integratePeaks(coef,data,N_peaks);    
    
        plot(fitresult)
        a = gca; a.XScale = 'log';
        hold on
        plot(data(:,3),data(:,1),'o')
        xlabel('\tau')
        ylabel('f(\tau)')
        
        name2 = name;
        name2(name2 == '_') = '-';
        
        title(['Peak fitting for ' name2(1:end-4) ' with N_{peaks} = ' num2str(N_peaks)])
        fig = gcf;
        fig.Position = [300 400 800 400];
        legend({'Fit Line','Spectra'},'Location','northwest')
        saveas(fig,strcat(name(1:end-4),'_N_peaks',num2str(N_peaks),'.tiff'));
        close all
        
        xlswrite(filename,{name},iter,strcat('A',num2str(row),':A',num2str(row)));
            row = row +1;
        xlswrite(filename,M.Properties.VariableNames,iter,strcat('A',num2str(row),':H',num2str(row)));
            row = row +1;    
        xlswrite(filename,table2array(M),iter,strcat('A',num2str(row),':H',num2str(row)));
            row = row +1;
        xlswrite(filename,{'N_peaks',N_peaks},iter,strcat('A',num2str(row),':B',num2str(row)))
            row = row +1;
        xlswrite(filename,{'sse','R^2','dfe','adj. R^2','RMSE';...
                gof.sse,gof.rsquare,gof.dfe,gof.adjrsquare,gof.rmse},...
                iter,strcat('A',num2str(row),':E',num2str(row+1)))
                row = row +2;
        xlswrite(filename,{'A_m','C_m','tau_m','Area'},iter,strcat('A',num2str(row),':D',num2str(row)))
            row = row +1;
        xlswrite(filename,[coef areas],iter,strcat('A',num2str(row),':D',num2str(row-1+size(coef,1))));
            row = row + size(coef,1)+2;
    end
    clearvars M N
    toc
end


% 
function [fit_matrix, fitresult, gof] = fitLogNormal(data,N_peaks,char_list)
    [x,y] = prepareCurveData(data(:,3),data(:,1));
    tau_extrema = getPeaks(x,y,N_peaks);
    
    opts = fitoptions( 'Method', 'NonlinearLeastSquares');
    opts.Display = 'Off';
    opts.Robust = 'LAR';
    
    ft = generateFitType(N_peaks,char_list);
    
    A_list = ~mod((1:N_peaks*3)+2,3);
    tau_list = ~mod((1:N_peaks*3)+1,3);
    C_list = ~mod((1:N_peaks*3)+0,3);

    A = max(y)*ones(N_peaks,1);
    C = 0.5*ones(N_peaks,1);
    tau = sort(tau_extrema);
    if length(tau_extrema) < N_peaks
        appends = 10^(log10(min(x)));
        appends = appends.*ones(N_peaks-length(tau_extrema),1);
        tau = [appends; tau];
    end
    
    starts = 1:(N_peaks*3);
    starts(A_list) = A; starts(tau_list) = tau; starts(C_list) = C;
    opts.StartPoint = starts;

    opts.Lower = zeros(N_peaks*3,1);

    ub = 1:(N_peaks*3);
    ub(A_list) = 10.*A; ub(tau_list) = 2.*max(x); ub(C_list) = Inf;
    opts.Upper = ub;
    [fitresult, gof] = fit( x, y, ft, opts );
    coef = coeffvalues(fitresult);
    A_m = coef(A_list); %A_m(A_m==0)=[];
    tau_m = coef(tau_list); tau_m(tau_m==0)=[];
    C_m = coef(C_list); C_m(C_m==0)=[];
    fit_matrix = [A_m' tau_m' C_m'];
end

function [ft] = generateFitType(N_peaks, char_list)
    eqn_string = 'A.*exp(-((log(x./B)./C).^2))';
    N = N_peaks-1;
    iter = 1;
    while N > 0
        eqn_string = strcat(eqn_string,'+',char_list(iter),...
            '.*exp(-((log(x./',char_list(iter+1),')./',char_list(iter+2),...
            ').^2))');
        N = N -1;
        iter = iter+3;
    end   
    ft = fittype(eqn_string,'independent','x','dependent','y');
end

function [tau_extrema] = getPeaks(x,y,N_peaks)
    list = zeros(length(y),1);
    for iter = 2:length(y)-1
        if y(iter) > y(iter-1) && y(iter) > y(iter+1)
            list(iter) = 1;
        end  
    end

    x_peak = x.*list; y_peak = y.*list;
    x_peak(x_peak==0) = [];
    y_peak(y_peak==0) = [];
    
    if N_peaks < length(y_peak)
        [~,indices] = maxk(y_peak,N_peaks);
        tau_extrema = x_peak(indices);
    else
        tau_extrema = x_peak;
    end 
end

function [areas] = integratePeaks(fit_matrix,data,N_peaks)
    fx = @(x,A,B,C) A.*exp(-(log(x./B)./C).^2);
    tau_min = min(data(:,3));
    tau_max = max(data(:,3));
    areas = zeros(N_peaks,1);
    
    for iter = 1:N_peaks
        A = fit_matrix(iter,1);
        B = fit_matrix(iter,2);
        C = fit_matrix(iter,3);
        area = integral(@(x)fx(x,A,B,C),tau_min,tau_max);
        areas(iter) = area;
    end
    
end