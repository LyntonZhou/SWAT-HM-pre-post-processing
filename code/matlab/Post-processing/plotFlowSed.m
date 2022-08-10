%% Import the data
clc
clear
close all

% initialization
txtiodir = 'D:\XiangRiverProject\XiangRiver\XRB210528V2.Sufi2.SwatCup-2';
txtiodir = 'D:\XiangRiverProject\XiangRiver\XRB210528V2_1.Sufi2.SwatCup-4';
indir = 'D:\XiangRiverProject\XiangRiver\XRB210528V2\Inputs';
outdir = 'D:\XiangRiverProject\XiangRiver\XRB210528V2\Outputs\figs\final426-4';
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
[FlowStations,txt1] = xlsread([indir '\湘江流量泥沙数据20220222.xls'],'流量终');
[SedStations,txt2] = xlsread([indir '\湘江流量泥沙数据20220222.xls'],'泥沙终');
[ConcStations,txt3] = xlsread([indir '\湘江断面水质20210528.xls'],'浓度终');

[ObsFlow,SubLoc1] = makeObs(indir,FlowStations(:,9:10),FlowStations(:,12:end),txt1(1,12:end));
[ObsSed,SubLoc2] = makeObs(indir,SedStations(:,9:10),SedStations(:,12:end),txt2(1,12:end));
[ObsConc,SubLoc3] = makeObs(indir,ConcStations(:,1:2),ConcStations(:,3:end),txt3(1,6:end));

% 小流域站点subbasin 校正
SubLoc1(1)=1017; % 兴安
SubLoc1(12)=983; % 道县
SubLoc1(24)=792; % 寨前
SubLoc1(39)=67; % 双江口

SubLoc2(2)=983;  % 道县
% SubLoc2(4)=904; % 飞仙
SubLoc2(6)=792;% 寨前
SubLoc2(10)=67; % 双江口

SubLoc3(2)=145;
SubLoc3(9)=172;

%% simulations
yearS=proj.IYR+proj.NYSKIP; yearE=proj.IYR+proj.NBYR-1;

outhmlsub = readouthmlsub(txtiodir,proj.IPRINT);
outputsub = readoutputsub2(txtiodir,proj.IPRINT);
outputrch = readoutputrch2(txtiodir,proj.IPRINT);
outhmlrch = readouthmlrch(txtiodir,proj.IPRINT);
% filename = [indir '\Xiang_industry_sub_monthly_Cd_TableToExcel.xls'];
filename = [indir '\Xiang_industry_sub_monthly_Cd.xls'];
metalpoint = readpointsource2(filename,SubNo);
metalpoint = metalpoint(metalpoint.YEAR>=yearS & metalpoint.YEAR<=yearE,:);

outputsub = outputsub(outputsub.YEAR>=yearS & outputsub.YEAR<=yearE,:);
outputrch = outputrch(outputrch.YEAR>=yearS & outputrch.YEAR<=yearE,:);
% outputsub = outputsub(outputsub.YEAR>=yearS & outputsub.YEAR<=yearE & outputsub.MON<13,:);

outhmlsub = outhmlsub(outhmlsub.YEAR>=yearS & outhmlsub.YEAR<=yearE & outhmlsub.MON<=12,:);
outhmlrch = outhmlrch(outhmlrch.YEAR>=yearS & outhmlrch.YEAR<=yearE & outhmlrch.MON<=12,:);
rchdata = [outputrch(:,2:end),outhmlrch(:,5:end),metalpoint(:,4)];

outputsub.SoilErosion = outputsub.SYLDtha.*outhmlsub.AREAkm2*100;
soilEdata1 = groupsummary(outputsub,{'YEAR','MON'},'sum',{'SoilErosion'});
soilEdata2 = outputrch(outputrch.RCH==5,:);

rchdata.DisCONC = table2array(rchdata(:,15))./table2array(rchdata(:,6)) ...
    *1000*1000/86400./arrayfun(@eomday,table2array(rchdata(:,2)),table2array(rchdata(:,3))); % ug/L;
 rchdata.DisCONC = (table2array(rchdata(:,15))+table2array(rchdata(:,16)))./table2array(rchdata(:,6)) ...
     *1000*1000/86400./arrayfun(@eomday,table2array(rchdata(:,2)),table2array(rchdata(:,3))); % ug/L;
