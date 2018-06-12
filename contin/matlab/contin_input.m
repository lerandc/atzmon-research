%Script for generating contin input files from CSVs
files = dir('*.csv');

for j = 1:length(files)
        name = files(j).name;
        
        %grabs csv input with time in first column and strain in second column
        M = csvread(name);

        x = M(:,1);
        y = M(:,2);
        [x, order] = sort(x);
        y = y(order);
        %creates the file
        fileID = fopen(strcat(name(1:end-4),'-con-input.in'),'w');

        %begins writing to file
        fprintf(fileID,'%s %13s\n','',name);
        fprintf(fileID,'%s %-22s %3s\n','','LAST','1.');
        fprintf(fileID,'%s %-14s %3.5E \n','','NG',100);
        fprintf(fileID,'%s %-23s %s \n','','IQUAD','2.');

        %quadrature grid 
            t1 = 1e-3;
            t2= 1e3;
        fprintf(fileID,'%s %-9s %-4s %#.5E\n','','GMNMX','1',t1);
        fprintf(fileID,'%s %-9s %-4s %#.5E\n','','GMNMX','2',t2);

        %%%%%%options

        fprintf(fileID,'%s %-22s %3s\n','','IWT',' 1.');
        fprintf(fileID,'%s %-22s %3s\n','','NERFIT',' 0.');
        fprintf(fileID,'%s %-22s %3s\n','','NINTT',' 0.');
        fprintf(fileID,'%s %-22s %3s\n','','NLINF',' 1.');
        fprintf(fileID,'%s\n %s\n',' IFORMT','(1E11.4)');
        fprintf(fileID,'%s\n %s\n',' IFORMY','(1E11.4)');
        %fprintf(fileID,'%s %-22s %3s\n','','DOUSNQ',' 1.');
        fprintf(fileID,'%s %-22s %3s\n','','NONNEG',' 1.');
        fprintf(fileID,'%s %-22s %3s\n','','IGRID',' 2.');
        fprintf(fileID,'%s %-9s %-4s %#.5E\n','','IUSER','2',0);

        %user paramters would go here
        fprintf(fileID,'%s\n',' END');


        %begin card sets 4-15

        %using NSTEND%
        %     n1 = 10; n1_1 = 5e-6; n1_2 = 85e-6;
        %     n2 = 9; n2_1 = 95e-6; n2_2 = 245e-6;
        %     n3 = 8; n3_1 = 265e-6; n3_2 = 325e-6;
        % fprintf(fileID,'%s %-8s %2d %#14.2E %#15.2E\n','','NSTEND',n1,n1_1,n1_2);
        % fprintf(fileID,'%s %-8s %2d %#14.2E %#15.2E\n','','NSTEND',n2,n2_1,n2_2);
        % fprintf(fileID,'%s %-8s %2d %#14.2E %#15.2E\n','','NSTEND',n3,n3_1,n3_2);
        %%%%%%%%%%%%%%

        %using custom points

        fprintf(fileID,'%-6s %d \n',' NY',length(x));

        for i = 1:length(x)
            fprintf(fileID,'%#11.4E \n',x(i));
        end

        for i = 1:length(y)
            fprintf(fileID,'%#11.4E \n',y(i));
        end

        %closes file
        fclose(fileID);
end