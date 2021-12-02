%% Import the data
clc
clear
close all

% initialization
txtiodir = 'D:\XiangRiverProject\XiangRiver\XRB210528V2.Sufi2.SwatCup';
indir = 'D:\XiangRiverProject\XiangRiver\XRB210528V2\Inputs';
outdir = 'D:\XiangRiverProject\XiangRiver\XRB210528V2\Outputs\figs\fig2';
mkdir(outdir)

%% read file.cio
[iprint,nyskip,SubNo,HruNo] = readfilecio(txtiodir);
proj = readcio([txtiodir '\file.cio']);
proj = readsub(txtiodir,proj);
Simlength = 12*(proj.NBYR-proj.NYSKIP);

%% pcp
[pcpD,pcpDate] = readpcp([txtiodir '\pcp1.pcp']);
idx=ismember(pcpDate,proj.ymd(:,[1,4]));
[~,pcpM,~,~,pcp_YM]=DailyToMonthly1(pcpD(idx(:,1),:),proj.ymd);

%% observations
[FlowStations,txt1] = xlsread([indir '\湘江流量泥沙数据20210513.xls'],'流量终');
[SedStations,txt2] = xlsread([indir '\湘江流量泥沙数据20210513.xls'],'泥沙终');
[ConcStations,txt3] = xlsread([indir '\湘江断面水质20210528.xls'],'浓度终');

[ObsFlow,SubLoc1] = makeObs(indir,FlowStations(:,8:9),FlowStations(:,11:end),txt1(1,11:end));
[ObsSed,SubLoc2] = makeObs(indir,SedStations(:,8:9),SedStations(:,11:end),txt2(1,11:end));
[ObsConc,SubLoc3] = makeObs(indir,ConcStations(:,1:2),ConcStations(:,3:end),txt3(1,5:end));
% SubLoc1(1)=540;
SubLoc3(2)=145;
SubLoc3(9)=172;

%% simulations
yearS=2000; yearE=2015;

outhmlsub = readouthmlsub(txtiodir,iprint);
outputsub = readoutputsub2(txtiodir,iprint,SubNo,Simlength);
outputrch = readoutputrch2(txtiodir,iprint,SubNo,Simlength);
outhmlrch = readouthmlrch(txtiodir,iprint,SubNo,Simlength);
filename = [indir '\Xiang_industry_sub_monthly_Cd.csv'];
metalpoint = readpointsource2(filename,SubNo);
metalpoint = metalpoint(metalpoint.YEAR>=yearS,:);
% outputsub = outputsub(outputsub.YEAR>=yearS & outputsub.YEAR<=yearE,:);
outhmlrch = outhmlrch(outhmlrch.YEAR>=yearS & outhmlrch.YEAR<=yearE,:);
% outputrch = outputrch(outputrch.YEAR>=yearS & outputrch.YEAR<=yearE,:);
rchdata = [outputrch(:,2:end),outhmlrch(:,5:end),metalpoint(:,4)];
% rchdata.DisCONC = table2array(rchdata(:,15))./table2array(rchdata(:,6))*1000*1000/86400/30; % ug/L;
rchdata.DisCONC = (table2array(rchdata(:,15))+table2array(rchdata(:,16)))./table2array(rchdata(:,6))*1000*1000/86400/30; % ug/L;
% rchdata.DisCONC = (table2array(rchdata(:,15))+table2array(rchdata(:,16))+table2array(rchdata(:,17)))./table2array(rchdata(:,6))*1000*1000/86400/30; % ug/L;
rchDisCONC = rchdata.DisCONC;

% outputsub = outputsub(outputsub.YEAR>=yearS & outputsub.YEAR<=yearE & outputsub.MON<13,:);
outhmlsub = outhmlsub(outhmlsub.YEAR>=yearS & outhmlsub.YEAR<=yearE & outhmlsub.MON<13,:);
subdata = [outputsub(:,2:end),outhmlsub(:,5:end),metalpoint(:,4)];
subdata.sy = table2array(subdata(:,14)).*table2array(subdata(:,4))*100; % t/month;

