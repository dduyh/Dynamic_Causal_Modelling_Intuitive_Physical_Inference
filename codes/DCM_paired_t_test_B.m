clc
clear
close all

%%
Data_Folder = '/Volumes/YihuiDu/ETH_Zurich/Semester_Project/';

Sim_dir = [Data_Folder 'DCM/analyses/'];
Sim_GCM = load([Sim_dir 'GCM_full.mat'],'GCM');
Sim_GCM = Sim_GCM.GCM;

Sim_Vis_Vis = zeros(16,1);
Sim_SPL_Vis = zeros(16,1);
Sim_SMG_Vis = zeros(16,1);
Sim_Vis_SPL = zeros(16,1);
Sim_SPL_SPL = zeros(16,1);
Sim_SMG_SPL = zeros(16,1);
Sim_Vis_SMG = zeros(16,1);
Sim_SPL_SMG = zeros(16,1);
Sim_SMG_SMG = zeros(16,1);
for k = 1:16
Sim_Vis_Vis(k,1) = Sim_GCM{k,1}.Ep.B(1,1);
Sim_SPL_Vis(k,1) = Sim_GCM{k,1}.Ep.B(1,2);
Sim_SMG_Vis(k,1) = Sim_GCM{k,1}.Ep.B(1,3);
Sim_Vis_SPL(k,1) = Sim_GCM{k,1}.Ep.B(2,1);
Sim_SPL_SPL(k,1) = Sim_GCM{k,1}.Ep.B(2,2);
Sim_SMG_SPL(k,1) = Sim_GCM{k,1}.Ep.B(2,3);
Sim_Vis_SMG(k,1) = Sim_GCM{k,1}.Ep.B(3,1);
Sim_SPL_SMG(k,1) = Sim_GCM{k,1}.Ep.B(3,2);
Sim_SMG_SMG(k,1) = Sim_GCM{k,1}.Ep.B(3,3);
end

Loc_dir = [Data_Folder 'DCM_loc/analyses/'];
Loc_GCM = load([Loc_dir 'GCM_full.mat'],'GCM');
Loc_GCM = Loc_GCM.GCM;

Loc_Vis_Vis = zeros(16,1);
Loc_SPL_Vis = zeros(16,1);
Loc_SMG_Vis = zeros(16,1);
Loc_Vis_SPL = zeros(16,1);
Loc_SPL_SPL = zeros(16,1);
Loc_SMG_SPL = zeros(16,1);
Loc_Vis_SMG = zeros(16,1);
Loc_SPL_SMG = zeros(16,1);
Loc_SMG_SMG = zeros(16,1);
for k = 1:16
Loc_Vis_Vis(k,1) = Loc_GCM{k,1}.Ep.B(1,1);
Loc_SPL_Vis(k,1) = Loc_GCM{k,1}.Ep.B(1,2);
Loc_SMG_Vis(k,1) = Loc_GCM{k,1}.Ep.B(1,3);
Loc_Vis_SPL(k,1) = Loc_GCM{k,1}.Ep.B(2,1);
Loc_SPL_SPL(k,1) = Loc_GCM{k,1}.Ep.B(2,2);
Loc_SMG_SPL(k,1) = Loc_GCM{k,1}.Ep.B(2,3);
Loc_Vis_SMG(k,1) = Loc_GCM{k,1}.Ep.B(3,1);
Loc_SPL_SMG(k,1) = Loc_GCM{k,1}.Ep.B(3,2);
Loc_SMG_SMG(k,1) = Loc_GCM{k,1}.Ep.B(3,3);
end

%%
figure(1);
Vis_Vis = [Sim_Vis_Vis Loc_Vis_Vis]; 

Vis_Vis_mean = [mean(Sim_Vis_Vis); mean(Loc_Vis_Vis)]; 
Vis_Vis_error = [std(Sim_Vis_Vis); std(Loc_Vis_Vis)]; 

b = bar(1:2, Vis_Vis_mean, 'grouped','FaceColor','flat','linewidth',2);
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0.4660 0.6740 0.1880];
hold on

errorbar(1:2,Vis_Vis_mean,Vis_Vis_error,'k','linestyle','none','linewidth',2);

for k = 1:16
   plot(1:2,Vis_Vis(k,:),'marker','o','markersize',6,...
    'markeredgecolor','k','markerfacecolor','none',...
    'linestyle','-','color','k','linewidth',1.5);  
