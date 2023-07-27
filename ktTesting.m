function acc_results = ktTesting(start_index,batch_size)
% Initialize results
batch_results = zeros(batch_size,1);

% Get image files name from specified folder
image_folder = 'images';
names = dir(image_folder);
names = names(3:end);

coeffs = 0.2:0.1:0.4;
powers = -0.2:-0.4:-3;

coeff_size = size(coeffs);
acc_results = zeros(coeff_size(2),1);
j = 1;

% As seen as FileLoadExample
for coeff = coeffs
    for i = 1:batch_size
        names(start_index+(i-1)).name
        fileloc = strcat(pwd,'\',image_folder,'\',names(start_index+(i-1)).name);
        DICOMnum = [];                      %Set DICOMnum to null if not a DICOM stack
        INFO.PixelSpacing = [0.51; 0.51] ;  %[0.51; 0.51] MIDAS; [0.47; 0.47] IMPERIAL
        INFO.SliceThickness = 0.8;          %0.8 MIDAS; 0.8 IMPERIAL
        INFO.ContentDate = '';              %2010 MIDAS;  2007 (IMPERIAL);
        INFO.StudyDescription = '';         %MIDAS Healthy; Imperial Healthy
        INFO.Modality = 'MR';               %MR; DSA; CTA
        % kT Default
        kT = 0.3134*mean(INFO.PixelSpacing')^-1.522;
        % kT Testing
        %kT = coeff*mean(INFO.PixelSpacing')^powers
        [anom_list, data_subpl,fitresult,time2run,outlierProps,KwPredictor,MaskVol,PathLength] = PipelineAlgorithmVar(fileloc,DICOMnum,INFO,kT);
        anom_list
        if size(anom_list) ~= 0
            batch_results(i) = 1;
        end
    end
    sz_bat = size(batch_results);
    accuracy = sum(batch_results) / sz_bat(2)
    acc_results(j) = accuracy;
    j = j+1;
    batch_results = zeros(batch_size,1);
end 