Sim = table2array(rchdata);
Sim2 = table2array(subdata);

SimSed=permute(reshape(Sim(:,[2,3,10]),SubNo,Simlength,3),[2 3 1]);
SimSed2=permute(reshape(Sim(:,[2,3,9]),SubNo,Simlength,3),[2 3 1]);
SimSed3=permute(reshape(Sim2(:,[2,3,33]),SubNo,Simlength,3),[2 3 1]);
SimFlow=permute(reshape(Sim(:,[2,3,6]),SubNo,Simlength,3),[2 3 1]);
SimConc=permute(reshape(Sim(:,[2,3,26]),SubNo,Simlength,3),[2 3 1]);

% metal plot 1
figure
hold on
% colorrand=rand(numel(SedStations(:,1)),3);
load colorsed
plot([10^-2,10^2],[10^-2,10^2],'k','linewidth',2);
xlim([10^-2,10^2]);ylim([10^-2,10^2]);
set(gca,'xscale','log');
set(gca,'yscale','log');
ObsSimConc=[];
for ii=1:numel(ConcStations(:,1))
    if isnan(ObsConc(1,ii+2))
        
    else
        Lia = ismember(SimConc(:,1:2,SubLoc3(ii,1)),ObsConc(:,1:2));
        Lib = ismember(ObsConc(:,1:2),SimConc(:,1:2,SubLoc3(ii,1)));
        leg(ii) = scatter(ObsConc(Lib(:,1),ii+2),SimConc(Lia(:,1),3,SubLoc3(ii,1)),65,[colorsed(ii,:)],'filled');
        ObsSimConc = [ObsSimConc;[ObsConc(Lib(:,1),ii+2),SimConc(Lia(:,1),3,SubLoc3(ii,1)),ones(sum(Lia(:,1)),1)*SubLoc3(ii,1)]];
     end
end
corr(ObsSimConc(~isnan(ObsSimConc(:,1)),1:2))
csvwrite([outdir '\ObsSimConc.csv'],ObsSimConc)

xlabel('实测浓度 (ug/L)','fontsize',24);ylabel('模拟浓度 (ug/L)','fontsize',24);
legend(leg,txt3{2:end,1},'Location','northwest');
legend boxoff;
box on; grid on;
saveas(gca,[outdir '\Conc_Stations-all.tif']);

% metal plot 2
figure
for ii=1:numel(ConcStations(:,1))
    subplot(3,4,ii)
    if isnan(ObsConc(1,ii+2))
        
    else
        Lia = ismember(SimConc(:,1:2,SubLoc3(ii,1)),ObsConc(:,1:2));
        Lib = ismember(ObsConc(:,1:2),SimConc(:,1:2,SubLoc3(ii,1)));
        boxplot([ObsConc(Lib(:,1),ii+2),SimConc(Lia(:,1),3,SubLoc3(ii,1))],'Labels',{'Obs','Sim'},'PlotStyle','compact','Whisker',3,'Width',1);
        ylabel(txt3{ii+1,1});
        set(gca,'LineWidth',2,'FontSize',20);
     end
end
saveas(gca,[outdir '\Conc_Stations1-all.tif']);

figure
hold on
% colorrand=rand(numel(SedStations(:,1)),3);
load colorsed
plot([1,10^8],[1,10^8],'k','linewidth',2);
xlim([1,10^8]);ylim([1,10^8]);
set(gca,'xscale','log');
set(gca,'yscale','log');
ObsSimSed=[];
for ii=1:numel(SedStations(:,1))
    if isnan(ObsSed(1,ii+2))
        
    else
        Lia = ismember(SimSed(:,1:2,SubLoc2(ii,1)),ObsSed(:,1:2));
        leg(ii) = scatter(ObsSed(:,ii+2)*86.4*30,SimSed(Lia(:,1),3,SubLoc2(ii,1)),45,[colorsed(ii,:)],'filled');
        ObsSimSed=[ObsSimSed;[ObsSed(:,ii+2)*86.4*30,SimSed(Lia(:,1),3,SubLoc2(ii,1)),ones(sum(Lia(:,1)),1)*SubLoc2(ii,1)]];
    end
