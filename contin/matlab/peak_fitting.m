clearvars
close all
format shortE
name = 'Spectrum.xls';
%IF xls, use line 6, comment line 7, if csv, comment line 6, use line 7
%[x,~] = xlsread(name); y = x(:,2); x = x(:,1);
%[x,y] = csvread(name);


load constrain_test2_alpha_1.mat
data = table2array(N);
x = data(:,3);
y = data(:,1);
% %6 peaks
% N = 6;
% [x,y] = prepareCurveData(x,y);
% ft = fittype( strcat('A.*exp(-((log(x./B)./C).^2))+D.*exp(-((log(x./E)./F).^2))',...
% '+G.*exp(-((log(x./H)./K).^2))+L.*exp(-((log(x./M)./N).^2))',...
% '+O.*exp(-((log(x./P)./Q).^2))+R.*exp(-((log(x./S)./T).^2))'), 'independent', 'x', 'dependent', 'y' );

% %5 peaks
% N = 5;
% [x,y] = prepareCurveData(x,y);
% ft = fittype( strcat('A.*exp(-((log(x./B)./C).^2))+D.*exp(-((log(x./E)./F).^2))',...
% '+G.*exp(-((log(x./H)./K).^2))+L.*exp(-((log(x./M)./N).^2))',...
% '+O.*exp(-((log(x./P)./Q).^2))'), 'independent', 'x', 'dependent', 'y' );

%4 peaks
N = 4;
[x,y] = prepareCurveData(x,y);
ft = fittype( strcat('A.*exp(-((log(x./B)./C).^2))+D.*exp(-((log(x./E)./F).^2))',...
'+G.*exp(-((log(x./H)./K).^2))+L.*exp(-((log(x./M)./N).^2))'), 'independent', 'x', 'dependent', 'y' );

opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Robust = 'LAR';

A_list = ~mod((1:N*3)+2,3);
tau_list = ~mod((1:N*3)+1,3);
C_list = ~mod((1:N*3)+0,3);

A = 0.1*ones(N,1);
tau = 10.^(0:(N-1));
C = 0.5*ones(N,1);

starts = 1:(N*3);
starts(A_list) = A; starts(tau_list) = tau; starts(C_list) = C;
opts.StartPoint = starts;

opts.Lower = zeros(N*3,1);

ub = 1:(N*3);
ub(A_list) = 10.*A; ub(tau_list) = 2.*max(x); ub(C_list) = Inf;
opts.Upper = ub;

% Fit model to data.
[fitresult, gof] = fit( x, y, ft, opts );
coef = coeffvalues(fitresult);

A_m = coef(A_list); %A_m(A_m==0)=[];
tau_m = coef(tau_list); tau_m(tau_m==0)=[];
C_m = coef(C_list); C_m(C_m==0)=[];
fit_matrix = [A_m' tau_m' C_m'];
% Plot fit with data.
figure
h = plot( fitresult, x, y );
legend('hide')
% Label axes
xlabel x
ylabel y
grid on
ax = gca;
ax.XScale = 'log';