% rchdata.DisCONC = (table2array(rchdata(:,15))+table2array(rchdata(:,16))+table2array(rchdata(:,17)))./table2array(rchdata(:,6))*1000*1000/86400/30; % ug/L;
rchDisCONC = rchdata.DisCONC;

rchDisCONC = reshape(rchDisCONC,proj.SubNo,Simlength);
kk = 0;
rchLowC =[];
for ii=1:SubNo
    if sum(rchDisCONC(ii,:) < 10^-3)< 1
        kk = kk + 1;
        rchLowC(kk) = ii;
    end
end

for ii=1:SubNo
    for jj=1:Simlength
        if rchDisCONC(ii,jj) < 10^-3
        rchDisCONC(ii,jj) = mean(rchDisCONC(ii,:));
        end
    end
end

order = csvread([indir '\streamorder\order1.csv']);
[~,idx] = sort(order(:,1));
order = order(idx,:);

% save file for R plotting
order2 = repmat(order(:,2),1,12*(yearE-yearS+1));
season =[4,4,1,1,1,2,2,2,3,3,3,4];
season = repmat(season,1,(yearE-yearS+1));
season = repmat(season,1118,1);
conc =[reshape(rchDisCONC,numel(rchDisCONC),1),reshape(season,numel(season),1),reshape(order2,numel(order2),1)];
conc = array2table(conc,'VariableNames',{'conc','Season','order'});
writetable(conc,[indir '\streamorder\conc.csv'])

concarr= table2array(conc);
exceed(1) = sum(concarr(concarr(:,3)==1,1)>=5);
exceed(2) = sum(concarr(concarr(:,3)==2,1)>=5);
exceed(3) = sum(concarr(concarr(:,3)==3,1)>=5);
exceed(4) = sum(concarr(concarr(:,3)==4,1)>=5);
exceed(5) = sum(concarr(concarr(:,3)==5,1)>=5);
idx = find(concarr(:,3)==1|concarr(:,3)==2);
exceed(6) = max(concarr(idx,1));
exceed(7) = min(concarr(idx,1));
idx = find(concarr(:,3)==4|concarr(:,3)==5);
exceed(8) = max(concarr(idx,1));
exceed(9) = min(concarr(idx,1));
xlswrite([outdir '\statsall.xls'], exceed, 'exceed','B2');

rchDisCONCmean=[];
for ii=1:(yearE-yearS+1)
    rchDisCONCmean = [rchDisCONCmean, mean(rchDisCONC(:,((ii-1)*12+1):ii*12),2)];
end
for ii=1:(yearE-yearS+1)
    rchDisCONCmean = [rchDisCONCmean, max(rchDisCONC(:,((ii-1)*12+1):ii*12),[],2)];
end
csvwrite([indir '\streamorder\monthlymeanconc.csv'],rchDisCONCmean)
rchDisCONCmax =[];
for ii=1:4
    for jj =1:1118
        if (sum(rchDisCONC(jj,((ii-1)*48+1):ii*48)>=5.0))>0
            rchDisCONCmax(jj,ii)=1;
        else
            rchDisCONCmax(jj,ii)=0;
        end
    end
end
rchDisCONCmax = array2table(rchDisCONCmax,'VariableNames',{'S1','S2','S3','S4'});
writetable(rchDisCONCmax,[indir '\streamorder\monthlymaxconc.csv'])

figure
scatter(soilEdata1.sum_SoilErosion, soilEdata2.SED_OUTtons)

