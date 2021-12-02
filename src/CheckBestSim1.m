%% Lingfeng Zhou
% clc
clear
close all
load simobs
load ymd
% obsHMTOT66(45) = 12146.11;

%% 95ppu of streamflow and sediment load
figure
subplot(2,1,1)
hold on
x=1:72;
f1=fill([x,fliplr(x)],[quantile(FLOWOUT66M',0.975),fliplr(quantile(FLOWOUT66M',0.025))], ...
    [77/256 175/256 74/256],'edgealpha',1,'edgecolor',[0 1 0],'facealpha',1);
plot(quantile(FLOWOUT66M',0.975),'color',[55/256 126/256 184/256],'LineWidth',1.5) 
plot(quantile(FLOWOUT66M',0.025),'color',[55/256 126/256 184/256],'LineWidth',1.5)
scatter(1:72,ObsFLOW66M,50,'MarkerFaceColor',[228/256 26/256 28/256]);
err = 0.1*ones(size(ObsFLOW66M)).*ObsFLOW66M;
e=errorbar(x,ObsFLOW66M,err, 'o');
e.MarkerSize = 6;
e.LineWidth = 1.0;
e.MarkerFaceColor = [228/256 26/256 28/256];
e.Color = [228/256 26/256 28/256];
xlim([1,72]);%ylim([0,300]);%xlabel('Month from January 2011','FontSize',16);
set(gca,'Xtick',0:12:72,'FontSize',14);set(gca,'LineWidth',2);
ylabel('Streamflow (m^3 s^-1)','FontSize',16);
[pp,rr]=prfactor(quantile(FLOWOUT66M',0.975),quantile(FLOWOUT66M',0.025), ...
   ObsFLOW66M,0.1);
text(24,340, ['{\itP-factor} = ',num2str(pp,'%3.2f') '  {\itR-factor} = ',num2str(rr,'%3.2f')],'FontSize',14);
legend([f1,e],{'95PPU','Observation with error bar'},'FontSize',14, ...
    'Location','NorthWest'); 
legend boxoff;
set(gca,'tickdir','out');

subplot(2,1,2)
hold on 
x=1:72;
% set(gca,'yscale','log');
fill([x,fliplr(x)],[quantile(SEDOUT66M',0.975),fliplr(quantile(SEDOUT66M',0.025))], ...
    [77/256 175/256 74/256],'edgealpha',1,'edgecolor',[0 1 0],'facealpha',1);
plot(quantile(SEDOUT66M',0.975),'color',[55/256 126/256 184/256],'LineWidth',2) 
plot(quantile(SEDOUT66M',0.025),'color',[55/256 126/256 184/256],'LineWidth',2)
% scatter(1:72,ObsSED66M,50,'MarkerFaceColor',[228/256 26/256 28/256]);
err = 0.2*ones(size(ObsSED66M)).*ObsSED66M;
e=errorbar(x,ObsSED66M,err,'o');
e.MarkerSize = 6;
e.LineWidth = 1.0;
e.MarkerFaceColor = [228/256 26/256 28/256];
e.Color = [228/256 26/256 28/256];
xlim([1,72]);xlabel('Month from January 2011','FontSize',16);ylim([-1000,12000]);
set(gca,'Xtick',0:12:72,'FontSize',14);set(gca,'LineWidth',2);
ylabel('Sediment load (tons d^-1)','FontSize',16);
[pp,rr]=prfactor(quantile(SEDOUT66M',0.975),quantile(SEDOUT66M',0.025), ...
   ObsSED66M,0.2);
text(24,10000, ['{\itP-factor} = ',num2str(pp,'%3.2f') '  {\itR-factor} = ',num2str(rr,'%3.2f')],'FontSize',14);
set(gca,'tickdir','out');

figure
h=subplot(3,1,1);
p=get(h,'pos'); % p=[left bottom width height])
plot(simbestFLOW,'Color',[55/256 126/256 184/256],'Linewidth',3)
hold on
plot(obsFLOW66,'Color',[228/256 26/256 28/256],'Linewidth',3)
set(gca,'Xtick',1:365:2191);
set(gca,'XTickLabel',{''},'FontSize',14);
set(get(gca,'YLabel'),'String',{'Streamflow', 'm^3 s^-^1'},'FontSize',16);
legend({'Sim','Obs'},'FontSize',16,'Location','northwest','Orientation','horizontal'); legend('boxoff');
% legend({'Sim','Obs'},'FontSize',16,'Location','East');legend('boxoff');
plot([1096,1096],[2000,0],'--k','Linewidth',1.5);
set(gca,'LineWidth',1);
set(gca,'tickdir','out');
annotation('textbox',[(p(1)+p(3)*38/100),(p(2)+p(4)-0.03),p(3)/6,0.04],...
    'String', 'Calibration','FontSize',14,'LineStyle','none');
annotation('textbox',[(p(1)+p(3)*52/100),(p(2)+p(4)-0.03),p(3)/6,0.04],...
    'String', 'Validation','FontSize',14,'LineStyle','none');
box off
xlim([-10,2200]); %ylim([-20 1500]);
% xL=xlim;yL=ylim;
% plot([xL(2),xL(2)],[yL(1),yL(2)],'k','linewidth',1)
% plot(xL,[yL(2),yL(2)],'k','linewidth',1)
% axis([xL yL]);

h=subplot(3,1,2);
p=get(h,'pos'); % p=[left bottom width height])
plot(simbestSED,'Color',[55/256 126/256 184/256],'Linewidth',3)
hold on
plot(obsSED66,'Color',[228/256 26/256 28/256],'Linewidth',3)
set(gca,'Xtick',1:365:2191);
% set(gca,'yscale','log');
set(gca,'XTickLabel',{''},'FontSize',14);
set(get(gca,'YLabel'),'String',{'Sediment load', 'tons d^-^1'},'FontSize',16);
legend({'Sim','Obs'},'FontSize',16,'Location','northwest','Orientation','horizontal');legend('boxoff');
% legend({'Sim','Obs'},'FontSize',16,'Location','East');legend('boxoff');
plot([1096,1096],[100000,0],'--k','Linewidth',1.5);set(gca,'LineWidth',1);
annotation('textbox',[(p(1)+p(3)*38/100),(p(2)+p(4)-0.03),p(3)/6,0.04],...
    'String', 'Calibration','FontSize',14,'LineStyle','none');
annotation('textbox',[(p(1)+p(3)*52/100),(p(2)+p(4)-0.03),p(3)/6,0.04],...
    'String', 'Validation','FontSize',14,'LineStyle','none');
set(gca,'tickdir','out');
box off
xlim([-10,2200]); %ylim([-2000 10^5]);
% xL=xlim;yL=ylim;
% plot([xL(2),xL(2)],[yL(1),yL(2)],'k','linewidth',1)
% plot(xL,[yL(2),yL(2)],'k','linewidth',1)
% axis([xL yL]);

h=subplot(3,1,3);
p=get(h,'pos'); % p=[left bottom width height])
plot(HMTOTOUT66(:,bestsimNo),'Color',[55/256 126/256 184/256],'Linewidth',3)
hold on
scatter(obsHMTOT66_idx,obsHMTOT66,60,'MarkerFaceColor',[228/256 26/256 28/256]);
set(gca,'Xtick',1:365:2191);
set(gca,'XTickLabel',{'2011','2012','2013','2014','2015','2016','2017'},'FontSize',14);
set(gca,'Ytick',[10,1000,100000]);
% set(gca,'YTickLabel',{'1','1000','1000000'},'FontSize',14);
set(get(gca,'XLabel'),'String',{'Day from January 1^{st} 2011'},'FontSize',16);
set(get(gca,'YLabel'),'String',{'Total Zn load', 'kg d^-^1'},'FontSize',16);
legend({'Sim','Obs'},'FontSize',16,'Location','northwest','Orientation','horizontal');legend('boxoff');
% legend({'Sim','Obs'},'FontSize',16,'Location','East');legend('boxoff');
% plot([1095,1095],[0,100000],'--k','Linewidth',1.5);
plot([1096,1096],[100000,1],'--k','Linewidth',1.5);set(gca,'LineWidth',1);
annotation('textbox',[(p(1)+p(3)*38/100),(p(2)+p(4)-0.03),p(3)/6,0.04],...
    'String', 'Calibration','FontSize',14,'LineStyle','none');
annotation('textbox',[(p(1)+p(3)*52/100),(p(2)+p(4)-0.03),p(3)/6,0.04],...
    'String', 'Validation','FontSize',14,'LineStyle','none');
set(gca,'LineWidth',1);
set(gca,'tickdir','out');
set(gca,'yscale','log');
box off
xlim([-10,2200]);%ylim([-5000 10^5]);
% xL=xlim;yL=ylim;
% plot([xL(2),xL(2)],[yL(1),yL(2)],'k','linewidth',1)
% plot(xL,[yL(2),yL(2)],'k','linewidth',1)
% axis([xL yL]);

figure
subplot(2,3,1)
scatter(obsFLOW66(1:1096),simbestFLOW(1:1096),40,'filled');
hold on
xlim([0,1300]);ylim([0,1300]);
xlabel('Obs calibration (m^3 s^-^1)','FontSize',16);
ylabel('Sim calibration (m^3 s^-^1)','FontSize',16);
plot([0,1300],[0,1300],'r','Linewidth',2);
legend({'Streamflow'},'FontSize',14,'Location','northwest');
legend('boxoff'); box on
set(gca,'LineWidth',1.5);

subplot(2,3,4)
scatter(obsFLOW66(1097:end),simbestFLOW(1097:end),40,'filled');
hold on
xlim([0,1300]);ylim([0,1300]);
xlabel('Obs validation (m^3 s^-^1)','FontSize',16);
ylabel('Sim validation (m^3 s^-^1)','FontSize',16);
plot([0,1300],[0,1300],'r','Linewidth',2);
legend({'Streamflow'},'FontSize',14,'Location','northwest');
legend('boxoff'); box on
set(gca,'LineWidth',1.5);

subplot(2,3,2)
scatter(obsSED66(1:1096),simbestSED(1:1096),40,'filled');
hold on
xlim([0.1,100000]);ylim([0.1,100000]);
xlabel('Obs calibration (tons d^-^1)','FontSize',16);
ylabel('Sim calibration (tons d^-^1)','FontSize',16);
set(gca,'xscale','log');set(gca,'yscale','log');
plot([0.1,100000],[0.1,100000],'r','Linewidth',2);
legend({'Sediment'},'FontSize',14,'Location','northwest');
legend('boxoff');box on;
set(gca,'LineWidth',1.5);

subplot(2,3,5)
scatter(obsSED66(1097:end),simbestSED(1097:end),40,'filled');
hold on
xlim([0.1,100000]);ylim([0.1,100000]);
xlabel('Obs validation (tons d^-^1)','FontSize',16);
ylabel('Sim validation (tons d^-^1)','FontSize',16);
set(gca,'xscale','log');set(gca,'yscale','log');
plot([0.1,100000],[0.1,100000],'r','Linewidth',2);
legend({'Sediment'},'FontSize',14,'Location','northwest');
legend('boxoff');box on;
set(gca,'LineWidth',1.5);

subplot(2,3,3)
scatter(obsHMTOT66(1:39),simbestHMTOT(1:39),40,'filled');
hold on
xlim([1,50000]);ylim([1,50000]);
xlabel('Obs calidation (kg d^-^1)','FontSize',16);
ylabel('Sim calidation (kg d^-^1)','FontSize',16);
set(gca,'xscale','log');set(gca,'yscale','log');
set(gca,'Xtick',[1,100,10000]);
set(gca,'Ytick',[1,100,10000]);
plot([1,50000],[1,50000],'r','Linewidth',2);
legend({'Total Zn load'},'FontSize',14,'Location','northwest');
legend('boxoff'); box on
set(gca,'LineWidth',1.5);

subplot(2,3,6)
scatter(obsHMTOT66(40:end),simbestHMTOT(40:end),40,'filled');
hold on
xlim([1,50000]);ylim([1,50000]);
xlabel('Obs validation (kg d^-^1)','FontSize',16);
ylabel('Sim validation (kg d^-^1)','FontSize',16);
set(gca,'xscale','log');set(gca,'yscale','log');
set(gca,'Xtick',[1,100,10000]);
set(gca,'Ytick',[1,100,10000]);
plot([1,50000],[1,50000],'r','Linewidth',2);
legend({'Total Zn load'},'FontSize',14,'Location','northwest');
legend('boxoff'); box on
set(gca,'LineWidth',1.5);

[kge([obsFLOW66(1:1096),simbestFLOW(1:1096)]), ...
corr(obsFLOW66(1:1096),simbestFLOW(1:1096))^2, ...
nscoeff([obsFLOW66(1:1096),simbestFLOW(1:1096)]), ...
pbias([obsFLOW66(1:1096),simbestFLOW(1:1096)]), ...
kge([obsFLOW66(1097:end),simbestFLOW(1097:end)]), ...
corr(obsFLOW66(1097:end),simbestFLOW(1097:end))^2, ...
nscoeff([obsFLOW66(1097:end),simbestFLOW(1097:end)]), ...
pbias([obsFLOW66(1097:end),simbestFLOW(1097:end)]); ...
kge([obsSED66(1:1096),simbestSED(1:1096)]), ...
corr(obsSED66(1:1096),simbestSED(1:1096))^2, ...
nscoeff([obsSED66(1:1096),simbestSED(1:1096)]), ...
pbias([obsSED66(1:1096),simbestSED(1:1096)]), ...
kge([obsSED66(1097:end),simbestSED(1097:end)]), ...
corr(obsSED66(1097:end),simbestSED(1097:end))^2, ...
nscoeff([obsSED66(1097:end),simbestSED(1097:end)]), ...
pbias([obsSED66(1097:end),simbestSED(1097:end)]); ...
kge([obsHMTOT66(1:39),simbestHMTOT(1:39)]), ...
corr(obsHMTOT66(1:39),simbestHMTOT(1:39))^2, ...
nscoeff([obsHMTOT66(1:39),simbestHMTOT(1:39)]), ...
pbias([obsHMTOT66(1:39),simbestHMTOT(1:39)]), ...
kge([obsHMTOT66(40:end),simbestHMTOT(40:end)]),  ...
corr(obsHMTOT66(40:end),simbestHMTOT(40:end))^2,  ...
nscoeff([obsHMTOT66(40:end),simbestHMTOT(40:end)]),  ...
pbias([obsHMTOT66(40:end),simbestHMTOT(40:end)])]

[pp(1,1),rr(1,1)]=prfactor(quantile(FLOWOUT66(1:1096,:)',0.975), ...
    quantile(FLOWOUT66(1:1096,:)',0.025), obsFLOW66(1:1096,:),0.1);
[pp(1,2),rr(1,2)]=prfactor(quantile(FLOWOUT66(1097:end,:)',0.975), ...
    quantile(FLOWOUT66(1097:end,:)',0.025), obsFLOW66(1097:end,:),0.1);
[pp(2,1),rr(2,1)]=prfactor(quantile(SEDOUT66(1:1096,:)',0.975), ...
    quantile(SEDOUT66(1:1096,:)',0.025), obsSED66(1:1096,:),0.2);
[pp(2,2),rr(2,2)]=prfactor(quantile(SEDOUT66(1097:end,:)',0.975), ...
    quantile(SEDOUT66(1097:end,:)',0.025), obsSED66(1097:end,:),0.2);
[pp(3,1),rr(3,1)]=prfactor(quantile(HMTOTOUT66(obsHMTOT66_idx(1:39),:)',0.975), ...
    quantile(HMTOTOUT66(obsHMTOT66_idx(1:39),:)',0.025), obsHMTOT66(1:39),0.3);
[pp(3,2),rr(3,2)]=prfactor(quantile(HMTOTOUT66(obsHMTOT66_idx(40:end),:)',0.975), ...
    quantile(HMTOTOUT66(obsHMTOT66_idx(40:end),:)',0.025), obsHMTOT66(40:end),0.3);