end
corr(ObsSimSed(~isnan(ObsSimSed(:,1)),1:2))
csvwrite([outdir '\ObsSimSed.csv'],ObsSimSed)

xlabel('实测月泥沙','fontsize',24);ylabel('模拟月泥沙','fontsize',24);
legend(leg,txt2{2:end,4},'Location','southeast');
legend boxoff;
box on; grid on;
saveas(gca,[outdir '\Sed_Stations-all.tif']);

% residual analysis
figure
hold on
% colorrand=rand(numel(SedStations(:,1)),3);
load colorsed
% plot([1,10^8],[1,10^8],'k','linewidth',2);
for ii=1:numel(SedStations(:,1))
    if isnan(ObsSed(1,ii+2))
        
    else
        leg(ii) = scatter(SimSed(Lia(:,1),3,SubLoc2(ii,1)), ...
            (ObsSed(:,ii+2)*86.4*30-SimSed(Lia(:,1),3,SubLoc2(ii,1))),45,[colorsed(ii,:)],'filled');
    end
end
xlim([1,10^8]);%ylim([1,10^8]);
set(gca,'xscale','log');
set(gca,'yscale','log');
xlabel('模拟月泥沙','fontsize',24);ylabel('月泥沙残差','fontsize',24);
legend(leg,txt1{2:end,4},'Location','southeast');
legend boxoff;
box on; grid on;
saveas(gca,[outdir '\Sed_Stations_residual-all.tif']);

figure
hold on
% colorflow=rand(numel(FlowStations(:,1)),3);
load colorflow
plot([10^-2,10^5],[10^-2,10^5],'k','linewidth',2);
xlim([10^-2,10^5]);ylim([10^-2,10^5]);
set(gca,'xscale','log');
set(gca,'yscale','log');
leg=[];
ObsSimFlow=[];
for ii=1:numel(FlowStations(:,1))
    if isnan(ObsFlow(1,ii+2))
        
    else
        Lia = ismember(SimFlow(:,1:2,SubLoc1(ii,1)),ObsFlow(:,1:2));
        leg(ii) = scatter(ObsFlow(:,ii+2),SimFlow(Lia(:,1),3,SubLoc1(ii,1)),45,[colorflow(ii,:)],'filled');
        ObsSimFlow=[ObsSimFlow;[ObsFlow(:,ii+2),SimFlow(Lia(:,1),3,SubLoc1(ii,1)),ones(sum(Lia(:,1)),1)*SubLoc1(ii,1)]];
    end
end

corr(ObsSimFlow(~isnan(ObsSimFlow(:,1)),1:2))
csvwrite([outdir '\ObsSimFlow.csv'],ObsSimFlow)

% legend(leg,txt{2:end,4},'Location','southeast','fontsize',12);
box on; grid on;
xlabel('实测月流量','fontsize',24);ylabel('模拟月流量','fontsize',24);
legend(leg,txt1{2:end,4},'Location','eastoutside');
legend(leg(1:22),txt1{2:23,4},'Location','northwest');
legend boxoff;
ah=axes('position',get(gca,'position'),...
    'visible','off');
legend(ah,leg(23:45),txt1{24:end,4},'location','southeast');
legend boxoff;
saveas(gca,[outdir '\FLow_Stations-all.tif']);

