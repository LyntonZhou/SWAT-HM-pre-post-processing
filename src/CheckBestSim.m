%% Lingfeng Zhou
clc
clear
load Obs
close all

filename = 'D:\LingfengZhou\20190726.Sufi2.SwatCup\output.rch';
delimiter = ' ';
startRow = 6;
formatSpec = '%*s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
textscan(fileID, '%[^\n\r]', startRow-1, 'ReturnOnError', false);
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'ReturnOnError', false);
fclose(fileID);
output = [dataArray{1:end-1}];
clearvars filename delimiter startRow formatSpec fileID dataArray ans;
flowout66=output(output(:,1)==66,6);
sedout66=output(output(:,1)==66,10);

%% Import data from text file.
filename = 'D:\LingfengZhou\20190726.Sufi2.SwatCup\outhml.rch';

formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN, 'ReturnOnError', false);
fclose(fileID);
outhml = [dataArray{1:end-1}];
clearvars filename formatSpec fileID dataArray ans;

solhmlout66=outhml(outhml(:,1)==66,8);
sorhmlout66=(outhml(outhml(:,1)==66,9)+outhml(outhml(:,1)==66,10));

% solhmlout15=outhml(outhml(:,1)==15,9);
% sorhmlout15=(outhml(outhml(:,1)==15,11)+outhml(outhml(:,1)==15,12));
% 
% figure % fig 1
% plot(flowout66,'Linewidth',1.5)
% hold on
% plot(flowobsout66,'r','Linewidth',1.5)
% % text(365,1200,['R2=' num2str(corr(flowobsout66,flowout66)^2)]);
% % text(365,1100,['NS=' num2str(nscoeff([flowobsout66,flowout66]))]);
% % plot(flowobsout66,'r','Linewidth',1.5)
% corr(flowobsout66,flowout66)^2
% nscoeff([flowobsout66,flowout66])
% xlim([-10,2200]);
% % set(gca,'Xtick',1:365:2191);
% % set(gca,'XTickLabel',{'2011','2012','2013','2014','2015','2016','2017'},'FontSize',16);
% set(get(gca,'YLabel'),'String',{'Flow (m^3/s)'},'FontSize',18);
% legend({'Sim','Obs'},'Location','northwest','FontSize',18);
% 
% figure % fig 2
% scatter(flowobsout66,flowout66,60,'filled');
% hold on
% xlim([0,1300]);ylim([0,1300]);
% plot([0,1300],[0,1300],'r','Linewidth',2);
% box on
% 
% figure % fig 3
% plot(sedout66,'Linewidth',1.5)
% hold on
% plot(sedobsout66,'r','Linewidth',1.5)
% corr(sedobsout66,sedout66)^2
% nscoeff([sedobsout66,sedout66])
% xlim([-10,2200]);
% set(gca,'Xtick',1:365:2191);
% % set(gca,'yscale','log')
% set(gca,'XTickLabel',{'2011','2012','2013','2014','2015','2016','2017'},'FontSize',16);
% set(get(gca,'YLabel'),'String',{'Sediment (tons/d)'},'FontSize',18);
% legend({'Sim','Obs'},'Location','northwest','FontSize',18);
% 
% figure % fig 4
% scatter(sedobsout66,sedout66,60,'filled');
% hold on
% xlim([0.1,100000]);ylim([0.1,100000]);
% set(gca,'xscale','log');set(gca,'yscale','log');
% plot([0.1,100000],[0.1,100000],'r','Linewidth',2);
% box on;
% 
hmltotalconc66 = (1000*1000*(solhmlout66+sorhmlout66)./(flowout66*86400));
hmldisconc66 = 1000*1000*(solhmlout66)./(flowout66*86400);
hmlparconc66 = 1000*1000*(sorhmlout66)./(flowout66*86400);
% figure % fig 5
% plot(hmltotalconc66,'Linewidth',1.5)
% hold on
% % plot(hmldisconc66,'Linewidth',1.5)
% % plot(hmlparconc66,'Linewidth',1.5)
% scatter(hmlobsconc66(:,1)-1,hmlobsconc66(:,2),70,'r','filled')
% corr(hmltotalconc66(hmlobsconc66(:,1)),hmlobsconc66(:,2))^2
% nscoeff([hmltotalconc66(hmlobsconc66(:,1)),hmlobsconc66(:,2)])
% xlim([-10,2200]);
% set(gca,'Xtick',1:365:2191);
% set(gca,'XTickLabel',{'2011','2012','2013','2014','2015','2016','2017'},'FontSize',16);
% set(get(gca,'YLabel'),'String',{'Zn total concentration (ug/L)'},'FontSize',18);
% legend({'Sim','Obs'},'Location','northwest','FontSize',18);
% % legend('Sim Total','Sim dissolved','Sim particulate','Obs Total','northwest');
% 
% figure % fig 6
% scatter(hmlobsconc66(:,2),hmltotalconc66(hmlobsconc66(:,1)),60,'filled');
% hold on
% xlim([0,500]);ylim([0,500]);
% plot([0,500],[0,500],'r','Linewidth',2);
% box on
% 
% figure % fig 7
% hmltotalload66 = solhmlout66+sorhmlout66;
% hmlobstotalload66 = hmlobsconc66(:,2).*flowobsout66(hmlobsconc66(:,1))*0.0864;
% plot(hmltotalload66,'Linewidth',1.5)
% hold on
% scatter(hmlobsconc66(:,1)-1,hmlobstotalload66,70,'r','filled');
% set(gca,'yscale','log');
% corr(hmltotalload66(hmlobsconc66(:,1)),hmlobstotalload66)
% nscoeff([hmltotalload66(hmlobsconc66(:,1)),hmlobstotalload66])
% xlim([-10,2200]);
% set(gca,'Xtick',1:365:2191);
% set(gca,'XTickLabel',{'2011','2012','2013','2014','2015','2016','2017'},'FontSize',16);
% set(get(gca,'YLabel'),'String',{'Zn total load (kg/d)'},'FontSize',18);
% legend({'Sim','Obs'},'Location','northwest','FontSize',18);
% 
% figure % fig 8
% scatter(hmlobstotalload66,hmltotalload66(hmlobsconc66(:,1)),60,'filled');
% hold on
% xlim([1,15000]);ylim([1,15000]);
% set(gca,'xscale','log');set(gca,'yscale','log');
% plot([1,15000],[1,15000],'r','Linewidth',2);
% box on

