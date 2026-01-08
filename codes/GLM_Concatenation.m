%% GLM_Concatenation
% This GLM_Concatenation.m script applies GLM 1st Level t-test contrast analysis
% to each subject's 6 runs and save the results in SPM.mat and other files
% in the 'Data_Folder/S*/jobs_DCM/' directory.
%
% Authors with email:
% Yihui Du, yihudu@student.ethz.ch
%-----------------------------------------------------------------------

Directory = '/Volumes/My_Passport/ETH_Zurich/Semester_Project/';    % Main directory

% Folder path of preprocessed data
Data_Folder = [Directory 'preprocesssed_data/'];

% Folder path of conditions data in .mat files
Conditions_Folder = [Directory 'glm_preparation/timing_files/spm/'];

% Folder path of regressors of no interest in .mat files
Regressors_Folder = [Directory 'glm_preparation/regressors_2.0/spm/'];

% Subject ID
%ID={'1','2','3','5','6','7','8','9','11','12','14','15','16','17','18','20'};
ID={'2','3','6','7','9','11','12','14','15','16','17','18','20'};

for i=1:length(ID)
    % Create new directory '/jobs_DCM' to contain analysis results for each subject
    if ~exist([Data_Folder 'S' ID{i} '/jobs_DCM'],'dir')
        mkdir([Data_Folder 'S' ID{i} '/jobs_DCM'])
    end

    % Display the subject ID
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    disp(['Analyzing data...',num2str(i),'/',num2str(length(ID))]);
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');

    % Create batch for each subject
    matlabbatch = GLM_specify(ID{i}, Data_Folder, Conditions_Folder, Regressors_Folder);

    % Save and Run matlab batch
    save([Data_Folder 'S' ID{i} '/jobs_DCM/' 'GLM_specify_batch.mat'],'matlabbatch');
    spm_jobman('run', matlabbatch)
    clear matlabbatch

    scans = [250 250 250 250 250 250];
    spm_fmri_concatenate([Data_Folder 'S' ID{i} '/jobs_DCM/' 'SPM.mat'], scans);

    matlabbatch = GLM_estimate(ID{i}, Data_Folder);
    save([Data_Folder 'S' ID{i} '/jobs_DCM/' 'GLM_estimate_batch.mat'],'matlabbatch');
    spm_jobman('run', matlabbatch)
    clear matlabbatch

    matlabbatch = GLM_contrast(ID{i}, Data_Folder);
    save([Data_Folder 'S' ID{i} '/jobs_DCM/' 'GLM_contrast_batch.mat'],'matlabbatch');
    spm_jobman('run', matlabbatch)
    clear matlabbatch

end


function matlabbatch = GLM_specify(ID, Data_Folder, Conditions_Folder, Regressors_Folder)

% Output Directory
matlabbatch{1}.spm.stats.fmri_spec.dir = {[Data_Folder 'S' ID '/jobs_DCM']};

% Model Specification
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2.5;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;

% load data for 6 runs of each subject
scans_expand = [];

for r = 1:6
    % Load 250*6 scans of 6 runs as a session
    scans_expand = [scans_expand; spm_select('expand', [Data_Folder 'S' ID '/run' num2str(r) '/filtered_func_data_inMNI.nii'])];
    
end

matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = cellstr(scans_expand);

% Load conditions(onsets & durations) and regressors of no interest
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = {[Conditions_Folder 'S' ID '_Concatenation.mat']};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = {[Regressors_Folder 'regressors_S' ID '_Concatenation.mat']};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 128;


% Derivatives: time
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [1 0];

matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

end


function matlabbatch = GLM_estimate(ID, Data_Folder)

% Model Estimation
matlabbatch{1}.spm.stats.fmri_est.spmmat = {[Data_Folder 'S' ID '/jobs_DCM/' 'SPM.mat']};
matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;

end


function matlabbatch = GLM_contrast(ID, Data_Folder)

% Inference
matlabbatch{1}.spm.stats.con.spmmat = {[Data_Folder 'S' ID '/jobs_DCM/' 'SPM.mat']};
% Contrast Sim_1 > Con_1 (classical t-test)
matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Sim_1 > Con_1';
matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = [0 0 0 0 0 0 1 0 1 0 -1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

% Contrast Sim_1 > Con_1 (classical t-test)
matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'Simulation';
matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = [0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

% Contrast Sim_1 > Con_1 (classical t-test)
matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'Control';
matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = [0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';


% Contrast Movement-related effect (classical F-test)
matlabbatch{1}.spm.stats.con.consess{4}.fcon.name = 'Effects of interest';
matlabbatch{1}.spm.stats.con.consess{4}.fcon.weights = [0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
matlabbatch{1}.spm.stats.con.consess{4}.fcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.delete = 1;

end