% residual analysis
figure
hold on
load colorflow
% plot([10^-2,10^5],[10^-2,10^5],'k','linewidth',2);
xlim([10^-2,10^5]);%ylim([10^-2,10^5]);
set(gca,'xscale','log');
% set(gca,'yscale','log');
leg=[];
for ii=1:numel(FlowStations(:,1))
    if isnan(ObsFlow(1,ii+2))
        
    else
        leg(ii) = scatter(SimFlow(Lia(:,1),3,SubLoc1(ii,1)), ...
            (ObsFlow(:,ii+2)-SimFlow(Lia(:,1),3,SubLoc1(ii,1))),45,[colorflow(ii,:)],'filled');
    end
end

% legend(leg,txt{2:end,4},'Location','southeast','fontsize',12);
box on; grid on;
xlabel('模拟月流量','fontsize',16);ylabel('月流量残差','fontsize',16);
% legend(leg,txt{2:end,4},'Location','eastoutside');
legend(leg(1:22),txt1{2:23,4},'Location','northwest');
legend boxoff;
ah=axes('position',get(gca,'position'),...
    'visible','off');
legend(ah,leg(23:45),txt1{24:46,4},'location','southeast');
legend boxoff;
saveas(gca,[outdir '\FLow_Stations_Residual-all.tif']);
close  all

for ii=1:numel(FlowStations(:,1))
    if isnan(ObsFlow(1,ii+2))
        
    else
        figure
        subplot(2,2,3)
        hold on
        plot([10^-2,10^5],[10^-2,10^5],'k','linewidth',2);
        plot([10^-2,0.2*10^5],[10^-2*5,10^5],'k','linewidth',2);
        plot([5*10^-2,10^5],[10^-2,0.2*10^5],'k','linewidth',2);
        
        xlim([10^-2,10^5]);ylim([10^-2,10^5]);
        set(gca,'xscale','log');
        set(gca,'yscale','log');
        Lia = ismember(SimFlow(:,1:2,SubLoc1(ii,1)),ObsFlow(:,1:2));
        scatter(ObsFlow(:,ii+2),SimFlow(Lia(:,1),3,SubLoc1(ii,1)),55,'filled');
        set(gca,'linewidth',2);
        box on;
        
        subplot(2,2,[1,2])
        hold on
        set(gca,'linewidth',2);
        h1=plot(ObsFlow(:,ii+2),'-','Linewidth',2,'Color',[55,126,184]/256);
        h2=plot(SimFlow(Lia(:,1),3,SubLoc1(ii,1)),'--','Linewidth',2,'Color',[228,26,28]/256);
        %         set(gca,'yscale','log');
        legend([h1,h2],'实测径流','模拟径流','Location','west');  legend boxoff;
        xlim([-1,99]); ylim([0,2*max(max(ObsFlow(:,ii+2)),max(SimFlow(Lia(:,1),3,SubLoc1(ii,1))))]);
        xticks([1:12:97]);
        xticklabels({'2008','2009','2010','2011','2012','2013','2014','2015','2016'});
        xlabel('Date');
        %         set(ax, 'ytick', 0:200:600);
        ylabel ('Streamflow (m^3/s)');
        ax = axes('Position', get(gca, 'Position'), 'xlim', get(gca, 'xlim'),'ylim',...
            [0 1000], 'YAxisLocation','right', 'XAxisLocation','top','ydir','reverse','Color', 'none');
        set(ax, 'ytick', 0:200:1000);
        set(ax, 'xticklabels', '');
        ylabel ('Precipitation (mm)');
        hold on;
        set(gca,'linewidth',2);
%         plot(pcpM(1:end,proj.IRGAGE(SubLoc1(ii,1))),'g','Parent', ax);
        h3=bar(ax,pcpM(Lia(:,1),proj.IRGAGE(SubLoc1(ii,1))),'FaceColor',[77,175,74]/256);
        legend([h3],'降雨','Location','east'); legend boxoff;
        
        subplot(2,2,4)
        annotation('textbox', [0.6,0.2,0.1,0.1],...
            'String',[txt1{ii+1,4} ' Sub ' num2str(SubLoc1(ii,1))],'fontsize',16);
        set(gca, 'xticklabels', '');set(gca, 'yticklabels', '');
        box on;
        saveas(gca,[outdir '\FLow_Stations-' num2str(ii) '.jpg']);
        close  all
    end