end
xticklabels({'Sim','Loc'})


%%
figure(1);
SPL_Vis = [Sim_SPL_Vis Loc_SPL_Vis]; 

SPL_Vis_mean = [mean(Sim_SPL_Vis); mean(Loc_SPL_Vis)]; 
SPL_Vis_error = [std(Sim_SPL_Vis); std(Loc_SPL_Vis)]; 

b = bar(4:5, SPL_Vis_mean, 'grouped','FaceColor','flat','linewidth',2);
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0.4660 0.6740 0.1880];
hold on

errorbar(4:5,SPL_Vis_mean,SPL_Vis_error,'k','linestyle','none','linewidth',2);

for k = 1:16
   plot(4:5,SPL_Vis(k,:),'marker','o','markersize',6,...
    'markeredgecolor','k','markerfacecolor','none',...
    'linestyle','-','color','k','linewidth',1.5);  
end


%%
figure(1);
SMG_Vis = [Sim_SMG_Vis Loc_SMG_Vis]; 

SMG_Vis_mean = [mean(Sim_SMG_Vis); mean(Loc_SMG_Vis)]; 
SMG_Vis_error = [std(Sim_SMG_Vis); std(Loc_SMG_Vis)]; 

% b = bar(7:8, SMG_mean, 'grouped','FaceColor','none','linewidth',2);
b = bar(7:8, SMG_Vis_mean, 'grouped','FaceColor','flat','linewidth',2);
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0.4660 0.6740 0.1880];
hold on

errorbar(7:8,SMG_Vis_mean,SMG_Vis_error,'k','linestyle','none','linewidth',2);

for k = 1:16
   plot(7:8,SMG_Vis(k,:),'marker','o','markersize',6,...
    'markeredgecolor','k','markerfacecolor','none',...
    'linestyle','-','color','k','linewidth',1.5);  
end


%%
figure(1);
Vis_SPL = [Sim_Vis_SPL Loc_Vis_SPL]; 

Vis_SPL_mean = [mean(Sim_Vis_SPL); mean(Loc_Vis_SPL)]; 
Vis_SPL_error = [std(Sim_Vis_SPL); std(Loc_Vis_SPL)]; 

% b = bar(1:2, Vis_mean, 'grouped','FaceColor','none','linewidth',2);
b = bar(10:11, Vis_SPL_mean, 'grouped','FaceColor','flat','linewidth',2);
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0.4660 0.6740 0.1880];
hold on

errorbar(10:11,Vis_SPL_mean,Vis_SPL_error,'k','linestyle','none','linewidth',2);

for k = 1:16
   plot(10:11,Vis_SPL(k,:),'marker','o','markersize',6,...
    'markeredgecolor','k','markerfacecolor','none',...
    'linestyle','-','color','k','linewidth',1.5);  
end


%%
figure(1);
SPL_SPL = [Sim_SPL_SPL Loc_SPL_SPL]; 

SPL_SPL_mean = [mean(Sim_SPL_SPL); mean(Loc_SPL_SPL)]; 
SPL_SPL_error = [std(Sim_SPL_SPL); std(Loc_SPL_SPL)]; 

% b = bar(4:5, SPL_mean, 'grouped','FaceColor','none','linewidth',2);
b = bar(13:14, SPL_SPL_mean, 'grouped','FaceColor','flat','linewidth',2);
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0.4660 0.6740 0.1880];
hold on

errorbar(13:14,SPL_SPL_mean,SPL_SPL_error,'k','linestyle','none','linewidth',2);

for k = 1:16
   plot(13:14,SPL_SPL(k,:),'marker','o','markersize',6,...
    'markeredgecolor','k','markerfacecolor','none',...
    'linestyle','-','color','k','linewidth',1.5);  
end


%%
figure(1);
SMG_SPL = [Sim_SMG_SPL Loc_SMG_SPL]; 

SMG_SPL_mean = [mean(Sim_SMG_SPL); mean(Loc_SMG_SPL)]; 
SMG_SPL_error = [std(Sim_SMG_SPL); std(Loc_SMG_SPL)]; 

% b = bar(7:8, SMG_mean, 'grouped','FaceColor','none','linewidth',2);
b = bar(16:17, SMG_SPL_mean, 'grouped','FaceColor','flat','linewidth',2);
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0.4660 0.6740 0.1880];
hold on

