function [seconds] = elapsed_time(start_date, end_date)

start_time = datetime(start_date);
end_time = datetime(end_date);
duration_hms = datevec(between(start_time, end_time));
duration_days = datevec(between(start_time, end_time, 'Days'));

seconds = duration_hms(6)+60*duration_hms(5)+3600*duration_hms(4)+86400*duration_days(3);
end