end

for ii=1:numel(SedStations(:,1))
    if isnan(ObsSed(ii,1))
        
    else
        figure
        subplot(2,2,3)
        hold on
        plot([10^-1,10^8],[10^-1,10^8],'k','linewidth',2);
        plot([10^-1,0.2*10^8],[10^-1*5,10^8],'k','linewidth',2);
        plot([5*10^-1,10^8],[10^-1,0.2*10^8],'k','linewidth',2);
        
        xlim([10^-1,10^8]);ylim([10^-1,10^8]);
        set(gca,'xscale','log');
        set(gca,'yscale','log');
        Lia = ismember(SimSed(:,1:2,SubLoc2(ii,1)),ObsSed(:,1:2));
        s1=scatter(ObsSed(:,ii+2)*86.4*30,SimSed(Lia(:,1),3,SubLoc2(ii,1)),55,'filled');
        s1.MarkerEdgeColor = 'r';
        s1.MarkerFaceColor = 'r';
        s2=scatter(ObsSed(:,ii+2)*86.4*30,SimSed2(Lia(:,1),3,SubLoc2(ii,1)),55,'filled');
        s2.MarkerEdgeColor = 'g';
        s2.MarkerFaceColor = 'g';
        set(gca,'linewidth',2);
        box on;
        
        subplot(2,2,[1,2])
        hold on
        set(gca,'linewidth',2);
        h1=plot(ObsSed(:,ii+2)*86.4*30,'-','Linewidth',2,'Color',[55,126,184]/256);
        h2=plot(SimSed(Lia(:,1),3,SubLoc2(ii,1)),'--','Linewidth',2,'Color',[228,26,28]/256);
        h3=plot(SimSed2(Lia(:,1),3,SubLoc2(ii,1)),'--','Linewidth',2,'Color',[77,175,74]/256);
%         plot(SimSed2(SubLoc2(ii,1),1:end),'g');
        legend([h1,h2],'实测泥沙','模拟泥沙','Location','west');  legend boxoff;
%         set(gca,'yscale','log');
        xlim([-1,99]); ylim([0,2*max(max(ObsSed(:,ii+2)*86.4*30),max(SimSed(Lia(:,1),3,SubLoc2(ii,1))))]);
        xticks([1:12:97]);
        xticklabels({'2008','2009','2010','2011','2012','2013','2014','2015','2016'});
        xlabel('Date');
        ylabel ('Sediment (Tons)');
        ax = axes('Position', get(gca, 'Position'), 'xlim', get(gca, 'xlim'),'ylim',...
            [0 1000], 'YAxisLocation','right', 'XAxisLocation','top','ydir','reverse','Color', 'none');
        set(ax, 'ytick', 0:200:1000);
        set(ax, 'xticklabels', '');
        ylabel ('Precipitation (mm)');
        hold on;
        set(gca,'linewidth',2);
%         plot(pcpM(1:end,proj.IRGAGE(SubLoc2(ii,1))),'k','Parent', ax);
        h3=bar(ax,pcpM(Lia(:,1),proj.IRGAGE(SubLoc2(ii,1))),'FaceColor',[77,175,74]/256);
        legend([h3],'降雨','Location','east'); legend boxoff;
        
        subplot(2,2,4)
        annotation('textbox', [0.6,0.2,0.1,0.1],...
            'String',[txt2{ii+1,4} ' Sub ' num2str(SubLoc2(ii,1))],'fontsize',16);
        set(gca, 'xticklabels', '');set(gca, 'yticklabels', '');
        box on;
        saveas(gca,[outdir '\Sed_Stations-' num2str(ii) '.jpg']);
        close  all
    end
end