figure
subplot(3,1,1)
plot(flowout66,'Linewidth',2)
hold on
plot(flowobsout66,'r','Linewidth',2)
xlim([-10,2200]); ylim([-20 1500]);
set(gca,'Xtick',1:365:2191);
set(gca,'XTickLabel',{''},'FontSize',16);
set(get(gca,'YLabel'),'String',{'Streamflow', 'm^3 s^-^1'},'FontSize',14);
legend('Sim','Obs','FontSize',16,'Location','northwest','Orientation','horizontal'); legend('boxoff');

subplot(3,1,2)
plot(sedout66,'Linewidth',2)
hold on
plot(sedobsout66,'r','Linewidth',2)
corr(sedobsout66,sedout66)^2
nscoeff([sedobsout66,sedout66])
xlim([-10,2200]); ylim([-2000 10^5]);
set(gca,'Xtick',1:365:2191);
% set(gca,'yscale','log');
set(gca,'XTickLabel',{''},'FontSize',16);
set(get(gca,'YLabel'),'String',{'Sediment load', 'tons d^-^1'},'FontSize',14);
legend('Sim','Obs','FontSize',16,'Location','northwest','Orientation','horizontal');legend('boxoff');

hmltotalload66 = solhmlout66+sorhmlout66;
hmlobstotalload66 = hmlobsconc66(:,2).*flowobsout66(hmlobsconc66(:,1))*0.0864;
subplot(3,1,3)
plot(hmltotalload66,'Linewidth',2)
hold on
scatter(hmlobsconc66(:,1)-1,hmlobstotalload66,60,'r','filled');
set(gca,'yscale','log');
corr(hmltotalload66(hmlobsconc66(:,1)),hmlobstotalload66)
nscoeff([hmltotalload66(hmlobsconc66(:,1)),hmlobstotalload66])
xlim([-10,2200]);ylim([-5000 10^5]);
set(gca,'Xtick',1:365:2191);
set(gca,'XTickLabel',{'2011','2012','2013','2014','2015','2016','2017'},'FontSize',14);
set(gca,'Ytick',[10,1000,100000]);
% set(gca,'YTickLabel',{'1','1000','1000000'},'FontSize',14);
set(get(gca,'YLabel'),'String',{'Total Zn load', 'kg d^-^1'},'FontSize',14);
legend({'Sim','Obs'},'FontSize',16,'Location','northwest','Orientation','horizontal');legend('boxoff');

