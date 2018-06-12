%defining f(tau)
clearvars
close all
name = 'fourpeaks_linspace.csv';
A_k = [.01 0.011 0.0115 0.012];
C_k = [0.5 0.5 0.5 0.5];
tau_i = [1.5 12 80 500];
f_tau = @(T) A_k(1).*exp(-(log(T./tau_i(1))./C_k(1)).^2)+... %first peak
    A_k(2).*exp(-(log(T./tau_i(2))./C_k(2)).^2)+... %second peak
    A_k(3).*exp(-(log(T./tau_i(3))./C_k(3)).^2)+... %third peak
    A_k(4).*exp(-(log(T./tau_i(4))./C_k(4)).^2); 

x = 0:0.0001:1000;
y = f_tau(x);
semilogx(1./x,y);
hold on

%function to integrate
conv = @(T,W) (A_k(1).*exp(-(log(T./tau_i(1))./C_k(1)).^2)+... %first peak
    A_k(2).*exp(-(log(T./tau_i(2))./C_k(2)).^2)+... %second peak
    A_k(3).*exp(-(log(T./tau_i(3))./C_k(3)).^2)+...
    A_k(4).*exp(-(log(T./tau_i(4))./C_k(4)).^2)).*(W./(1+(W.^2).*(T.^2)));

time = 0.001:0.01:1e3;
W = 1./time;
%W = linspace(0.001,1e3,500)';
%W = exp(W);
y_i = zeros(length(W),1);

for i = 1:length(W)
    y_i(i) = integral(@(T)conv(T,W(i)),1e-3,1000);
end

semilogx(W,y_i)

%%adding noise to data
a = 1;
b = -4;
dev = a*10^(b);
N = length(y_i);
noise_i = dev.*randn(N,1);
y_i = noise_i+y_i;
%y_i = 1 - y_i;
%M = [t_i,y_i];
hold on
semilogx(W,y_i,'k.','MarkerSize',2)
M = [W y_i];
csvwrite(name,M);
