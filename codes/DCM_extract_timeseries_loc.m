%% DCM_extract_timeseries_loc
% extract the eigenvalues of ROIs for DCM
% VOI based on an 8mm sphere which jumps to the peak for each subject,
% within a 16mm sphere centered on a group "peak"
%
% Authors with email:
% Yihui Du, yihudu@student.ethz.ch
%-----------------------------------------------------------------------

clc;
clear all;
close all;

% select the subject to analyze
subjectID = {'1','2','3','5','6','7','8','9','11','12','14','15','16','17','18','20'};
%subjectID = {'8','16','18'};

nrSubjects = length(subjectID); % subjects number

% specify SPM.mat and timeseries saving folders 
data_folder = '/Volumes/My_Passport/ETH_Zurich/Semester_Project/preprocesssed_data/';
timeseries_folder = '/Volumes/My_Passport/ETH_Zurich/Semester_Project/DCM_loc/';

% iterate over all subjects
for i=1:nrSubjects

    % Create batch for each subject, select ROI
    % Save and Run batch

    % extract timeseries for V1/2 VOI
    matlabbatch = extract_VOI_vis(subjectID{i}, data_folder);
    save([data_folder 'S' subjectID{i} '/jobs_loc/' 'extract_VOI_vis_batch.mat'],'matlabbatch');
    spm_jobman('run', matlabbatch)
    clear matlabbatch

    % extract timeseries for SPL VOI
    matlabbatch = extract_VOI_SPL(subjectID{i}, data_folder);
    save([data_folder 'S' subjectID{i} '/jobs_loc/' 'extract_VOI_SPL_batch.mat'],'matlabbatch');
    spm_jobman('run', matlabbatch)
    clear matlabbatch

    % extract timeseries for SMG VOI
    matlabbatch = extract_VOI_SMG(subjectID{i}, data_folder);
    save([data_folder 'S' subjectID{i} '/jobs_loc/' 'extract_VOI_SMG_batch.mat'],'matlabbatch');
    spm_jobman('run', matlabbatch)
    clear matlabbatch

    % move the extracted time series to the results folder
    movefile([data_folder 'S' subjectID{i} '/jobs_loc/' 'VOI*.mat'],[timeseries_folder 'S' subjectID{i}])

end

% - - visual ROI - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function matlabbatch = extract_VOI_vis(ID, data_folder)

% Insert the subject's SPM .mat filename here
spm_mat_file = {[data_folder 'S' ID '/jobs_loc/' 'SPM.mat']};

% Start batch
matlabbatch{1}.spm.util.voi.spmmat  = cellstr(spm_mat_file);
matlabbatch{1}.spm.util.voi.adjust  = 2; % Effects of interest contrast number (F contrast is the 2nd)
matlabbatch{1}.spm.util.voi.session = 1; % Session index
matlabbatch{1}.spm.util.voi.name    = 'vis'; % VOI name

% Define thresholded SPM for finding the subject's local peak response (i1)
matlabbatch{1}.spm.util.voi.roi{1}.spm.spmmat      = {''};
matlabbatch{1}.spm.util.voi.roi{1}.spm.contrast    = 1; % Index of contrast for choosing voxels
matlabbatch{1}.spm.util.voi.roi{1}.spm.conjunction = 1; % only single contrast is used
matlabbatch{1}.spm.util.voi.roi{1}.spm.threshdesc  = 'none';
if ID == '8' | ID == '16' | ID == '18'
    threshold = 0.2;
else
    threshold = 0.05;
end
matlabbatch{1}.spm.util.voi.roi{1}.spm.thresh      = threshold; % default 0.001
matlabbatch{1}.spm.util.voi.roi{1}.spm.extent      = 0;
matlabbatch{1}.spm.util.voi.roi{1}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});

% Define large fixed outer sphere (i2)
matlabbatch{1}.spm.util.voi.roi{2}.sphere.centre     = [9 -88 -14]; % Set coordinates here
matlabbatch{1}.spm.util.voi.roi{2}.sphere.radius     = 16; % Radius outer sphere (mm)
matlabbatch{1}.spm.util.voi.roi{2}.sphere.move.fixed = 1;

% Define smaller inner sphere which jumps to the peak of the outer sphere (i3)
matlabbatch{1}.spm.util.voi.roi{3}.sphere.centre           = [9 -88 -14]; % Leave this at outer center
matlabbatch{1}.spm.util.voi.roi{3}.sphere.radius           = 8; % Radius inner sphere here (mm)
matlabbatch{1}.spm.util.voi.roi{3}.sphere.move.global.spm  = 1; % Index of SPM within the batch
matlabbatch{1}.spm.util.voi.roi{3}.sphere.move.global.mask = 'i2'; % Index of the outer sphere within the batch

% Include voxels in the thresholded SPM (i1) and the mobile inner sphere (i3)
matlabbatch{1}.spm.util.voi.expression = 'i1 & i3';

%clear matlabbatch;
end


% - - SPL ROI - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function matlabbatch = extract_VOI_SPL(ID, data_folder)