figure
boxplot(rchDisCONC([960,663,1031,385,85,866,1108,405,35,235,565,423,1084,439,559,580,50,802,84,1102,551,465,121,487],:)')
ax = gca;
ax.YAxis.Scale ="log";

% rchDisCONC([960,663,1031,385,85,866,1108,405,35,235,565,423,1084,439,559,580,50,802,84,1102,551,465,121,487],:) = [];
% order([960,663,1031,385,85,866,1108,405,35,235,565,423,1084,439,559,580,50,802,84,1102,551,465,121,487],:)=[];

data = rchDisCONC(order(order(:,2)==1,1),:);
data1 = reshape(data,numel(data),1);

data = rchDisCONC(order(order(:,2)==2,1),:);
data2 = reshape(data,numel(data),1);

data = rchDisCONC(order(order(:,2)==3,1),:);
data3 = reshape(data,numel(data),1);

data = rchDisCONC(order(order(:,2)==4,1),:);
data4 = reshape(data,numel(data),1);

data = rchDisCONC(order(order(:,2)==5,1),:);
data5 = reshape(data,numel(data),1);

figure
subplot(151)
boxplot(data1)
subplot(152)
boxplot(data2)
subplot(153)
boxplot(data3)
subplot(154)
boxplot(data4)
subplot(155)
boxplot(data5)

[sum(data1>1)/numel(data1)*100,
 sum(data2>1)/numel(data2)*100,
 sum(data3>1)/numel(data3)*100,
 sum(data4>1)/numel(data4)*100,
 sum(data5>1)/numel(data5)*100]

[sum(data1>5),
 sum(data2>5),
 sum(data3>5),
 sum(data4>5),
 sum(data5>5)]

g1 = ones(size(data1)) * 1;
g2 = ones(size(data2)) * 2;
g3 = ones(size(data3)) * 3;
g4 = ones(size(data4)) * 4;
g5 = ones(size(data5)) * 5;

fig = figure
boxplot([data1; data2; data3; data4; data5], [g1; g2; g3; g4; g5], ...
    'Labels', {'order 1', 'order 2', 'order 3', 'order 4', 'order 5'}, ...
    'Whisker',1500)
hold on
p1 = plot([0.5,5.5],[10,10],':','color',[165,15,21]/256,'linewidth',2);
p2 = plot([0.5,5.5],[5,5],'-.','color',[222,45,38]/256,'linewidth',2);
p3 = plot([0.5,5.5],[1,1],'--','color',[252,146,114]/256,'linewidth',2);
ax = gca;
ax.YAxis.Scale ="log";
%set(gca,'LineWidth',2);
ylim([10^-3,100])
legend([p1,p2,p3],'Calss Ⅴ  10.0 \mug/L','Calss  Ⅲ 5.0 \mug/L','Calss Ⅰ  1.0 \mug/L','FontSize',12,'Location','southeast');
xlabel('Stream order','FontSize',16);ylabel('Monthly Cd (\mug/L)','FontSize',16);
saveas(fig,[outdir '\streamorder.tif']);
saveas(fig,[outdir '\streamorder.fig']);

fig = figure
set(gcf, 'Position',  [100, 100, 600, 400])
bo=boxplot([data1; data2; data3; data4; data5], [g1; g2; g3; g4; g5], ...
    'Labels', {'order 1', 'order 2', 'order 3', 'order 4', 'order 5'}, ...
    'Whisker',1500)
set(bo,'Linewidth',2)
set(gca,'FontSize',12)
% mycolormap=[179,85,79;192,100,89;
%             212,177,170;205,222,187;
%             233,242,234;233,237,242;
%             161,186,211;122,155,189;
%             79,103,149;55,71,116]/255;
mycolormap=[192,100,89;
            205,222,187;
            233,237,242;
            122,155,189;
            5,71,116]/255;
h = findobj(gca,'Tag','Box');
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),mycolormap(j,:),'FaceAlpha',.7);
end
hold on
% p1 = plot([0.5,5.5],[10,10],':','color',[165,15,21]/256,'linewidth',2);
p2 = plot([0.5,5.5],[5,5],'-.','color',[222,45,38]/256,'linewidth',3);
% p3 = plot([0.5,5.5],[1,1],'--','color',[252,146,114]/256,'linewidth',2);
ax = gca;
ax.YAxis.Scale ="log";
set(gca,'LineWidth',2);
ylim([10^-3,100])
% legend([p1,p2,p3],'Calss Ⅴ  10.0 \mug/L','Calss  Ⅲ 5.0 \mug/L','Calss Ⅰ  1.0 \mug/L','FontSize',12,'Location','southeast');
legend([p2],'Calss  Ⅲ 5.0 \mug/L','FontSize',14,'Location','southeast');
legend boxoff
xlabel('Stream order','FontSize',18);ylabel('Monthly Cd (\mug/L)','FontSize',18);
saveas(fig,[outdir '\ga-3.tif']);
saveas(fig,[outdir '\ga-3.fig']);

