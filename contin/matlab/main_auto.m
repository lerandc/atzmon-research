%main_auto
%runs all automated scripts in order so that data is processed completely

tau_min = 1e-3;
tau_max = 1e3;
N_tau = 100;
iquad = '2.';%2= trapezoid, 3 = simpsons
N_alpha = '6.'; %for the fine

for i = 1:1
    f_contin_input(tau_min,tau_max,N_tau,iquad,N_alpha)
end
tic
study = 1; %1 = static case, 2 = dynamic case
f_contin_input2(study)

fID = fopen('run_all');
place_holder = fgets(fID);
while (place_holder ~= -1)
    %system(place_holder)
    system(strcat('bash -c "',place_holder,'"'));
    place_holder = fgets(fID);
end
toc
%     
%contin_output_parser;
f_plot_all_alpha;  %no extension
peak_range = 4; %most number of peaks to experience 
%you should really figure out how to cut off new peaks once R^2 stops
%increasing
f_auto_peak_integration(peak_range)

files = dir('*.txt');
for i = 1:length(files)
delete(files(i).name)
end

files = dir('*.mat');
for i = 1:length(files)
delete(files(i).name)
end

fclose('all')