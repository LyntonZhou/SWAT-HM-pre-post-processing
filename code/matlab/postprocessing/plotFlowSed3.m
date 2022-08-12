%% Import the data
clc
clear
close all

% initialization
txtiodir = 'D:\XiangRiverProject\XiangRiver\XRB210528V2_2.Sufi2.SwatCup';
% txtiodir = 'D:\XiangRiverProject\XiangRiver\XRB210528V2_1.Sufi2.SwatCup-4';
indir = 'D:\XiangRiverProject\XiangRiver\XRB210528V2\Inputs';
outdir = 'D:\XiangRiverProject\XiangRiver\XRB210528V2\Outputs\figs\figV2_2\fig3';
outdir = 'D:\XiangRiverProject\XiangRiver\XRB210528V2\Outputs\figs\final0504-5';
shapdir ='D:\XiangRiverProject\XiangRiver\XRB210528V2\Watershed\Shapes';
mkdir(outdir)

%% read file.cio
[iprint,nyskip,SubNo,HruNo] = readfilecio(txtiodir);
proj = readcio([txtiodir '\file.cio']);
proj = readsub(txtiodir,proj);
Simlength = 12*(proj.NBYR-proj.NYSKIP);
kk = 0;
for ii= (proj.IYR+proj.NYSKIP):(proj.IYR+proj.NBYR-1)
    for jj=1:12
        kk = kk +1;
        lastdayofmonth(kk,1) = ii;
        lastdayofmonth(kk,2) = jj;
        lastdayofmonth(kk,3) = eomday(ii,jj);
    end
end

%% pcp
[pcpD,pcpDate] = readpcp([txtiodir '\pcp1.pcp']);
idx=ismember(pcpDate,proj.ymd(:,[1,4]));
[~,pcpM,~,~,pcp_YM]=DailyToMonthly1(pcpD(idx(:,1),:),proj.ymd);

%% observations
[FlowStations,txt1] = xlsread([indir '\湘江流量泥沙数据_泥沙浓度20220503.xls'],'流量终');
[SedStations,txt2] = xlsread([indir '\湘江流量泥沙数据_泥沙浓度20220503.xls'],'泥沙浓度终');
[ConcStations,txt3] = xlsread([indir '\湘江断面水质20210528.xls'],'浓度终');

[ObsFlow,SubLoc1] = makeObs(indir,FlowStations(:,9:10),FlowStations(:,12:end),txt1(1,12:end));
[ObsSed,SubLoc2] = makeObs(indir,SedStations(:,9:10),SedStations(:,12:end),txt2(1,12:end));
[ObsConc,SubLoc3] = makeObs(indir,ConcStations(:,1:2),ConcStations(:,3:end),txt3(1,6:end));

% 小流域站点subbasin 校正
SubLoc1(1)=1017; % 兴安
% SubLoc1(12)=983; % 道县
SubLoc1(24)=792; % 寨前
SubLoc1(39)=67; % 双江口

% SubLoc2(2)=983;  % 道县
% SubLoc2(4)=904; % 飞仙
SubLoc2(6)=792;% 寨前
SubLoc2(10)=67; % 双江口

SubLoc3(2)=145;
SubLoc3(9)=172;

%% simulations
yearS=proj.IYR+proj.NYSKIP; yearE=proj.IYR+proj.NBYR-1;

outputsub = readoutputsub2(txtiodir,proj.IPRINT);
outputrch = readoutputrch2(txtiodir,proj.IPRINT);
outputsub = outputsub(outputsub.MON<=12,:);
outputrch = outputrch(outputrch.MON<=12,:);
rchdata = outputrch(:,2:end);
subdata = outputsub(:,[2:4,6:end]);
Sim = table2array(rchdata);
SimSub = table2array(subdata);

kk =0;
for ii= (proj.IYR+proj.NYSKIP):(proj.IYR+proj.NBYR-1)
    for jj =1:12
        for nn = 1:SubNo
            kk=kk+1;
            Sim(kk,2) = ii;
            SimSub(kk,2) = ii;
        end
    end
end
SimSub((SubNo*Simlength+1):end,:)=[];
Sim((SubNo*Simlength+1):end,:)=[];
SimSed=permute(reshape(Sim(:,[2,3,11]),SubNo,Simlength,3),[2 3 1]);
SimFlow=permute(reshape(Sim(:,[2,3,6]),SubNo,Simlength,3),[2 3 1]);