subdata = [outputsub(:,2:end),outhmlsub(:,5:end),metalpoint(:,4)];
% subdata.sy = table2array(subdata(:,14)).*table2array(subdata(:,4))*100; % t/month;

Sim = table2array(rchdata);
Sim2 = table2array(subdata);

SimSed=permute(reshape(Sim(:,[2,3,10]),SubNo,Simlength,3),[2 3 1]);
SimSed2=permute(reshape(Sim(:,[2,3,9]),SubNo,Simlength,3),[2 3 1]);
SimSed3=permute(reshape(Sim2(:,[2,3,33]),SubNo,Simlength,3),[2 3 1]);
SimFlow=permute(reshape(Sim(:,[2,3,6]),SubNo,Simlength,3),[2 3 1]);
SimConc=permute(reshape(Sim(:,[2,3,26]),SubNo,Simlength,3),[2 3 1]);

% metal plot 2
figure
for ii=1:numel(ConcStations(:,1))
    subplot(3,4,ii)
    if sum(~isnan(ObsConc(:,ii+2)))< 1
        
    else
        Lia = ismember(SimConc(:,1:2,SubLoc3(ii,1)),ObsConc(:,1:2));
        Lib = ismember(ObsConc(:,1:2),SimConc(:,1:2,SubLoc3(ii,1)));
        boxplot([ObsConc(Lib(:,1),ii+2),SimConc(Lia(:,1),3,SubLoc3(ii,1))],'Labels',{'Obs','Sim'},'PlotStyle','compact','Whisker',3,'Width',1);
        ylabel(txt3{ii+1,2});
        set(gca,'LineWidth',2,'FontSize',20);
     end
end
saveas(gca,[outdir '\Conc_Stations1-all.tif']);
saveas(gca,[outdir '\Conc_Stations1-all.fig']);

% metal plot 1
figure
hold on
% colorrand=rand(numel(SedStations(:,1)),3);
load colorsed
plot([10^-2,10^2],[10^-2,10^2],'k','linewidth',2);
plot([5*10^-2,10^2],[10^-2,0.2*10^2],'--k','linewidth',2);
plot([10^-2,0.2*10^2],[5*10^-2,10^2],'--k','linewidth',2);
xlim([10^-2,10^2]);ylim([10^-2,10^2]);
set(gca,'xscale','log');
set(gca,'yscale','log');
ObsSimConc=[];
for ii=1:numel(ConcStations(:,1))
    if sum(~isnan(ObsConc(:,ii+2)))< 1
        
    else
        Lia = ismember(SimConc(:,1:2,SubLoc3(ii,1)),ObsConc(:,1:2));
        Lib = ismember(ObsConc(:,1:2),SimConc(:,1:2,SubLoc3(ii,1)));
        leg(ii) = scatter(ObsConc(Lib(:,1),ii+2),SimConc(Lia(:,1),3,SubLoc3(ii,1)),60,'filled');
        ObsSimConc = [ObsSimConc;[ObsConc(Lib(:,1),ii+2),SimConc(Lia(:,1),3,SubLoc3(ii,1)),ones(sum(Lia(:,1)),1)*SubLoc3(ii,1)]];
     end
end
corr(ObsSimConc(~isnan(ObsSimConc(:,1)),1:2))
csvwrite([outdir '\ObsSimConc.csv'],ObsSimConc)
xlswrite([outdir '\statsall.xls'],ObsSimConc,'Conc','B2')

