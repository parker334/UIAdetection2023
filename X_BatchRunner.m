function batch_results = X_BatchRunner(start_index,batch_size)
% Initialize results
batch_results = zeros(batch_size,1);

% Get image files name from specified folder
image_folder = 'F:\images';
names = dir(image_folder);
names = names(3:end);

% As seen as FileLoadExample
for i = 1:batch_size
    names(start_index+(i-1)).name
    fileloc = strcat(image_folder,'\',names(start_index+(i-1)).name);
    %fileloc = strcat(pwd,'\',image_folder,'\',names(start_index+(i-1)).name);
    DICOMnum = [];                      %Set DICOMnum to null if not a DICOM stack
    INFO.PixelSpacing = [0.51; 0.51] ;  %[0.51; 0.51] MIDAS; [0.47; 0.47] IMPERIAL
    INFO.SliceThickness = 0.8;          %0.8 MIDAS; 0.8 IMPERIAL
    INFO.ContentDate = '';              %2010 MIDAS;  2007 (IMPERIAL);
    INFO.StudyDescription = '';         %MIDAS Healthy; Imperial Healthy
    INFO.Modality = 'MR';               %MR; DSA; CTA
    [anom_list, data_subpl,fitresult,time2run,outlierProps,KwPredictor,MaskVol,PathLength] = PipelineAlgorithm(fileloc,DICOMnum,INFO);
    anom_list
    if size(anom_list) ~= 0
        batch_results(i) = anom_list;
    end
end