figure
subplot(2,1,1)
plot(SimSub(SimSub(:,1)==1,13))
xlim([-1,111]);
xticks([1:12:109]);
xticklabels({'2007','2008','2009','2010','2011','2012','2013','2014','2015','2016'});
set(gca,'yscale','log');
subplot(2,1,2)
plot(ObsSed(:,3))
xlim([-1,111]);
xticks([1:12:109]);
xticklabels({'2007','2008','2009','2010','2011','2012','2013','2014','2015','2016'});
set(gca,'yscale','log');

figure
hold on
% colorrand=rand(numel(SedStations(:,1)),3);
load colorsed
plot([10^-1,10^3],[10^-1,10^3],'k','linewidth',2);
xlim([10^-1,10^3]);ylim([10^-1,10^3]);
set(gca,'xscale','log');
set(gca,'yscale','log');
ObsSimSed=[];
for ii=1:numel(SedStations(:,1))
    if sum(~isnan(ObsSed(:,ii+2)))< 1
        
    else
        Lia = ismember(SimSed(:,1:2,SubLoc2(ii,1)),ObsSed(:,1:2));
        Lib = ismember(ObsSed(:,1:2),SimSed(:,1:2,SubLoc2(ii,1)));
        Lic = ismember(lastdayofmonth(:,1:2),ObsSed(:,1:2));
        leg(ii) = scatter(ObsSed(Lib(:,1),ii+2),SimSed(Lia(:,1),3,SubLoc2(ii,1)),30,[colorsed(ii,:)],'filled');
        ObsSimSed=[ObsSimSed;[ObsSed(Lib(:,1),ii+2),SimSed(Lia(:,1),3,SubLoc2(ii,1)),ones(sum(Lia(:,1)),1)*SubLoc2(ii,1)]];
    end
end
corr(ObsSimSed(~isnan(ObsSimSed(:,1)),1:2))
pbias(ObsSimSed(~isnan(ObsSimSed(:,1)),1:2))
csvwrite([outdir '\ObsSimSed.csv'],ObsSimSed)

xlabel('实测月泥沙','fontsize',16);ylabel('模拟月泥沙','fontsize',16);
xlabel('observed sediment load','fontsize',16);ylabel('simulated sediment load','fontsize',16);
legend(leg,txt2{2:end,5},'Location','southeast');
legend boxoff;
box on; grid on;
saveas(gca,[outdir '\Sed_Stations-all.tif']);
saveas(gca,[outdir '\Sed_Stations-all.fig']);

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
    if sum(~isnan(ObsFlow(:,ii+2)))< 1
        
    else
        Lia = ismember(SimFlow(:,1:2,SubLoc1(ii,1)),ObsFlow(:,1:2));
        Lib = ismember(ObsFlow(:,1:2),SimFlow(:,1:2,SubLoc1(ii,1)));
        leg(ii) = scatter(ObsFlow(Lib(:,1),ii+2),SimFlow(Lia(:,1),3,SubLoc1(ii,1)),30,[colorflow(ii,:)],'filled');
        ObsSimFlow=[ObsSimFlow;[ObsFlow(Lib(:,1),ii+2),SimFlow(Lia(:,1),3,SubLoc1(ii,1)),ones(sum(Lia(:,1)),1)*SubLoc1(ii,1)]];
    end
end

corr(ObsSimFlow(~isnan(ObsSimFlow(:,1)),1:2))
csvwrite([outdir '\ObsSimFlow.csv'],ObsSimFlow)

% legend(leg,txt{2:end,4},'Location','southeast','fontsize',12);
box on; grid on;
xlabel('实测月流量','fontsize',24);ylabel('模拟月流量','fontsize',16);
xlabel('observed streamflow','fontsize',16);ylabel('simulated streamflow','fontsize',16);
legend(leg,txt1{2:end,5},'Location','eastoutside');
legend(leg(1:22),txt1{2:23,5},'Location','northwest');
legend boxoff;
ah=axes('position',get(gca,'position'),...
    'visible','off');
legend(ah,leg(23:42),txt1{24:end,4},'location','southeast');
legend boxoff;
saveas(gca,[outdir '\FLow_Stations-all.tif']);
saveas(gca,[outdir '\FLow_Stations-all.fig']);