xlabel('实测浓度 (ug/L)','fontsize',20);ylabel('模拟浓度 (ug/L)','fontsize',20);
xlabel('observed Cd (ug/L)','fontsize',16);ylabel('simulated Cd (ug/L)','fontsize',16);
legend(leg,txt3{2:end,2},'Location','northwest');
legend boxoff;
box on; grid on;
saveas(gca,[outdir '\Conc_Stations-all.tif']);
saveas(gca,[outdir '\Conc_Stations-all.fig']);

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
    if sum(~isnan(ObsSed(:,ii+2)))< 1
        
    else
        Lia = ismember(SimSed(:,1:2,SubLoc2(ii,1)),ObsSed(:,1:2));
        Lib = ismember(ObsSed(:,1:2),SimSed(:,1:2,SubLoc2(ii,1)));
        Lic = ismember(lastdayofmonth(:,1:2),ObsSed(:,1:2));
        leg(ii) = scatter(ObsSed(Lib(:,1),ii+2)*86.4.*lastdayofmonth(Lic(:,1),3),SimSed(Lia(:,1),3,SubLoc2(ii,1)),45,[colorsed(ii,:)],'filled');
        ObsSimSed=[ObsSimSed;[ObsSed(Lib(:,1),ii+2)*86.4.*lastdayofmonth(Lic(:,1),3),SimSed(Lia(:,1),3,SubLoc2(ii,1)),ones(sum(Lia(:,1)),1)*SubLoc2(ii,1)]];
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
        leg(ii) = scatter(ObsFlow(Lib(:,1),ii+2),SimFlow(Lia(:,1),3,SubLoc1(ii,1)),45,[colorflow(ii,:)],'filled');
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
legend(ah,leg(23:40),txt1{24:end,4},'location','southeast');
legend boxoff;
saveas(gca,[outdir '\FLow_Stations-all.tif']);

% subplots
figure
set(gcf, 'Position',  [100, 100, 1200, 1000])
subplot(2,4,[6,7])
hold on
% colorrand=rand(numel(SedStations(:,1)),3);
load colorsed
li1=plot([10^-2,10^2],[10^-2,10^2],'k','linewidth',2);
li2=plot([5*10^-2,10^2],[10^-2,0.2*10^2],'--k','linewidth',2);
plot([10^-2,0.2*10^2],[5*10^-2,10^2],'--k','linewidth',2);
li3=plot([10^-1,10^2],[10^-2,10^1],'-.k','linewidth',2);
plot([10^-2,0.1*10^2],[10*10^-2,10^2],'-.k','linewidth',2);
xlim([10^-2,10^2]);ylim([10^-2,10^2]);
set(gca,'xscale','log');
set(gca,'yscale','log');
ObsSimConc=[];
for ii=1:numel(ConcStations(:,1))
    if sum(~isnan(ObsConc(:,ii+2)))< 1
        
    else
        Lia = ismember(SimConc(:,1:2,SubLoc3(ii,1)),ObsConc(:,1:2));
        Lib = ismember(ObsConc(:,1:2),SimConc(:,1:2,SubLoc3(ii,1)));
        leg(ii) = scatter(ObsConc(Lib(:,1),ii+2),SimConc(Lia(:,1),3,SubLoc3(ii,1)),60,'filled');
        ObsSimConc = [ObsSimConc;[ObsConc(Lib(:,1),ii+2),SimConc(Lia(:,1),3,SubLoc3(ii,1)),ones(sum(Lia(:,1)),1)*SubLoc3(ii,1)]];
     end
end
numel(ObsSimConc(:,1)) - sum(isnan(ObsSimConc(:,1)))
box on; grid on;
text(1,50,'(c)','fontsize',16);
xlabel('实测浓度 (ug/L)','fontsize',20);ylabel('模拟浓度 (ug/L)','fontsize',20);
xlabel('Observed Cd (\mug L^{-1})','fontsize',16);ylabel('Simulated Cd (\mug L^{-1})','fontsize',16);
legend(leg,txt3{2:end,2},'Location','northwest','fontsize',7);
legend boxoff;
ah=axes('position',get(gca,'position'),...
    'visible','off');