figure
subplot(2,3,1)
scatter(flowobsout66(1:1096),flowout66(1:1096),60,'filled');
hold on
xlim([0,1300]);ylim([0,1300]);
xlabel('Obs calibration (m^3 s^-^1)','FontSize',14);
ylabel('Sim calibration (m^3 s^-^1)','FontSize',14);
plot([0,1300],[0,1300],'r','Linewidth',2);
legend({'Streamflow'},'FontSize',14,'Location','northwest');
legend('boxoff'); box on
subplot(2,3,4)
scatter(flowobsout66(1097:end),flowout66(1097:end),60,'filled');
hold on
xlim([0,1300]);ylim([0,1300]);
xlabel('Obs validation (m^3 s^-^1)','FontSize',14);
ylabel('Sim validation (m^3 s^-^1)','FontSize',14);
plot([0,1300],[0,1300],'r','Linewidth',2);
legend({'Streamflow'},'FontSize',14,'Location','northwest');
legend('boxoff'); box on
subplot(2,3,2)
scatter(sedobsout66(1:1096),sedout66(1:1096),60,'filled');
hold on
xlim([0.1,100000]);ylim([0.1,100000]);
xlabel('Obs calibration (tons d^-^1)','FontSize',14);
ylabel('Sim calibration (tons d^-^1)','FontSize',14);
set(gca,'xscale','log');set(gca,'yscale','log');
plot([0.1,100000],[0.1,100000],'r','Linewidth',2);
legend({'Sediment'},'FontSize',14,'Location','northwest');
legend('boxoff');box on;
subplot(2,3,5)
scatter(sedobsout66(1097:end),sedout66(1097:end),60,'filled');
hold on
xlim([0.1,100000]);ylim([0.1,100000]);
xlabel('Obs validation (tons d^-^1)','FontSize',14);
ylabel('Sim validation (tons d^-^1)','FontSize',14);
set(gca,'xscale','log');set(gca,'yscale','log');
plot([0.1,100000],[0.1,100000],'r','Linewidth',2);
legend({'Sediment'},'FontSize',14,'Location','northwest');
legend('boxoff');box on;
subplot(2,3,3)
hmltotalload66_2=hmltotalload66(hmlobsconc66(:,1));
scatter(hmlobstotalload66(1:39),hmltotalload66_2(1:39),60,'filled');
hold on
xlim([1,50000]);ylim([1,50000]);
xlabel('Obs calidation (kg d^-^1)','FontSize',14);
ylabel('Sim calidation (kg d^-^1)','FontSize',14);
set(gca,'xscale','log');set(gca,'yscale','log');
set(gca,'Xtick',[1,100,10000]);
set(gca,'Ytick',[1,100,10000]);
plot([1,50000],[1,50000],'r','Linewidth',2);
legend({'Total Zn load'},'FontSize',14,'Location','northwest');
legend('boxoff'); box on
subplot(2,3,6)
scatter(hmlobstotalload66(40:end),hmltotalload66_2(40:end),60,'filled');
hold on
xlim([1,50000]);ylim([1,50000]);
xlabel('Obs validation (kg d^-^1)','FontSize',14);
ylabel('Sim validation (kg d^-^1)','FontSize',14);
set(gca,'xscale','log');set(gca,'yscale','log');
set(gca,'Xtick',[1,100,10000]);
set(gca,'Ytick',[1,100,10000]);
plot([1,50000],[1,50000],'r','Linewidth',2);
legend({'Total Zn load'},'FontSize',14,'Location','northwest');
legend('boxoff'); box on

[kge([flowobsout66(1:1096),flowout66(1:1096)]), ...
corr(flowobsout66(1:1096),flowout66(1:1096))^2, ...
nscoeff([flowobsout66(1:1096),flowout66(1:1096)]), ...
pbias([flowobsout66(1:1096),flowout66(1:1096)]), ...
kge([flowobsout66(1097:end),flowout66(1097:end)]), ...
corr(flowobsout66(1097:end),flowout66(1097:end))^2, ...
nscoeff([flowobsout66(1097:end),flowout66(1097:end)]), ...
pbias([flowobsout66(1097:end),flowout66(1097:end)]); ...
kge([sedobsout66(1:1096),sedout66(1:1096)]), ...
corr(sedobsout66(1:1096),sedout66(1:1096))^2, ...
nscoeff([sedobsout66(1:1096),sedout66(1:1096)]), ...
pbias([sedobsout66(1:1096),sedout66(1:1096)]), ...
kge([sedobsout66(1097:end),sedout66(1097:end)]), ...
corr(sedobsout66(1097:end),sedout66(1097:end))^2, ...
nscoeff([sedobsout66(1097:end),sedout66(1097:end)]), ...
pbias([sedobsout66(1097:end),sedout66(1097:end)]); ...
kge([hmlobstotalload66(1:39),hmltotalload66_2(1:39)]), ...
corr(hmlobstotalload66(1:39),hmltotalload66_2(1:39))^2, ...
nscoeff([hmlobstotalload66(1:39),hmltotalload66_2(1:39)]), ...
pbias([hmlobstotalload66(1:39),hmltotalload66_2(1:39)]), ...
kge([hmlobstotalload66(40:end),hmltotalload66_2(40:end)]),  ...
corr(hmlobstotalload66(40:end),hmltotalload66_2(40:end))^2,  ...
nscoeff([hmlobstotalload66(40:end),hmltotalload66_2(40:end)]),  ...
pbias([hmlobstotalload66(40:end),hmltotalload66_2(40:end)])]



