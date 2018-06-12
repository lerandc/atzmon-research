clearvars
close all

list = dir('*_parsed_out.txt');

for iter = 1:length(list)
    
name = list(iter).name; %'500pointsNoise-con-input1_parsed_out.txt';

orig_data = csvread(strcat(name(1:end-25),'.csv'));

t_v_ft = tblread(strcat(name(1:end-4),'_t_v_ft.txt'));
t_v_ft = [t_v_ft(:,2) t_v_ft(:,1)]; %ordered so abscissa, ordinate

tau_v_ftau = tblread(strcat(name(1:end-4),'_tau_v_ftau.txt'));
tau_v_ftau = [tau_v_ftau(:,3) tau_v_ftau(:,1) tau_v_ftau(:,2)]; %ordered so abscissa, ordinate, error

semilogx(orig_data(:,1), orig_data(:,2), 'b.', 'MarkerSize', 8)
hold on
semilogx(t_v_ft(:,1), t_v_ft(:,2),'r.','MarkerSize',8)
semilogx(1./tau_v_ftau(:,1),tau_v_ftau(:,2),'ko','MarkerSize',6)

grid on
pbaspect([1 1 1])
title( name(1:end-15))
ylabel('f(\tau)')
xlabel('\omega')
saveas(gcf,strcat(name(1:end-15),'_loss.tiff'))
close
end