legend(ah,[li1,li2,li3],{'1:1 line','5-folder line','10-folder line'},'location','southeast');
legend boxoff;

subplot(2,4,[3,4])
hold on
% colorrand=rand(numel(SedStations(:,1)),3);
load colorsed
plot([1,10^8],[1,10^8],'k','linewidth',2);
xlim([1,10^8]);ylim([1,10^8]);
set(gca,'xscale','log');
set(gca,'yscale','log');
ObsSimSed=[];
for ii=1:numel(SedStations(:,1))
    if sum(~isnan(ObsSed(:,ii+2)))< 1
        
    else
        Lia = ismember(SimSed(:,1:2,SubLoc2(ii,1)),ObsSed(:,1:2));
        Lib = ismember(ObsSed(:,1:2),SimSed(:,1:2,SubLoc2(ii,1)));
        leg(ii) = scatter(ObsSed(Lib(:,1),ii+2)*86.4.*lastdayofmonth(Lic(:,1),3),SimSed(Lia(:,1),3,SubLoc2(ii,1)),45,[colorsed(ii,:)],'filled');
        ObsSimSed=[ObsSimSed;[ObsSed(Lib(:,1),ii+2)*86.4.*lastdayofmonth(Lic(:,1),3),SimSed(Lia(:,1),3,SubLoc2(ii,1)),ones(sum(Lia(:,1)),1)*SubLoc2(ii,1)]];
    end
end
numel(ObsSimSed(:,1)) - sum(isnan(ObsSimSed(:,1)))
text(10000,10^7,'(b)','fontsize',16);
xlabel('实测月泥沙','fontsize',16);ylabel('模拟月泥沙','fontsize',16);
xlabel('Observed sediment load (kg)','fontsize',16);ylabel('Simulated sediment load (kg)','fontsize',16);
legend(leg,txt2{2:end,5},'Location','southeast','fontsize',7);
legend boxoff;
box on; grid on;

%figure
subplot(2,4,[1,2])
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
        leg(ii) = scatter(ObsFlow(Lib(:,1),ii+2),SimFlow(Lia(:,1),3,SubLoc1(ii,1)),45,[colorflow(ii,:)],'filled');
        ObsSimFlow=[ObsSimFlow;[ObsFlow(Lib(:,1),ii+2),SimFlow(Lia(:,1),3,SubLoc1(ii,1)),ones(sum(Lia(:,1)),1)*SubLoc1(ii,1)]];
    end
end
numel(ObsSimFlow(:,1)) - sum(isnan(ObsSimFlow(:,1)))
% legend(leg,txt{2:end,4},'Location','southeast','fontsize',12);
box on; grid on;
text(10,10000,'(a)','fontsize',16)
% annotation('textbox', [0.5, 0.2, 0.1, 0.1], 'String', "hi")
xlabel('实测月流量','fontsize',24);ylabel('模拟月流量','fontsize',16);
xlabel('Observed streamflow (m^3 s^{-1})','fontsize',16);ylabel('Simulated streamflow  (m^3 s^{-1})','fontsize',16);
legend(leg,txt1{2:end,5},'Location','eastoutside','fontsize',7);
legend(leg(1:22),txt1{2:23,5},'Location','northwest','fontsize',7);
legend boxoff;
ah=axes('position',get(gca,'position'),...
    'visible','off');
legend(ah,leg(23:40),txt1{24:end,5},'location','southeast','fontsize',7);
legend boxoff;
saveas(gca,[outdir '\FLow_sediment_metal_Stations-all.tif']);
saveas(gca,[outdir '\FLow_sediment_metal_Stations-all.fig']);

% residual analysis
figure
hold on
% colorrand=rand(numel(SedStations(:,1)),3);
load colorsed
% plot([1,10^8],[1,10^8],'k','linewidth',2);
for ii=1:numel(SedStations(:,1))
    if sum(~isnan(ObsSed(:,ii+2)))< 1
        
    else
        Lia = ismember(SimSed(:,1:2,SubLoc2(ii,1)),ObsSed(:,1:2));
        Lib = ismember(ObsSed(:,1:2),SimSed(:,1:2,SubLoc2(ii,1)));
        leg(ii) = scatter(SimSed(Lia(:,1),3,SubLoc2(ii,1)), ...
            (ObsSed(Lib(:,1),ii+2)*86.4.*lastdayofmonth(Lic(:,1),3)-SimSed(Lia(:,1),3,SubLoc2(ii,1))),45,[colorsed(ii,:)],'filled');
    end
