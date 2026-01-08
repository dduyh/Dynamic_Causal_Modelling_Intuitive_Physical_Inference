%% GLM_Concatenation_scrubbing
% This GLM_Concatenation_scrubbing.m script applies GLM 1st Level t-test contrast and f-test
% analysis to each subject's concatenated 6 runs and save the results in SPM.mat
% and other files in the 'Data_Folder/S*/jobs_DCM_scrubbing/' directory.
%
% Authors with email:
% Yihui Du, yihudu@student.ethz.ch
%-----------------------------------------------------------------------

%%

clear all;

%% 

Directory = '/Volumes/My_Passport/ETH_Zurich/Semester_Project/';    % Main directory

% Folder path of preprocessed data
Data_Folder = [Directory 'preprocesssed_data/'];

% Folder path of conditions data in .mat files
Conditions_Folder = [Directory 'glm_preparation/timing_files/spm/'];

% Folder path of regressors of no interest in .mat files
Regressors_Folder = [Directory 'glm_preparation/regressors/spm/'];

% Subject ID
ID={'1','2','3','5','6','7','8','9','11','12','14','15','16','17','18','20'};
%ID={'5','8'};

for i=1:length(ID)
    % Create new directory '/jobs_DCM_scrubbing' to contain analysis results for each subject
    if ~exist([Data_Folder 'S' ID{i} '/jobs_DCM_scrubbing'],'dir')
        mkdir([Data_Folder 'S' ID{i} '/jobs_DCM_scrubbing'])
    end

    % Display the subject ID
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    disp(['Analyzing data...',num2str(i),'/',num2str(length(ID))]);
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');

    % Create batch for each subject
    matlabbatch = GLM_specify(ID{i}, Data_Folder, Conditions_Folder, Regressors_Folder);

    % Save and Run matlab specify batch
    save([Data_Folder 'S' ID{i} '/jobs_DCM_scrubbing/' 'GLM_specify_batch.mat'],'matlabbatch');
    spm_jobman('run', matlabbatch)
    clear matlabbatch

    % By-session adjustment for the GLM block effect
    if ID{i} == '5' | ID{i} == '8'
        scans = [250 250 250 250 250];
    else
        scans = [250 250 250 250 250 250];
    end

    spm_fmri_concatenate([Data_Folder 'S' ID{i} '/jobs_DCM_scrubbing/' 'SPM.mat'], scans);

    % Save and Run matlab estimate batch
    matlabbatch = GLM_estimate(ID{i}, Data_Folder);
    save([Data_Folder 'S' ID{i} '/jobs_DCM_scrubbing/' 'GLM_estimate_batch.mat'],'matlabbatch');
    spm_jobman('run', matlabbatch)
    clear matlabbatch

    % Save and Run matlab contrast batch
    matlabbatch = GLM_contrast(ID{i}, Data_Folder);
    save([Data_Folder 'S' ID{i} '/jobs_DCM_scrubbing/' 'GLM_contrast_batch.mat'],'matlabbatch');
    spm_jobman('run', matlabbatch)
    clear matlabbatch

end


%%  Model Specification function
function matlabbatch = GLM_specify(ID, Data_Folder, Conditions_Folder, Regressors_Folder)

% Output Directory
matlabbatch{1}.spm.stats.fmri_spec.dir = {[Data_Folder 'S' ID '/jobs_DCM_scrubbing']};

matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2.5;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;

% load data for 5 or 6 runs of each subject
scans_expand = [];

if ID == '5' | ID == '8'
    nrRuns = 5;
else
    nrRuns = 6;
end

for r=1:nrRuns
    % Load 250*nrRuns scans of 5 or 6 runs as a session
    scans_expand = [scans_expand; spm_select('expand', [Data_Folder 'S' ID '/run' num2str(r) '/filtered_func_data_inMNI.nii'])];
end

matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = cellstr(scans_expand);

% Load conditions(onsets & durations) and regressors of no interest
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = {[Conditions_Folder 'S' ID '_Concatenation_merge.mat']};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = {[Regressors_Folder 'regressors_S' ID '_Concatenation.mat']};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 100;


% Derivatives: time
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [1 0];

matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

end

%% Model Estimation function
function matlabbatch = GLM_estimate(ID, Data_Folder)

matlabbatch{1}.spm.stats.fmri_est.spmmat = {[Data_Folder 'S' ID '/jobs_DCM_scrubbing/' 'SPM.mat']};
matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;

end

%% Inference function
function matlabbatch = GLM_contrast(ID, Data_Folder)

matlabbatch{1}.spm.stats.con.spmmat = {[Data_Folder 'S' ID '/jobs_DCM_scrubbing/' 'SPM.mat']};
% Contrast Sim_1 > Con_1 (classical t-test)
matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Sim_1 > Con_1';
matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = [0 0 0 0 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';


% Effects of interest (classical F-test)
matlabbatch{1}.spm.stats.con.consess{2}.fcon.name = 'Effects of interest';
matlabbatch{1}.spm.stats.con.consess{2}.fcon.weights = [0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
matlabbatch{1}.spm.stats.con.consess{2}.fcon.sessrep = 'none';


matlabbatch{1}.spm.stats.con.delete = 1;

end