for ii=1:numel(FlowStations(:,1))
    if sum(~isnan(ObsFlow(:,ii+2)))< 1
        
    else
        figure
        subplot(2,2,3)
        hold on
        plot([10^-2,10^5],[10^-2,10^5],'k','linewidth',2);
        plot([10^-2,0.2*10^5],[10^-2*5,10^5],'k','linewidth',2);
        plot([5*10^-2,10^5],[10^-2,0.2*10^5],'k','linewidth',2);
        
        xlim([10^-2,10^5]);ylim([10^-2,10^5]);
        set(gca,'Xtick',[10^-2,10^0,10^2,10^4]);
        set(gca,'Ytick',[10^-2,10^0,10^2,10^4]);        
        set(gca,'xscale','log');
        set(gca,'yscale','log');
        Lia = ismember(SimFlow(:,1:2,SubLoc1(ii,1)),ObsFlow(:,1:2));
        Lib = ismember(ObsFlow(:,1:2),SimFlow(:,1:2,SubLoc1(ii,1)));
        scatter(ObsFlow(Lib(:,1),ii+2),SimFlow(Lia(:,1),3,SubLoc1(ii,1)),30,'filled');
        xlabel('Observed');ylabel('Simulated');
        set(gca,'linewidth',2);
        box on;
        
        subplot(2,2,[1,2])
        hold on
        set(gca,'linewidth',2);
        h1=plot(ObsFlow(Lib(:,1),ii+2),'-','Linewidth',2,'Color',[55,126,184]/256);
        h2=plot(SimFlow(Lia(:,1),3,SubLoc1(ii,1)),'-','Linewidth',2,'Color',[228,26,28]/256);
        %         set(gca,'yscale','log');
        legend([h1,h2],'Observed','Simulated','Location','west');  legend boxoff;
        xlim([-1,111]); ylim([0,2*max(max(ObsFlow(:,ii+2)),max(SimFlow(Lia(:,1),3,SubLoc1(ii,1))))]);
        xticks([1:12:109]);
        xticklabels({'2007','2008','2009','2010','2011','2012','2013','2014','2015','2016'});
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
        legend([h3],'Precipitation','Location','east'); legend boxoff;
        
        subplot(2,2,4)
        xx = [ObsFlow(Lib(:,1),ii+2),SimFlow(Lia(:,1),3,SubLoc1(ii,1))];
        idx = isnan(xx(:,1));
        xx(idx,:)=[];
        ns = nscoeff( xx );
        pb = pbias( xx );
        rr = corr(xx(:,1),xx(:,2))^2;
        modelflowstat(ii,1)=rr;
        modelflowstat(ii,2)=ns;
        modelflowstat(ii,3)=pb;
        annotation('textbox', [0.58,0.32,0.10,0.10],...
            'String',['Sub ' num2str(SubLoc1(ii,1)) ': ' txt1{ii+1,5}],'fontsize',10, 'EdgeColor','none');
        annotation('textbox', [0.58,0.24,0.1,0.1],...
            'String',['R^2= ' num2str(roundn(rr,-2))],'fontsize',10, 'EdgeColor','none');
        annotation('textbox', [0.58,0.16,0.1,0.1],...
            'String',['NSE= ' num2str(roundn(ns,-2))],'fontsize',10, 'EdgeColor','none');
        annotation('textbox', [0.58,0.08,0.1,0.1],...
            'String',['PBIAS= ' num2str(roundn(pb*100,-2)) '%'],'fontsize',10, 'EdgeColor','none');
        set(gca, 'xticklabels', '');set(gca, 'yticklabels', '');
        box on;
        saveas(gca,[outdir '\FLow_Stations-' num2str(ii) '.jpg']);
        close  all
    end
end
xlswrite([outdir '\modelstats.xls'],modelflowstat,'Flow')

for ii=1:numel(SedStations(:,1))
    if sum(~isnan(ObsSed(:,ii+2)))< 1
        
    else
        figure
        subplot(2,2,3)
        hold on
        plot([10^-1,10^8],[10^-1,10^8],'k','linewidth',2);
        plot([10^-1,0.2*10^8],[10^-1*5,10^8],'k','linewidth',2);
        plot([5*10^-1,10^8],[10^-1,0.2*10^8],'k','linewidth',2);
        
        xlim([10^-1,10^8]);ylim([10^-1,10^8]);
        set(gca,'Xtick',[10^0,10^2,10^4,10^6,10^8]);
        set(gca,'Ytick',[10^0,10^2,10^4,10^6,10^8]);
