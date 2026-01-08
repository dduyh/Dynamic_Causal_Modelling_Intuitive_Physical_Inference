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
field = {'A'};

% Estimate model
[PEB,RCM] = spm_dcm_peb(GCM,M,field);

save([out_dir 'PEB_A.mat'],'PEB','RCM');

%%
% Search over nested PEB models.
BMA = spm_dcm_peb_bmc(PEB);
save([out_dir 'BMA_search_A.mat'],'BMA');

%% Review results
spm_dcm_peb_review(BMA,GCM)

%% Compare the full PEB model to nested PEB models to test specific hypotheses
% Get an existing model. We'll use the first subject's DCM as a template
DCM_full = GCM{1};

% IMPORTANT: If the model has already been estimated, clear out the old priors, or changes to DCM.a,b,c will be ignored
if isfield(DCM_full,'M')
    DCM_full = rmfield(DCM_full ,'M');
end

% Specify candidate models that differ in particular A-matrix connections, e.g.
DCM_model1 = DCM_full;
DCM_model1.a = zeros(3,3);
DCM_model1.a(1,1) = 1; % Switching on the connections of region 1 -> region 1

DCM_model2 = DCM_full;
DCM_model2.a = zeros(3,3);
DCM_model2.a(2,2) = 1; % Switching on the connections of region 2 -> region 2

DCM_model3 = DCM_full;
DCM_model3.a = zeros(3,3);
DCM_model3.a(3,3) = 1; % Switching on the connections of region 3 -> region 3

DCM_model4 = DCM_full;
DCM_model4.a = zeros(3,3);
DCM_model4.a(1,2) = 1; % Switching on the connections of region 2 -> region 1

DCM_model5 = DCM_full;
DCM_model5.a = zeros(3,3);
DCM_model5.a(1,3) = 1; % Switching on the connections of region 3 -> region 1

DCM_model6 = DCM_full;
DCM_model6.a = zeros(3,3);
DCM_model6.a(2,3) = 1; % Switching on the connections of region 3 -> region 2

DCM_model7 = DCM_full;
DCM_model7.a = zeros(3,3);
DCM_model7.a(2,1) = 1; % Switching on the connections of region 1 -> region 2

DCM_model8 = DCM_full;
DCM_model8.a = zeros(3,3);
DCM_model8.a(3,1) = 1; % Switching on the connections of region 1 -> region 3

DCM_model9 = DCM_full;
DCM_model9.a = zeros(3,3);
DCM_model9.a(3,2) = 1; % Switching on the connections of region 2 -> region 3

DCM_null = DCM_full;
DCM_null.a = zeros(3,3);

GCM = {DCM_full, DCM_model1, DCM_model2, DCM_model3, DCM_model4, ...
       DCM_model5, DCM_model6, DCM_model7, DCM_model8, DCM_model9, DCM_null};
save([out_dir 'GCM_A_templates.mat'], 'GCM');

% Compare nested PEB models. Decide which connections to switch off based on the 
% structure of each template DCM in the GCM cell array. This should have one row 
% and one column per candidate model (it doesn't need to be estimated).
[BMA,BMR] = spm_dcm_peb_bmc(PEB, GCM);
save([out_dir 'BMA_A_11models.mat'],'BMA','BMR');

%% Review results
spm_dcm_peb_review(BMA,GCM)


