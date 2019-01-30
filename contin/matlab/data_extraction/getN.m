function N = getN(filename)
%Luis Rangel DaCosta 9/26/18
%Scans metadata txt file for NY
    fID = fopen(filename);
    str_hold = fgets(fID);
    while(str_hold~=-1)
        if(contains(str_hold,'NY ','IgnoreCase',true))
            N = str2num(str_hold(4:end));
            return
        end
        str_hold = fgets(fID);
    end
    N = 0;
end