errorbar(16:17,SMG_SPL_mean,SMG_SPL_error,'k','linestyle','none','linewidth',2);

for k = 1:16
   plot(16:17,SMG_SPL(k,:),'marker','o','markersize',6,...
    'markeredgecolor','k','markerfacecolor','none',...
    'linestyle','-','color','k','linewidth',1.5);  
end

%%
figure(1);
Vis_SMG = [Sim_Vis_SMG Loc_Vis_SMG]; 

Vis_SMG_mean = [mean(Sim_Vis_SMG); mean(Loc_Vis_SMG)]; 
Vis_SMG_error = [std(Sim_Vis_SMG); std(Loc_Vis_SMG)]; 

% b = bar(1:2, Vis_mean, 'grouped','FaceColor','none','linewidth',2);
b = bar(19:20, Vis_SMG_mean, 'grouped','FaceColor','flat','linewidth',2);
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0.4660 0.6740 0.1880];
hold on

errorbar(19:20,Vis_SMG_mean,Vis_SMG_error,'k','linestyle','none','linewidth',2);

for k = 1:16
   plot(19:20,Vis_SMG(k,:),'marker','o','markersize',6,...
    'markeredgecolor','k','markerfacecolor','none',...
    'linestyle','-','color','k','linewidth',1.5);  
end


%%
figure(1);
SPL_SMG = [Sim_SPL_SMG Loc_SPL_SMG]; 

SPL_SMG_mean = [mean(Sim_SPL_SMG); mean(Loc_SPL_SMG)]; 
SPL_SMG_error = [std(Sim_SPL_SMG); std(Loc_SPL_SMG)]; 

% b = bar(4:5, SPL_mean, 'grouped','FaceColor','none','linewidth',2);
b = bar(22:23, SPL_SMG_mean, 'grouped','FaceColor','flat','linewidth',2);
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0.4660 0.6740 0.1880];
hold on

errorbar(22:23,SPL_SMG_mean,SPL_SMG_error,'k','linestyle','none','linewidth',2);

for k = 1:16
   plot(22:23,SPL_SMG(k,:),'marker','o','markersize',6,...
    'markeredgecolor','k','markerfacecolor','none',...
    'linestyle','-','color','k','linewidth',1.5);  
end

%%
figure(1);
SMG_SMG = [Sim_SMG_SMG Loc_SMG_SMG]; 

SMG_SMG_mean = [mean(Sim_SMG_SMG); mean(Loc_SMG_SMG)]; 
SMG_SMG_error = [std(Sim_SMG_SMG); std(Loc_SMG_SMG)]; 

% b = bar(7:8, SMG_mean, 'grouped','FaceColor','none','linewidth',2);
b = bar(25, SMG_SMG_mean(1), 'grouped','FaceColor','flat','linewidth',2);
b.CData(1,:) = [0.9290 0.6940 0.1250];
c = bar(26, SMG_SMG_mean(2), 'grouped','FaceColor','flat','linewidth',2);
c.CData(1,:) = [0.4660 0.6740 0.1880];
hold on

errorbar(25:26,SMG_SMG_mean,SMG_SMG_error,'k','linestyle','none','linewidth',2);

for k = 1:16
   plot(25:26,SMG_SMG(k,:),'marker','o','markersize',6,...
    'markeredgecolor','k','markerfacecolor','none',...
    'linestyle','-','color','k','linewidth',1.5);  
end

xticks([1.5:3:25.5]);
xticklabels({'Vis->Vis','SPL->Vis','SMG->Vis','Vis->SPL','SPL->SPL','SMG->SPL','Vis->SMG','SPL->SMG','SMG->SMG'});


legend([b,c],' Inference Task',' Control Task')

ylim([-1.5 2])
hy = ylabel('Effect strength (Hz)');
set(hy,'fontname','Times New Roman','fontsize',22)

%%
X = [Vis_Vis SPL_Vis SMG_Vis Vis_SPL SPL_SPL SMG_SPL Vis_SMG SPL_SMG SMG_SMG]; 
PAIRS =[ 1 2; 3 4;5 6; 7 8; 9 10;11 12; 13 14; 15 16;17 18 ];
[H,P,SIGPAIRS] = ttest_bonf(X,PAIRS);