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
for k = 1:16
Sim_Vis(k,1) = Sim_GCM{k,1}.Ep.C(1);
Sim_SPL(k,1) = Sim_GCM{k,1}.Ep.C(2);
Sim_SMG(k,1) = Sim_GCM{k,1}.Ep.C(3);
% Sim_Vis(k,1) = Sim_GCM{k,1}.Pp.C(1);
% Sim_SPL(k,1) = Sim_GCM{k,1}.Pp.C(2);
% Sim_SMG(k,1) = Sim_GCM{k,1}.Pp.C(3);
end

Loc_dir = [Data_Folder 'DCM_loc/analyses/'];
Loc_GCM = load([Loc_dir 'GCM_full.mat'],'GCM');
Loc_GCM = Loc_GCM.GCM;

Loc_Vis = zeros(16,1);
Loc_SPL = zeros(16,1);
Loc_SMG = zeros(16,1);
for k = 1:16
Loc_Vis(k,1) = Loc_GCM{k,1}.Ep.C(1);
Loc_SPL(k,1) = Loc_GCM{k,1}.Ep.C(2);
Loc_SMG(k,1) = Loc_GCM{k,1}.Ep.C(3);
% Loc_Vis(k,1) = Loc_GCM{k,1}.Pp.C(1);
% Loc_SPL(k,1) = Loc_GCM{k,1}.Pp.C(2);
% Loc_SMG(k,1) = Loc_GCM{k,1}.Pp.C(3);
end

%%
figure(1);
Vis = [Sim_Vis Loc_Vis]; 

Vis_mean = [mean(Sim_Vis) mean(Loc_Vis)]; 
Vis_error = [std(Sim_Vis) std(Loc_Vis)]; 

b = bar(1:2, Vis_mean, 'grouped','FaceColor','flat','linewidth',2);
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0.4660 0.6740 0.1880];
hold on

errorbar(1:2,Vis_mean,Vis_error,'k','linestyle','none','linewidth',2);

for k = 1:16
   plot(1:2,Vis(k,:),'marker','o','markersize',6,...
    'markeredgecolor','k','markerfacecolor','none',...
    'linestyle','-','color','k','linewidth',1.5);  
end


%%
figure(1);
SPL = [Sim_SPL Loc_SPL]; 

SPL_mean = [mean(Sim_SPL) mean(Loc_SPL)]; 
SPL_error = [std(Sim_SPL) std(Loc_SPL)]; 

b = bar(4:5, SPL_mean, 'grouped','FaceColor','flat','linewidth',2);
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0.4660 0.6740 0.1880];
hold on

errorbar(4:5,SPL_mean,SPL_error,'k','linestyle','none','linewidth',2);

for k = 1:16
   plot(4:5,SPL(k,:),'marker','o','markersize',6,...
    'markeredgecolor','k','markerfacecolor','none',...
    'linestyle','-','color','k','linewidth',1.5);  
end


%%
figure(1);
SMG = [Sim_SMG Loc_SMG]; 

SMG_mean = [mean(Sim_SMG) mean(Loc_SMG)]; 
SMG_error = [std(Sim_SMG) std(Loc_SMG)]; 

%b = bar(7:8, SMG_mean, 'grouped','FaceColor','flat','linewidth',2);
b = bar(7, SMG_mean(1), 'FaceColor','flat','linewidth',2);
b.CData(1,:) = [0.9290 0.6940 0.1250];

c = bar(8, SMG_mean(2), 'FaceColor','flat','linewidth',2);
c.CData(1,:) = [0.4660 0.6740 0.1880];

hold on

errorbar(7:8,SMG_mean,SMG_error,'k','linestyle','none','linewidth',2);

for k = 1:16
   plot(7:8,SMG(k,:),'marker','o','markersize',6,...
    'markeredgecolor','k','markerfacecolor','none',...
    'linestyle','-','color','k','linewidth',1.5);  
end
xticks([1.5 4.5 7.5]);
xticklabels({'Vis','SPL','SMG'});

% set(b, {'DisplayName'}, {'Sim','Loc'})
legend([b,c],'Sim','Loc')
% legend(b,'Sim','Loc')
% hold off

% ylim([0 250])
hy = ylabel('Effect strength (Hz)');
set(hy,'fontname','Times New Roman','fontsize',14)

%%
X = [Vis SPL SMG]; 
PAIRS =[ 1 2; 3 4;5 6 ];
[H,P,SIGPAIRS] = ttest_bonf(X,PAIRS);