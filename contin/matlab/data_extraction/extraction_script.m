function extraction_script(target_folder,orig_data_folder,t_min,t_max)
%Luis Rangel DaCosta 9/26/18
%Host script for taking an output file from CONTIN
%and running processing/extraction schemes on
%usage is target folder for extraction (pwd if want to use current directory) as string
%t_min and t_max are times in seconds for plotting the extended fit line

    target_folder = [target_folder '\'];
    orig_data_folder = [orig_data_folder '\'];
    out_files = dir([target_folder '*.out']);

    for name = {out_files.name}
        fname = name{1};
        getMetadata([target_folder fname]);
        getSpectra([target_folder fname]);
        getLinCoef([target_folder fname]);

        N = getN([target_folder fname(1:end-4) '_metadata.txt']);

        orig_data = csvread([orig_data_folder name{1}(1:23) '.csv']);
        orig_data(:,2) = 1-orig_data(:,2);

        getFits([target_folder fname],N);
        fits = load([target_folder fname(1:end-4) '_fits.mat']);
        N_fits = length(fits.fits);
        R2_vec = zeros(N_fits,1);
        for i = 1:N_fits
            R2_vec(i) = getR2(orig_data(:,2),fits.fits(i).Data.ORDINATE);
        end
        wait = 1;
    end


end