end

xlim([1,10^8]);%ylim([1,10^8]);
set(gca,'xscale','log');
set(gca,'yscale','log');
xlabel('模拟月泥沙','fontsize',24);ylabel('月泥沙残差','fontsize',24);
legend(leg,txt2{2:end,5},'Location','southeast');
legend boxoff;
box on; grid on;
saveas(gca,[outdir '\Sed_Stations_residual-all.tif']);

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
    if sum(~isnan(ObsFlow(:,ii+2)))< 1
        
    else
        Lia = ismember(SimFlow(:,1:2,SubLoc1(ii,1)),ObsFlow(:,1:2));
        Lib = ismember(ObsFlow(:,1:2),SimFlow(:,1:2,SubLoc1(ii,1)));
        leg(ii) = scatter(SimFlow(Lia(:,1),3,SubLoc1(ii,1)), ...
            (ObsFlow(Lib(:,1),ii+2)-SimFlow(Lia(:,1),3,SubLoc1(ii,1))),45,[colorflow(ii,:)],'filled');
    end
end

% legend(leg,txt{2:end,4},'Location','southeast','fontsize',12);
box on; grid on;
xlabel('模拟月流量','fontsize',16);ylabel('月流量残差','fontsize',16);
% legend(leg,txt{2:end,4},'Location','eastoutside');
legend(leg(1:22),txt1{2:23,5},'Location','northwest');
legend boxoff;
ah=axes('position',get(gca,'position'),...
    'visible','off');
legend(ah,leg(23:40),txt1{24:end,5},'location','southeast');
legend boxoff;
saveas(gca,[outdir '\FLow_Stations_Residual-all.tif']);
close  all

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
        scatter(ObsFlow(Lib(:,1),ii+2),SimFlow(Lia(:,1),3,SubLoc1(ii,1)),55,'filled');
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
xlswrite([outdir '\statsall.xls'],modelflowstat,'Flow','B2')


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
        s1=scatter(ObsSed(Lib(:,1),ii+2)*86.4.*lastdayofmonth(Lic(:,1),3),SimSed(Lia(:,1),3,SubLoc2(ii,1)),55,'filled');
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
%         set(gca,'yscale','log');
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
xlswrite([outdir '\statsall.xls'],modelsedstat,'Sed','B2')