% HMFLOW95=importfile('SWATHM_simulated.dat');
% for ii=1:5
%     idx(ii)=ii+2192*(ii-1);
% end
% HMFLOW95(idx,:)=[];
% HM95PPU=reshape(HMFLOW95(:,3),2192,5);
% 
% figure % fig 10
% plot(max(HM95PPU,[],2),'Linewidth',1.5)
% hold on
% plot(min(HM95PPU,[],2),'Linewidth',1.5)
% scatter(hmlobsconc66(:,1)-1,hmlobstotalload66,70,'r','filled');
% set(gca,'yscale','log');
% corr(hmltotalload66(hmlobsconc66(:,1)),hmlobstotalload66)
% nscoeff([hmltotalload66(hmlobsconc66(:,1)),hmlobstotalload66])
% xlim([-10,2200]);
% set(gca,'Xtick',1:365:2191);
% set(gca,'XTickLabel',{'2011','2012','2013','2014','2015','2016','2017'},'FontSize',16);
% set(get(gca,'YLabel'),'String',{'Zn total load (kg/d)'},'FontSize',18);
% legend({'Sim','Obs'},'Location','northwest','FontSize',18);

%% Initialize variables.
filename = 'D:\LingfengZhou\20190309.Sufi2.SwatCup\Iterations\Iter12\Sufi2.Out\R-HM_TOT_OUT_66_66.txt';
delimiter = ' ';
%% Format for each line of text:
formatSpec = '%f%f%[^\n\r]';
%% Open the text file.
fileID = fopen(filename,'r');
%% Read columns of data according to the format.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'EmptyValue', NaN,  'ReturnOnError', false);
%% Close the text file.
fclose(fileID);
%% Post processing for unimportable data.
%% Create output variable
RHMTOTOUT66 = [dataArray{1:end-1}];
%% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans;

% RHMTOTOUT66=reshape(RHMTOTOUT66,2193,1001,2);
RHMTOTOUT66=reshape(RHMTOTOUT66,2193,1000,2);
RHMTOTOUT66(:,:,1)=[];
% RHMTOTOUT66(:,end)=[];
RHMTOTOUT66(1,:)=[];
Y_sim = RHMTOTOUT66';


%% Import data from text file.
%% Initialize variables.
filename = 'D:\LingfengZhou\20190309.Sufi2.SwatCup\Iterations\Iter12\Sufi2.Out\goal.txt';
delimiter = ' ';
startRow = 5;

%% Format for each line of text:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
%% Create output variable
parsgoal = [dataArray{1:end-1}];
%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;
GLF = parsgoal(:,end);

%apply GLUE
threshold = 0.1;
[ idx, Llim, Ulim ] = GLUE(GLF,threshold,Y_sim);

% [T,S]=size(RHMTOTOUT66);
% for t=1:T
%  ULlim_ = sort(RHMTOTOUT66(t,:));
% RHMTOTOUT66uplowlim (t,1) = ULlim_(end);
% RHMTOTOUT66uplowlim (t,2) = ULlim_(1);
% end
%   
% figure
% plot(RHMTOTOUT66uplowlim)
% set(gca,'yscale','log');
% xlim([1,365]);

% Plot 'behavioural' time series:
figure
% plot(Y_sim','b')
hold on
plot(Ulim,'b')
plot(Llim,'b')
scatter(hmlobsconc66(:,1)-1,hmlobstotalload66,60,'r','filled');
xlabel('time (days)'); ylabel('Zn (kg/day)')
set(gca,'yscale','log');
xlim([1,1097]); box on;

figure
% plot(Y_sim','b')
hold on
plot(Y_sim(idx,:)','b')
scatter(hmlobsconc66(:,1)-1,hmlobstotalload66,60,'r','filled');
xlabel('time (days)'); ylabel('Zn (kg/day)')
set(gca,'yscale','log');
xlim([1,365*3]);

figure
% plot(Y_sim','b')
hold on
plot(Y_sim(idx,:)','b')
scatter(hmlobsconc66(:,1)-1,hmlobstotalload66,60,'r','filled');
xlabel('time (days)'); ylabel('Zn (kg/day)')
set(gca,'yscale','log');
xlim([365*3+1,2912]);