%         set(gca,'XTickLabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'},'FontSize',12);
        set(gca,'xscale','log');
        set(gca,'yscale','log');
%         grid on;
        Lia = ismember(SimSed(:,1:2,SubLoc2(ii,1)),ObsSed(:,1:2));
        Lib = ismember(ObsSed(:,1:2),SimSed(:,1:2,SubLoc2(ii,1)));
        s1=scatter(ObsSed(Lib(:,1),ii+2)*86.4.*lastdayofmonth(Lic(:,1),3),SimSed(Lia(:,1),3,SubLoc2(ii,1)),30,'filled');
%         s1.MarkerEdgeColor = 'b';
%         s1.MarkerFaceColor = 'b';
%         s2=scatter(ObsSed(:,ii+2)*86.4.*lastdayofmonth(Lic(:,1),3),SimSed2(Lia(:,1),3,SubLoc2(ii,1)),55,'filled');
%         s2.MarkerEdgeColor = 'g';
%         s2.MarkerFaceColor = 'g';
        xlabel('Observed');ylabel('Simulated');
%         set(gca,'linewidth',2);
        box on;
        
        subplot(2,2,[1,2])
        hold on
        set(gca,'linewidth',2);
        h1=plot(ObsSed(Lib(:,1),ii+2)*86.4.*lastdayofmonth(Lic(:,1),3),'-','Linewidth',2,'Color',[55,126,184]/256);
        h2=plot(SimSed(Lia(:,1),3,SubLoc2(ii,1)),'-','Linewidth',2,'Color',[228,26,28]/256);
%         h3=plot(SimSed2(Lia(:,1),3,SubLoc2(ii,1)),'--','Linewidth',2,'Color',[77,175,74]/256);
%         plot(SimSed2(SubLoc2(ii,1),1:end),'g');
        legend([h1,h2],'Observed','Simulated','Location','west');  legend boxoff;
        set(gca,'yscale','log');
        xlim([-1,111]); ylim([0,2*max(max(ObsSed(:,ii+2)*86.4.*lastdayofmonth(Lic(:,1),3)),max(SimSed(Lia(:,1),3,SubLoc2(ii,1))))]);
%         xlim([-1,38]); ylim([0,2*max(max(ObsSed(:,ii+2)*86.4.*lastdayofmonth(Lic(:,1),3)),max(SimSed(Lia(:,1),3,SubLoc2(ii,1))))]);
        xticks([1:12:109]);
        xticklabels({'2007','2008','2009','2010','2011','2012','2013','2014','2015','2016'});
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
        legend([h3],'Precipitation','Location','east'); legend boxoff;
        
        subplot(2,2,4)
        xx = [ObsSed(Lib(:,1),ii+2)*86.4.*lastdayofmonth(Lic(:,1),3),SimSed(Lia(:,1),3,SubLoc2(ii,1))];
        idx = isnan(xx(:,1));
        xx(idx,:)=[];
        ns = nscoeff( xx );
        pb = pbias( xx );
        rr = corr(xx(:,1),xx(:,2))^2;
        modelsedstat(ii,1)=rr;
        modelsedstat(ii,2)=ns;
        modelsedstat(ii,3)=pb;
        annotation('textbox', [0.58,0.32,0.10,0.10],...
            'String',['Sub ' num2str(SubLoc2(ii,1)) ': ' txt2{ii+1,5}],'fontsize',10, 'EdgeColor','none');
        annotation('textbox', [0.58,0.24,0.1,0.1],...
            'String',['R^2= ' num2str(roundn(rr,-2))],'fontsize',10, 'EdgeColor','none');
        annotation('textbox', [0.58,0.16,0.1,0.1],...
            'String',['NSE= ' num2str(roundn(ns,-2))],'fontsize',10, 'EdgeColor','none');
        annotation('textbox', [0.58,0.08,0.1,0.1],...
            'String',['PBIAS= ' num2str(roundn(pb*100,-2)) '%'],'fontsize',10, 'EdgeColor','none');      
        set(gca, 'xticklabels', '');set(gca, 'yticklabels', '');
        box on;
        saveas(gca,[outdir '\Sed_Stations1-' num2str(ii) '.jpg']);
        close  all
    end
end
xlswrite([outdir '\modelstats.xls'],modelsedstat,'Sed')