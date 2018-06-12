
hold on
A_k = [0.01 0.011 0.0115 0.012];
C_k = [0.5 0.5 0.5 0.5 0.5 0.5];
tau_i = [1.5 12 80 500];
f_tau = @(T) A_k(1).*exp(-(log(T./tau_i(1))./C_k(1)).^2)+...
    A_k(2).*exp(-(log(T./tau_i(2))./C_k(2)).^2)+...
    A_k(3).*exp(-(log(T./tau_i(3))./C_k(3)).^2)+...
    A_k(4).*exp(-(log(T./tau_i(4))./C_k(4)).^2); %third peak

% x = 0:0.001:5000;
% y = f_tau(x);
% semilogx(x,y);
% hold on



%function to integrate
conv = @(T,t_i) (A_k(1).*exp(-(log(T./tau_i(1))./C_k(1)).^2)+... %first peak
    A_k(2).*exp(-(log(T./tau_i(2))./C_k(2)).^2)+...
    A_k(3).*exp(-(log(T./tau_i(3))./C_k(3)).^2)+...
    A_k(4).*exp(-(log(T./tau_i(4))./C_k(4)).^2)).*(1-exp(-t_i./T)).*(1./T);

lb = 1e-3;
ub = 1e3;
n_data = 5e4;
% t_i = linspace(log(lb),log(ub),n_data)'; %logspacing
% t_i = exp(t_i); %logspacing

t_i = linspace(lb,ub,n_data)'; %linspacing
y_i = zeros(length(t_i),1);

for i = 1:length(y_i)
    y_i(i) = integral(@(T)conv(T,t_i(i)),lb,ub);
end

semilogx(t_i,y_i)

%%adding noise to data
for i = 1:20
%defining f(tau)
name = strcat('Test',num2str(i),'.csv');
a = 5;
b = -4;
dev = a*10^(b);
N = length(y_i);
noise_i = dev.*randn(N,1);
data_with_noise = noise_i+y_i;
final_data = 1-data_with_noise;
M = [t_i,final_data];
close all
semilogx(M(:,1),M(:,2))
% hold on
% close all
% semilogx(t_i,y_i,'.','MarkerSize',8)
% 
% tau_v_ftau = tblread(strcat('sim_data-con-input_parsed_out','_tau_v_ftau.txt'));
% tau_v_ftau = [tau_v_ftau(:,3) tau_v_ftau(:,1) tau_v_ftau(:,2)]; %ordered so abscissa, ordinate, error
% semilogx(tau_v_ftau(:,1),tau_v_ftau(:,2),'o')
csvwrite(name,M);
end