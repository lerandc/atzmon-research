function getSpectra(filename)
%Luis Rangel DaCosta, 9/14/18
%Grabs solution spectra from CONTIN analysis
%input filename is a string

    %open filestream to CONTIN output and read first line
    inID = fopen(filename);
    str_hold = fgets(inID);

    %output variable that is saved
    spectra = struct();

    %continually read lines from output until end of file is reached

    count = 0; %count of spectra for writing to struct
    while(str_hold ~= -1)
    
        %grab the number of tau grid points in the spectra from control variable NG
        if contains(str_hold,'NG     = ','IgnoreCase',true)
            k = strfind(str_hold, 'NG     = ');
            str_hold(k:k+length('NG     = ')-1) = [];
            num_points = str2num(str_hold);
        end
        
        %look for beginning of data for a solution spectrum
        if contains(str_hold,'ALPHA    ALPHA/S(1)','IgnoreCase', true)

            %open temp scratch file to store statistics for a solution
            scratch_1 = fopen('tempfile.txt','w');

            %clean strings with statistics data, to be read as table
            clean_string = cleanStatString(str_hold);
            fprintf(scratch_1,strcat(clean_string,'\n'));
            str_hold = fgets(inID);

            clean_string = cleanStatNumberString(str_hold);
            fprintf(scratch_1,strcat(clean_string,'\n'));
            fclose(scratch_1);
            
            str_hold = fgets(inID);
            str_hold = fgets(inID); %this is on purpose

            %open temp scratch file to hold actual spectrum as CSV
            scratch_2 = fopen('tempfile2.txt','w');
            fprintf(scratch_2,strcat(str_hold,'\n'));

            %write data to scratch file
            for i = 1:num_points
                str_hold = fgets(inID);
                fprintf(scratch_2,strcat(str_hold(1:31),'\n'));
            end
            
            fclose(scratch_2);
            
            %read data from scratch files back into matlab variables and delete
            M = readtable('tempfile.txt');
            N = readtable('tempfile2.txt');
            count = count+1;

            %add new data to spectra struct
            spectra(count).Stats = M;
            spectra(count).Data = N;
            delete tempfile.txt tempfile2.txt
            
        end

        str_hold = fgets(inID);
    end
        
    fclose(inID);

    %save spectra to mat file and exit
    save([filename(1:end-4) '_spectra'],'spectra');
    return
end


function [cleaned] = cleanStatString(dirty)
%clean string from CONTIN output that contains statistic labels from solution

    %condense multiword labels
    lose = strfind(dirty,'TO REJECT');
    dirty(lose(2):lose(2)+length('TO REJECT')-1) = [];
    dirty(lose(1):lose(1)+length('TO REJECT')-1) = [];
    dirty = strrep(dirty,'DEG FREEDOM', 'DEGFREEDOM');
    dirty = strrep(dirty,'OBJ. FCT', 'OBJ.FCT');
    dirty = strrep(dirty,'STD. DEV', 'STD.DEV');

    %remove whitespace
    reduce  = strfind(dirty,'  ');
    while any(reduce)
        dirty(reduce(1)) = [];
        reduce = strfind(dirty,'  ');
    end
    
    cleaned = dirty;
end

function [cleaned] = cleanStatNumberString(dirty)
%clean string from CONTIN output that contains statistic values from solution

    %remove beginning asterisk
    dirty(dirty == '*') = [];

    %remove whitespace
    reduce  = strfind(dirty,'  ');
    while any(reduce)
        dirty(reduce(1)) = [];
        reduce = strfind(dirty,'  ');
    end

    cleaned = dirty;
end