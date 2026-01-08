clc
clear
close all

%%
Data_Folder = '/Volumes/My_Passport/ETH_Zurich/Semester_Project/';

Sim_dir = [Data_Folder 'DCM/analyses/'];
Sim_GCM = load([Sim_dir 'GCM_full.mat'],'GCM');
Sim_GCM = Sim_GCM.GCM;

Sim_Vis = zeros(16,1);
Sim_SPL = zeros(16,1);
Sim_SMG = zeros(16,1);
Sim_Vis_prob = zeros(16,1);
Sim_SPL_prob = zeros(16,1);
Sim_SMG_prob = zeros(16,1);
for k = 1:16
Sim_Vis(k,1) = Sim_GCM{k,1}.Ep.C(1);
Sim_SPL(k,1) = Sim_GCM{k,1}.Ep.C(2);
Sim_SMG(k,1) = Sim_GCM{k,1}.Ep.C(3);
Sim_Vis_prob(k,1) = Sim_GCM{k,1}.Pp.C(1);
Sim_SPL_prob(k,1) = Sim_GCM{k,1}.Pp.C(2);
Sim_SMG_prob(k,1) = Sim_GCM{k,1}.Pp.C(3);
end
Sim_Vis(Sim_Vis_prob<0.9)=[];
Sim_SPL(Sim_SPL_prob<0.9)=[];
Sim_SMG(Sim_SMG_prob<0.9)=[];


Loc_dir = [Data_Folder 'DCM_loc/analyses/'];
Loc_GCM = load([Loc_dir 'GCM_full.mat'],'GCM');
Loc_GCM = Loc_GCM.GCM;

Loc_Vis = zeros(16,1);
Loc_SPL = zeros(16,1);
Loc_SMG = zeros(16,1);
Loc_Vis_prob = zeros(16,1);
Loc_SPL_prob = zeros(16,1);
Loc_SMG_prob = zeros(16,1);
for k = 1:16
Loc_Vis(k,1) = Loc_GCM{k,1}.Ep.C(1);
Loc_SPL(k,1) = Loc_GCM{k,1}.Ep.C(2);
Loc_SMG(k,1) = Loc_GCM{k,1}.Ep.C(3);
Loc_Vis_prob(k,1) = Loc_GCM{k,1}.Pp.C(1);
Loc_SPL_prob(k,1) = Loc_GCM{k,1}.Pp.C(2);
Loc_SMG_prob(k,1) = Loc_GCM{k,1}.Pp.C(3);
end
Loc_Vis(Loc_Vis_prob<0.9)=[];
Loc_SPL(Loc_SPL_prob<0.9)=[];
Loc_SMG(Loc_SMG_prob<0.9)=[];

%%
figure(2);
% Vis = [Sim_Vis Loc_Vis]; 

Vis_mean = [mean(Sim_Vis); mean(Loc_Vis)]; 
Vis_error = [std(Sim_Vis); std(Loc_Vis)]; 

% b = bar(1:2, Vis_mean, 'grouped','FaceColor','none','linewidth',2);
b = bar(1:2, Vis_mean, 'grouped','linewidth',2);
hold on

[ngroups,nbars] = size(Vis_mean);
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end

errorbar(x',Vis_mean,Vis_error,'k','linestyle','none','linewidth',2);

% for k = 1:16
%    plot(1:2,Vis(k,:),'marker','o','markersize',6,...
%     'markeredgecolor','k','markerfacecolor','none',...
%     'linestyle','-','color','k','linewidth',1.5);  
% end
xticklabels({'Sim','Loc'})
% hold off

% ylim([0 250])
hy = ylabel('Effect strength (s)');
% set(hy,'fontname','Times New Roman','fontsize',14)

%%
figure(2);
% SPL = [Sim_SPL Loc_SPL]; 

SPL_mean = [mean(Sim_SPL); mean(Loc_SPL)]; 
SPL_error = [std(Sim_SPL); std(Loc_SPL)]; 

% b = bar(4:5, SPL_mean, 'grouped','FaceColor','none','linewidth',2);
b = bar(4:5, SPL_mean, 'grouped','linewidth',2);
hold on

[ngroups,nbars] = size(SPL_mean);
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end

errorbar(x',SPL_mean,SPL_error,'k','linestyle','none','linewidth',2);

% for k = 1:16
%    plot(4:5,SPL(k,:),'marker','o','markersize',6,...
%     'markeredgecolor','k','markerfacecolor','none',...
%     'linestyle','-','color','k','linewidth',1.5);  
% end
xticklabels({'Sim','Loc'})
% hold off

% ylim([0 250])
hy = ylabel('Effect strength (Hz)');
% set(hy,'fontname','Times New Roman','fontsize',14)

%%
figure(2);
% SMG = [Sim_SMG Loc_SMG]; 

SMG_mean = [mean(Sim_SMG); mean(Loc_SMG)]; 
SMG_error = [std(Sim_SMG); std(Loc_SMG)]; 

% b = bar(7:8, SMG_mean, 'grouped','FaceColor','none','linewidth',2);
b = bar(7:8, SMG_mean, 'grouped','linewidth',2);
hold on

[ngroups,nbars] = size(SMG_mean);
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end

errorbar(x',SMG_mean,SMG_error,'k','linestyle','none','linewidth',2);

% for k = 1:16
%    plot(7:8,SMG(k,:),'marker','o','markersize',6,...
%     'markeredgecolor','k','markerfacecolor','none',...
%     'linestyle','-','color','k','linewidth',1.5);  
% end
xticklabels({'Sim','Loc'})
hold off

% ylim([0 250])
hy = ylabel('Effect strength (Hz)');
% set(hy,'fontname','Times New Roman','fontsize',14)
