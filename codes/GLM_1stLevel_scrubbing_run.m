%% GLM_1stLevel_all
% This GLM_1stLevel_all.m script applies GLM 1st Level t-test contrast analysis
% to each subject's 6 runs and save the results in SPM.mat and other files
% in the 'Data_Folder/S*/jobs/' directory.
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
Regressors_Folder = [Directory 'glm_preparation/regressors/spm/'];

% Subject ID
%ID={'1','2','3','5','6','7','8','9','11','12','14','15','16','17','18','20'};
ID={'3','5','6','7','8','9','11','12','14','15','16','17','18','20'};

for i=1:length(ID)
    for r = 1:6
        % Create new directory '/jobs' to contain analysis results for each subject
        if ~exist([Data_Folder 'S' ID{i} '/run' num2str(r) '_scrubbing'],'dir')
            mkdir([Data_Folder 'S' ID{i} '/run' num2str(r) '_scrubbing'])
        end

        % Display the subject ID
        disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
        disp(['Analyzing data...','S' ID{i} '  run',num2str(r)]);
        disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');

        % Create batch for each subject
        matlabbatch = GLM_1stLevel_run(ID{i}, r, Data_Folder, Conditions_Folder, Regressors_Folder);

        % Save and Run matlab batch
        save([Data_Folder 'S' ID{i} '/run' num2str(r) '_scrubbing/' 'GLM_1stLevel_batch.mat'],'matlabbatch');
        spm_jobman('run', matlabbatch)
    end
end


function matlabbatch = GLM_1stLevel_run(ID, r, Data_Folder, Conditions_Folder, Regressors_Folder)

% Output Directory
matlabbatch{1}.spm.stats.fmri_spec.dir = {[Data_Folder 'S' ID '/run' num2str(r) '_scrubbing']};

% Model Specification
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2.5;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;

% load data for 6 runs of each subject

% Load 250 scans of each run as a session
scans_expand = spm_select('expand', [Data_Folder 'S' ID '/run' num2str(r) '/filtered_func_data_inMNI.nii']);
matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = cellstr(scans_expand);

% Load conditions(onsets & durations) and regressors of no interest
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = {[Conditions_Folder 'S' ID '_run' num2str(r) '.mat']};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = {[Regressors_Folder 'regressors_S' ID '_run' num2str(r) '.mat']};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 128;


% Derivatives: time
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [1 0];

matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

% Model Estimation
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

% Inference (classical t-test)
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Sim_1 > Con_1';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [0 0 0 0 0 0 1 0 1 0 -1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

matlabbatch{3}.spm.stats.con.consess{2}.fcon.name = 'Movement-related effect';
matlabbatch{3}.spm.stats.con.consess{2}.fcon.weights = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1];
matlabbatch{3}.spm.stats.con.consess{2}.fcon.sessrep = 'none';

matlabbatch{3}.spm.stats.con.delete = 1;

end

