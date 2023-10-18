function [names_list, batch_results, batch_num_results, batch_info_results, rec_times, data_subpl_list, fitresult_list, outlierProps_list, KwPredictor_list, MaskVol_list, PathLength_list] = X_BatchRunner(start_index,batch_size)
% Initialize results
names_list = strings(batch_size,1);
batch_results = zeros(batch_size,1);
batch_num_results = zeros(batch_size,1);
batch_info_results = cell(batch_size,1);
rec_times = zeros(batch_size,1);

data_subpl_list = cell(batch_size,1);
fitresult_list = cell(batch_size,1);
outlierProps_list = cell(batch_size,1);
KwPredictor_list = zeros(batch_size,1);
MaskVol_list = zeros(batch_size,1);
PathLength_list = zeros(batch_size,1);

% Get image files name from specified folder
image_folder = 'D:\images';
names = dir(image_folder);
names = names(3:end);

% As seen as FileLoadExample
for i = 1:batch_size
    is_error = 0;
    names_list(i) = names(start_index+(i-1)).name
    fileloc = strcat(image_folder,'\',names(start_index+(i-1)).name);
    %fileloc = strcat(pwd,'\',image_folder,'\',names(start_index+(i-1)).name);
    DICOMnum = [];                      %Set DICOMnum to null if not a DICOM stack
    INFO.PixelSpacing = [0.51; 0.51] ;  %[0.51; 0.51] MIDAS; [0.47; 0.47] IMPERIAL
    INFO.SliceThickness = 0.8;          %0.8 MIDAS; 0.8 IMPERIAL
    INFO.ContentDate = '';              %2010 MIDAS;  2007 (IMPERIAL);
    INFO.StudyDescription = '';         %MIDAS Healthy; Imperial Healthy
    INFO.Modality = 'MR';               %MR; DSA; CTA
    
    kT = 0.3134*mean(INFO.PixelSpacing')^-1.522;
        %We've assessed 3 kT weight parameters in our paper:
    %1.78 for constant relationship
    %0.6709*mean(INFO.PixelSpacing')^-0.839 for 1.20 intercept at 0.51
    %0.3134*mean(INFO.PixelSpacing')^-1.522 for 0.9 intercept at 0.51
    %0.1296*mean(INFO.PixelSpacing')^-2.222 for 0.6 intercept at 0.51
    
    try
        [anom_list, data_subpl,fitresult,time2run,outlierProps,KwPredictor,MaskVol,PathLength] = X_PipelineAlgorithm(fileloc,DICOMnum,INFO,names_list(i),kT);
        rec_times(i) = time2run;
    catch
        is_error = 1;
    end
    if is_error == 1
        batch_num_results(i) = -1;
        continue
    end
    data_subpl_list(i) = {data_subpl};
    fitresult_list(i) = {fitresult};
    outlierProps_list(i) = outlierProps;
    KwPredictor_list(i) = KwPredictor;
    MaskVol_list(i) = MaskVol;
    PathLength_list(i) = PathLength;
    anom_list
    if size(anom_list) ~= 0
        batch_results(i) = 1;
        batch_num_results(i) = size(anom_list,1);
        batch_info_results(i) = {anom_list};
    end
end
batch_info_results