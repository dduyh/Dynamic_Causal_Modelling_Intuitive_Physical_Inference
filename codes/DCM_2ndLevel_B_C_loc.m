%% DCM_2ndLevel
% Step1: Specify and Estimate a second level PEB (Parametric Empirical Bayes) model
% Step2: Compare the full PEB model to nested PEB models to test specific hypotheses
% Step3: Search over nested PEB models.
%
% Authors with email:
% Yihui Du, yihudu@student.ethz.ch
%-----------------------------------------------------------------------

clc;
clear all;
close all;

%% Estimate a second level PEB (Parametric Empirical Bayes) model

Data_Folder = '/Volumes/My_Passport/ETH_Zurich/Semester_Project/DCM_loc/';
out_dir = [Data_Folder 'analyses/'];
load([out_dir 'GCM_full.mat'],'GCM');


% Specify PEB model settings
% The 'all' option means the between-subject variability of each connection will 
% be estimated individually
M   = struct();
M.Q = 'all'; 

% Specify design matrix for N subjects. It should start with a constant column
N = 16;
M.X = ones(N,1);
M.maxit  = 256;

% Choose field
field = {'B','C'};

% Estimate model
[PEB,RCM] = spm_dcm_peb(GCM,M,field);

save([out_dir 'PEB_B_C.mat'],'PEB','RCM');

%%
% Search over nested PEB models.
BMA = spm_dcm_peb_bmc(PEB);
save([out_dir 'BMA_search_B_C.mat'],'BMA');

%% Review results
spm_dcm_peb_review(BMA,GCM)

