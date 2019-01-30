function getLinCoef(filename)
%Luis Rangel DaCosta, 9/19/18
%Grabs solution spectra linear coefficients from CONTIN analysis
%input filename is a string

    %open filestream to CONTIN output and read first line
    inID = fopen(filename);
    str_hold = fgets(inID);

    %output variable that is saved
    coef = struct();

    %continually read lines from output until end of file is reached

    count = 1; %count of spectra for writing to struct
    while(str_hold ~= -1)
        %look for beginning of data for a solution spectrum
        if contains(str_hold,'0LINEAR COEFFICIENTS','IgnoreCase', true)
            %add new data to coef struct
            coef(count).coef = str2double(str_hold(25:36));
            count = count + 1;
        end

        str_hold = fgets(inID);
    end
        
    fclose(inID);

    %save spectra to mat file and exit
    save([filename(1:end-4) '_lin_coef'],'coef');
    return
end
