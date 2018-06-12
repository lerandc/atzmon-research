function f_auto_peak_integration(peak_range)

files = dir('*.mat');
name_list = {files.name}';
sort_names = regexp(name_list,'.+\-con\-input','match','once');

for iter = 1:length(sort_names)
    sort_names{iter}(end-9:end) = [];
end

unique_names = unique(sort_names);
count = 1;
char_list = char([68:90 97:122])';
iter2 = 1;

for iter = 1:length(files)
    filename = strcat(sort_names{iter},'.xls');
    name = files(iter).name;
    load(name);
    data = table2array(N);
    row = 1;
    
    tau_min = data(1,3); tau_max = data(end,3);
    log_space_points = linspace(log(tau_min),log(tau_max),1000);
    log_space_points = exp(log_space_points);
    
    data_cell = {};
    for N_peaks = 1:peak_range
        [coef, fitresult, gof] = fitLogNormal(data,N_peaks,char_list);
        areas = integratePeaks(coef,data,N_peaks);    
    
        semilogx(log_space_points,fitresult(log_space_points))
        hold on
        semilogx(data(:,3),data(:,1),'o')
        xlabel('\tau')
        ylabel('f(\tau)')
        
        name2 = name;
        name2(name2 == '_') = '-';
        
        title(['Peak fitting for ' name2(1:end-4) ' with N_{peaks} = ' num2str(N_peaks)])
        fig = gcf;
        fig.Position = [300 400 800 400];
        legend({'Fit Line','Spectra'},'Location','northwest')
        saveas(fig,strcat(name(1:end-4),'_N_peaks',num2str(N_peaks),'.tif'));
        clf
        data_cell(row,1) = {name};
            row = row +1;
        data_cell(row,1:8) = M.Properties.VariableNames;    
            row = row +1;    
        data_cell(row,1:8) = table2cell(M);
            row = row +1;
        data_cell(row,1:2) = {'N_peaks',N_peaks};
            row = row +1;
        data_cell(row:row+1,1:5) = {'sse','R^2','dfe','adj. R^2','RMSE';...
                gof.sse,gof.rsquare,gof.dfe,gof.adjrsquare,gof.rmse}; 
            row = row +2;
        data_cell(row,1:4) = {'A_m','C_m','tau_m','Area'};
            row = row +1;
        data_cell(row:row-1+size(coef,1),1:4) = num2cell([coef areas]);
            row = row + size(coef,1)+2;    
    end
    if ~isequal(sort_names{iter},unique_names{count})
        count = count+1;
        iter2 = 1;
    end
    xlswrite(filename,data_cell,iter2);
    clearvars M N
    
    iter2 = iter2 + 1;
end

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
        cond1 = y(iter) > y(iter-1); %greater than previous point
        cond2 = (y(iter) > y(iter+1)); %greater than following point
        if iter < length(y)-1
            cond3 = (y(iter) == y(iter+1)) && (y(iter+1) > y(iter+2));
        else
            cond3 = 0;
        end
        
        if cond1 && (cond2 || cond3)
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