% Insert the subject's SPM .mat filename here
spm_mat_file = {[data_folder 'S' ID '/jobs_loc/' 'SPM.mat']};

% Start batch
matlabbatch{1}.spm.util.voi.spmmat  = cellstr(spm_mat_file);
matlabbatch{1}.spm.util.voi.adjust  = 2; % Effects of interest contrast number (F contrast is the 2nd)
matlabbatch{1}.spm.util.voi.session = 1; % Session index
matlabbatch{1}.spm.util.voi.name    = 'SPL'; % VOI name

% Define thresholded SPM for finding the subject's local peak response (i1)
matlabbatch{1}.spm.util.voi.roi{1}.spm.spmmat      = {''};
matlabbatch{1}.spm.util.voi.roi{1}.spm.contrast    = 1; % Index of contrast for choosing voxels
matlabbatch{1}.spm.util.voi.roi{1}.spm.conjunction = 1;
matlabbatch{1}.spm.util.voi.roi{1}.spm.threshdesc  = 'none';
matlabbatch{1}.spm.util.voi.roi{1}.spm.thresh      = 0.05; % default 0.001
matlabbatch{1}.spm.util.voi.roi{1}.spm.extent      = 0;
matlabbatch{1}.spm.util.voi.roi{1}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});

% Define large fixed outer sphere (i2)
matlabbatch{1}.spm.util.voi.roi{2}.sphere.centre     = [12 -66 56]; % Set coordinates here
matlabbatch{1}.spm.util.voi.roi{2}.sphere.radius     = 16; % Radius outer sphere (mm)
matlabbatch{1}.spm.util.voi.roi{2}.sphere.move.fixed = 1;

% Define smaller inner sphere which jumps to the peak of the outer sphere (i3)
matlabbatch{1}.spm.util.voi.roi{3}.sphere.centre           = [12 -66 56]; % Leave this at outer center
matlabbatch{1}.spm.util.voi.roi{3}.sphere.radius           = 8; % Radius inner sphere here (mm)
matlabbatch{1}.spm.util.voi.roi{3}.sphere.move.global.spm  = 1; % Index of SPM within the batch
matlabbatch{1}.spm.util.voi.roi{3}.sphere.move.global.mask = 'i2'; % Index of the outer sphere within the batch

% Include voxels in the thresholded SPM (i1) and the mobile inner sphere (i3)
matlabbatch{1}.spm.util.voi.expression = 'i1 & i3';

end

% - - SMG ROI - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function matlabbatch = extract_VOI_SMG(ID, data_folder)

% Insert the subject's SPM .mat filename here
spm_mat_file = {[data_folder 'S' ID '/jobs_loc/' 'SPM.mat']};

% Start batch
matlabbatch{1}.spm.util.voi.spmmat  = cellstr(spm_mat_file);
matlabbatch{1}.spm.util.voi.adjust  = 2; % Effects of interest contrast number (F contrast is the 2nd)
matlabbatch{1}.spm.util.voi.session = 1; % Session index
matlabbatch{1}.spm.util.voi.name    = 'SMG'; % VOI name

% Define thresholded SPM for finding the subject's local peak response (i1)
matlabbatch{1}.spm.util.voi.roi{1}.spm.spmmat      = {''};
matlabbatch{1}.spm.util.voi.roi{1}.spm.contrast    = 1; % Index of contrast for choosing voxels
matlabbatch{1}.spm.util.voi.roi{1}.spm.conjunction = 1;
matlabbatch{1}.spm.util.voi.roi{1}.spm.threshdesc  = 'none';
matlabbatch{1}.spm.util.voi.roi{1}.spm.thresh      = 0.05; % default 0.001
matlabbatch{1}.spm.util.voi.roi{1}.spm.extent      = 0;
matlabbatch{1}.spm.util.voi.roi{1}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});

% Define large fixed outer sphere (i2)
matlabbatch{1}.spm.util.voi.roi{2}.sphere.centre     = [40 -42 42]; % Set coordinates here
matlabbatch{1}.spm.util.voi.roi{2}.sphere.radius     = 16; % Radius outer sphere (mm)
matlabbatch{1}.spm.util.voi.roi{2}.sphere.move.fixed = 1;

% Define smaller inner sphere which jumps to the peak of the outer sphere (i3)
matlabbatch{1}.spm.util.voi.roi{3}.sphere.centre           = [40 -42 42]; % Leave this at outer center
matlabbatch{1}.spm.util.voi.roi{3}.sphere.radius           = 8; % Radius inner sphere here (mm)
matlabbatch{1}.spm.util.voi.roi{3}.sphere.move.global.spm  = 1; % Index of SPM within the batch
matlabbatch{1}.spm.util.voi.roi{3}.sphere.move.global.mask = 'i2'; % Index of the outer sphere within the batch

% Include voxels in the thresholded SPM (i1) and the mobile inner sphere (i3)
matlabbatch{1}.spm.util.voi.expression = 'i1 & i3';

end