% for ii=1:numel(SedStations(:,1))
%     if isnan(ObsSed(ii,1))
%         
%     else
%         figure
%         subplot(2,2,3)
%         hold on
%         plot([10^-1,10^8],[10^-1,10^8],'k','linewidth',2);
%         plot([10^-1,0.2*10^8],[10^-1*5,10^8],'k','linewidth',2);
%         plot([5*10^-1,10^8],[10^-1,0.2*10^8],'k','linewidth',2);
%         
%         xlim([10^-1,10^8]);ylim([10^-1,10^8]);
%         set(gca,'xscale','log');
%         set(gca,'yscale','log');
%         Lia = ismember(SimSed(:,1:2,SubLoc2(ii,1)),ObsSed(:,1:2));
%         Lib = ismember(ObsSed(:,1:2),SimSed(:,1:2,SubLoc2(ii,1)));
%         s1=scatter(ObsSed(Lib(:,1),ii+2)*86.4.*lastdayofmonth(Lic(:,1),3),SimSed(Lia(:,1),3,SubLoc2(ii,1)),55,repmat([1,1,2,2,2,2,2,2,2,1,1,1],1,numel(ObsSed(Lib(:,1),ii+2))/12),'filled');
%         xlabel('Observed');ylabel('Simulated');
%         set(gca,'linewidth',2);
%         box on;
%         
%         subplot(2,2,[1,2])
%         hold on
%         set(gca,'linewidth',2);
%         h1=plot(ObsSed(Lib(:,1),ii+2)*86.4.*lastdayofmonth(Lic(:,1),3),'-','Linewidth',2,'Color',[55,126,184]/256);
%         h2=plot(SimSed(Lia(:,1),3,SubLoc2(ii,1)),'--','Linewidth',2,'Color',[228,26,28]/256);
%         %h3=plot(SimSed2(Lia(:,1),3,SubLoc2(ii,1)),'--','Linewidth',2,'Color',[77,175,74]/256);
% %         plot(SimSed2(SubLoc2(ii,1),1:end),'g');
%         legend([h1,h2],'Observed','Simulated','Location','west');  legend boxoff;
%         set(gca,'yscale','log');
%         xlim([-1,111]); ylim([0,2*max(max(ObsSed(:,ii+2)*86.4.*lastdayofmonth(Lic(:,1),3)),max(SimSed(Lia(:,1),3,SubLoc2(ii,1))))]);
%         xticks([1:12:109]);
%         xticklabels({'2007','2008','2009','2010','2011','2012','2013','2014','2015','2016'});
%         xlabel('Date');
%         ylabel ('Sediment (Tons)');
%         ax = axes('Position', get(gca, 'Position'), 'xlim', get(gca, 'xlim'),'ylim',...
%             [0 1000], 'YAxisLocation','right', 'XAxisLocation','top','ydir','reverse','Color', 'none');
%         set(ax, 'ytick', 0:200:1000);
%         set(ax, 'xticklabels', '');
%         ylabel ('Precipitation (mm)');
%         hold on;
%         set(gca,'linewidth',2);
% %         plot(pcpM(1:end,proj.IRGAGE(SubLoc2(ii,1))),'k','Parent', ax);
%         h3=bar(ax,pcpM(Lia(:,1),proj.IRGAGE(SubLoc2(ii,1))),'FaceColor',[77,175,74]/256);
%         legend([h3],'Precipitation','Location','east'); legend boxoff;
%         
%         subplot(2,2,4)
%         xx = [ObsSed(Lib(:,1),ii+2)*86.4.*lastdayofmonth(Lic(:,1),3),SimSed(Lia(:,1),3,SubLoc2(ii,1))]
%         idx = isnan(xx(:,1));
%         xx(idx,:)=[];
%         ns = nscoeff( xx )
%         pb = pbias( xx )
%         rr = corr(xx(:,1),xx(:,2))^2
%         annotation('textbox', [0.58,0.32,0.10,0.10],...
%             'String',['Sub ' num2str(SubLoc2(ii,1)) ': ' txt2{ii+1,5}],'fontsize',10, 'EdgeColor','none');
%         annotation('textbox', [0.58,0.24,0.1,0.1],...
%             'String',['R^2= ' num2str(roundn(rr,-2))],'fontsize',10, 'EdgeColor','none');
%         annotation('textbox', [0.58,0.16,0.1,0.1],...
%             'String',['NSE= ' num2str(roundn(ns,-2))],'fontsize',10, 'EdgeColor','none');
%         annotation('textbox', [0.58,0.08,0.1,0.1],...
%             'String',['PBIAS= ' num2str(roundn(pb*100,-2)) '%'],'fontsize',10, 'EdgeColor','none');      
%         set(gca, 'xticklabels', '');set(gca, 'yticklabels', '');
%         box on;
%         saveas(gca,[outdir '\Sed_Stations2-' num2str(ii) '.jpg']);
%         close  all
%     end
% end

upstreams=[816,784,790,793,797,808,815,819,838,849,853,856,864,875,882,885, ...
           893,894,899,901,902,906,918,921,924,937,942,943,945,949,950,955, ...
           966,978,981,988,990,994,998,1000,1001,1002,1004,1007,1009,1014, ...
           1017,1019,1022,1027,1029,1034,1042,1043,1045,1059,1062,1070];
figure
plot(squeeze(SimSed(:,3,upstreams)))
figure
boxplot(squeeze(SimSed(:,3,upstreams)),'Labels',num2cell(upstreams))