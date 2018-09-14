function getMetadata(filename)
%Luis Rangel DaCosta, 9/14/18
%Grabs all experimental metadata from output of CONTIN analysis
%and writes to shorter text file for later extracation
%input filename is a string 

    %open CONTIN output and grab first line
    inID = fopen(filename);
    str_hold = fgets(inID);

    %open output file to write metadata to
    out_name = [filename(1:end-4) '_metadata.txt'];
    outID = fopen(out_name,'w');

    %read lines until end of meta data section, then break and close files
    while(str_hold ~= -1)
        fprintf(outID,[str_hold '\n']);
        if contains(str_hold,'0PRECIS = ','IgnoreCase',true)
            break;
        end
        str_hold = fgets(inID);
    end

    %close matlab's access to files
    fclose(inID);
    fclose(outID);

    return
end