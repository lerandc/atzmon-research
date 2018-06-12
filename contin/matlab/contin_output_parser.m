files = dir('*.out');

for iter = 1:length(files)
    
    name = files(iter).name;

    fID = fopen(name);

    place_holder = fgets(fID);

    while(place_holder ~= -1)
        if contains(place_holder,'CHOSEN SOLUTION','IgnoreCase', true)
            break;
        end
        place_holder = fgets(fID);
    end

    chosen_solution = fopen(strcat(name(1:end-4),'_parsed_out.txt'),'w+');
    while(place_holder ~= -1)
        fprintf(chosen_solution,place_holder);
        place_holder = fgets(fID);
    end

    fclose(fID);
    fclose(chosen_solution);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cID = fopen(strcat(name(1:end-4),'_parsed_out.txt'));
    place_holder = fgets(cID);
    while(place_holder ~= -1)
        if contains(place_holder, 'ORDINATE  ABSCISSA','IgnoreCase', true)
            break;
        end
        place_holder = fgets(cID);
    end

    n = length(place_holder);
    t_v_ft = fopen(strcat(name(1:end-4),'_parsed_out_t_v_ft.txt'),'w+');
    while(~contains(place_holder,'CONTIN'))
        fprintf(t_v_ft,strcat(place_holder(1:(n-1)),'\n'));
        place_holder = fgets(cID);
    end

    fclose(t_v_ft);
    fclose(cID);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%55
    cID = fopen(strcat(name(1:end-4),'_parsed_out.txt'));
    place_holder = fgets(cID);
    while(place_holder ~= -1)
        if contains(place_holder, 'ORDINATE    ERROR  ABSCISSA','IgnoreCase', true)
            break;
        end
        place_holder = fgets(cID);
    end

    n = length(place_holder);
    tau_v_ftau = fopen(strcat(name(1:end-4),'_parsed_out_tau_v_ftau.txt'),'w+');
    while(~contains(place_holder,'LINEAR COEFFICIENTS'))
        fprintf(tau_v_ftau,strcat(place_holder(1:(n-1)),'\n'));
        place_holder = fgets(cID);
    end

    fclose(tau_v_ftau);
    fclose(cID);

end