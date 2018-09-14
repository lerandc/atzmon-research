 function getFits(filename,N)
    inID = fopen(filename);
    place_holder = fgets(inID);

    fits = struct();
    count = 0;
    while(place_holder ~= -1)
        
        if contains(place_holder,'0PLOT OF DATA (O) AND FIT TO DATA (X).','IgnoreCase', true)
           place_holder = fgets(inID);
           
           fID3 = fopen('tempfile.txt','w');
           place_holder = fgets(inID);
           fprintf(fID3,strcat(place_holder,'\n'));
           
           for i = 1:N
               place_holder = fgets(inID);
               fprintf(fID3,strcat(place_holder(1:22),'\n'));
           end
           
           fclose(fID3);
           
           M = readtable('tempfile.txt');
           count = count+1;
           fits(count).Data = M;
           delete tempfile.txt
        end
        
        place_holder = fgets(inID);
    end

    fclose(inID);
    save([filename(1:end-4) '_fits'],'fits');
end