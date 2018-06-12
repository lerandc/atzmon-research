clearvars
load test.mat

list = zeros(length(y),1);
for iter = 2:length(y)-1
    if y(iter) > y(iter-1) && y(iter) > y(iter+1)
        list(iter) = 1;
    end  
end

x_peak = x.*list; y_peak = y.*list;
x_peak(x_peak==0) = [];
y_peak(y_peak==0) = [];

semilogx(x,y,'o')
hold on
semilogx(x_peak,y_peak,'*k')