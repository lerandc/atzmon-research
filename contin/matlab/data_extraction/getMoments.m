function getMoments(filename)
%Luis Rangel DaCosta, 9/19/18
%Grabs moments of solutions from CONTIN Analysis
%takes in file name


    %open filestream to CONTIN output and read first line
    inID = fopen(filename);
    str_hold = fgets(inID);

    %continually read lines from output until end of file is reached
    moments = struct();
    current_solution = 1;
    while(str_hold~=-1)
        current_peak = 1;
        %look for beginning of moments for a solution spectrum
        if contains(str_hold,'0PEAK','IgnoreCase', true)
            for i = 1:5
                str_hold = fgets(inID);
                J = str_hold(1:47);
                moment = str_hold(50:70); moment(9) = '*'; moment(14) = '^'; moment(15) = [];
                moment_error = str_hold(71:87);
                if length(str_hold) > 90
                    moment_divide = str_hold(90:110);
                    moment_divide_error = str_hold(111:123);
                else
                    moment_divide = NaN;
                    moment_divide_error = NaN;
                end
               moments = updateOutput(moments,J,moment,moment_divide,...
                    moment_error,moment_divide_error,current_solution,current_peak);
               wait = 1;
               current_peak = current_peak + 1;
            end
        end
            
        if contains(str_hold,'MOMENTS OF ENTIRE SOLUTION','IgnoreCase', true)
            for i = 1:5
                str_hold = fgets(inID);
                J = str_hold(1:47);
                moment = str_hold(50:70); moment(9) = '*'; moment(14) = '^'; moment(15) = [];
                moment_error = str_hold(71:87);
                if length(str_hold) > 90
                    moment_divide = str_hold(90:110);
                    moment_divide_error = str_hold(111:123);
                else
                    moment_divide = NaN;
                    moment_divide_error = NaN;
                end
            end
            moments = updateOutput(moments,J,moment,moment_divide,...
                moment_error,moment_divide_error,current_solution,current_peak);
            current_solution = current_solution + 1;
        end

        str_hold = fgets(inID);
    end

end


function [output_struct] = updateOutput(input_struct,J,m,m_d,me,m_de,solutionID,peakID)
    output_struct = input_struct;
    if J(end) == '2'
        std_dev_by_mean = J(34:43);
        output_struct(solutionID).std_dev_by_mean = std_dev_by_mean;
    end
    
    J = str2num(J(end-3:end));
    moment = str2num(m);
    
    if ~isnan(m_d)
        moment_divide = str2num(m_d);
    else
        moment_divide = m_d;
    end
    
    if ~isnan(m_d)
        moment_divide_error = str2num(m_de);
    else
        moment_divide_error = m_de;
    end
    moment_error = str2num(me);
    
    if isfield(input_struct,'J')
        output_struct(solutionID).J{peakID} = [output_struct(solutionID).J{peakID}; J];
        output_struct(solutionID).moment = [output_struct(solutionID).moment; moment];
        output_struct(solutionID).moment_divide = [input_struct(solutionID).moment_divide; moment_divide];
        output_struct(solutionID).moment_error = [input_struct(solutionID).moment_error; moment_error];
        output_struct(solutionID).moment_divide_error = [input_struct(solutionID).J; J];
    else
        output_struct(solutionID).J = {[J]};
        output_struct(solutionID).moment = {[moment]};
        output_struct(solutionID).moment_divide = {[moment_divide]};
        output_struct(solutionID).moment_error = {[moment_error]};
        output_struct(solutionID).moment_divide_error = {[moment_divide_error]};
    end

    
end