%% DCM_1stLevel_loc
% Creates a DCM structure from scratch by assigning the extracted BOLD signal
% time series, as well as specifying the driving inputs and the model structure
% (i.e., A, B, and C matrices). The function then estimates the respective DCM
% using standard routines from SPM.
%
% Authors with email:
% Yihui Du, yihudu@student.ethz.ch
%-----------------------------------------------------------------------

clc;
clear all;
close all;

%% Settings

% MRI scanner settings
TR = 2.5;   % Repetition time (secs) 2.5 secs
TE = 0.035;  % Echo time (secs) 35 ms

% Experiment settings
subjectID = {'1','2','3','5','6','7','8','9','11','12','14','15','16','17','18','20'};
nsubjects   = length(subjectID); % subjects number
nregions    = 3; % regions number
nconditions = 1; % conditions number

% Index of each condition in the DCM
simFall=1;

% Index of each region in the DCM
vis=1; SPL=2; SMG=3;


%% Specify full DCMs (one per subject)

% fully connected A-matrix (on / off)
a = ones(nregions,nregions);

% B-matrix (modulatory inputs)
b(:,:,simFall)     = zeros(nregions); % simFall

% C-matrix (driving inputs)
c = zeros(nregions,nconditions);
c(:,simFall) = 1;

% D-matrix (disabled)
d = zeros(nregions,nregions,0);

Data_Folder = '/Volumes/My_Passport/ETH_Zurich/Semester_Project/DCM_loc/';

% iterate over all subjects
for i = 1:nsubjects

    % Load SPM
    glm_dir = [Data_Folder 'S' subjectID{i} '/']; % SPM.mat and timeseries saving folders 
    SPM     = load([glm_dir 'SPM.mat']); % load SPM.mat file
    SPM     = SPM.SPM;

    % Load VOI files
    f = {[glm_dir 'VOI_vis_1.mat'];
        [glm_dir 'VOI_SPL_1.mat'];
        [glm_dir 'VOI_SMG_1.mat']};
    for r = 1:length(f)
        XY = load(f{r});
        xY(r) = XY.xY;
    end

    % Move to output directory
    cd(glm_dir);

    % Select whether to include each condition from the design matrix
    % names = {'locFall'};
    include = [1]';

    % Specify.
    s = struct();
    s.name       = 'full_driving_inputs';
    s.u          = include;                 % Conditions
    s.delays     = repmat(TR/2,1,nregions);   % Slice timing for each region
    s.TE         = TE;
    s.nonlinear  = false; % bilinear
    s.two_state  = true; % two-state
    s.stochastic = false; % deterministic DCM (not to include stochastic effects)
    s.centre     = false; % not to mean-centre input matrix
    s.induced    = 0; % fit timeseries, not CSD (induced)
    s.a          = a;
    s.b          = b;
    s.c          = c;
    s.d          = d;
    DCM = spm_dcm_specify(SPM,xY,s);

    % spm_dcm_estimate([glm_dir 'DCM_full_driving_inputs.mat']);

    % Return to script directory
    cd(Data_Folder);
end


%% Collate full models into a GCM file and estimate

% Find and select all DCM files
dcms = spm_select('FPListRec',Data_Folder,'DCM_full_driving_inputs.mat');

% Prepare output directory 'analyses'
out_dir = [Data_Folder 'analyses'];
if ~exist(out_dir,'dir')
    mkdir(out_dir);
end

%%
% Check if GCM_full.mat exists
if exist(fullfile(out_dir,'GCM_full_driving_inputs.mat'),'file')
    % if GCM_full.mat exists, ask whether to Overwrite
    opts.Default = 'No';
    opts.Interpreter = 'none';
    f = questdlg('Overwrite existing GCM?','Overwrite?','Yes','No',opts);
    tf = strcmp(f,'Yes');
else
    tf = true;
end

% Collate & estimate
if tf
    % Character array -> cell array
    GCM = cellstr(dcms);

    % Filenames -> DCM structures
    GCM = spm_dcm_load(GCM);

    % Estimate DCMs (this won't effect original DCM files)
    GCM = spm_dcm_fit(GCM);

    % Save estimated GCM
    save([out_dir '/GCM_full_driving_inputs.mat'],'GCM');
end

%% Run diagnostics
load([out_dir '/GCM_full_driving_inputs.mat'],'GCM');
spm_dcm_fmri_check(GCM);


%% Re-estimate with empirical priors

% Check if GCM_full.mat exists
if exist(fullfile(out_dir,'GCM_full_peb_driving_inputs.mat'),'file')
    % if GCM_full.mat exists, ask whether to Overwrite
    opts.Default = 'No';
    opts.Interpreter = 'none';
    f = questdlg('Overwrite existing GCM?','Overwrite?','Yes','No',opts);
    tf = strcmp(f,'Yes');
else
    tf = true;
end

% Collate & estimate
if tf
    % Character array -> cell array
    GCM = cellstr(dcms);

    % Filenames -> DCM structures
    GCM = spm_dcm_load(GCM);

    % Estimate DCMs (this won't effect original DCM files)
    GCM = spm_dcm_peb_fit(GCM);

    % Save estimated GCM
    save([out_dir '/GCM_full_peb_driving_inputs.mat'],'GCM');
end

%% Run diagnostics
load([out_dir '/GCM_full_peb_driving_inputs.mat'],'GCM');
spm_dcm_fmri_check(GCM);
