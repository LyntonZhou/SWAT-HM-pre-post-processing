%% @Lingfeng Zhou
clc
clear
close all
promdir = pwd;
txtiodir = 'D:\XiangRiverProject\XiangRiver\XRB210528V2_1.Sufi2.SwatCup-5';
% txtiodir = 'D:\XiangRiverProject\XiangRiver\XRB210528V2.Sufi2.SwatCup - 副本';
indir = 'D:\XiangRiverProject\XiangRiver\XRB210528V2\Inputs';
outdir = 'D:\XiangRiverProject\XiangRiver\XRB210528V2\Outputs\figs\final426-7';
shapdir ='D:\XiangRiverProject\XiangRiver\XRB210528V2\Watershed\Shapes';
mkdir(outdir)

% read file.cio
[iprint,nyskip,SubNo,HruNo] = readfilecio(txtiodir);
proj = readcio([txtiodir '\file.cio']);
proj = readsub(txtiodir,proj);

%% rend SWAT & SWAT-HM output
% output.sub
outputsub = readoutputsub2(txtiodir, iprint);
% outhml.sub
outhmlsub = readouthmlsub(txtiodir, iprint);
% output.rch
% outputrch = readoutputrch(txtiodir, iprint);
outputrch = readoutputrch2(txtiodir, iprint);
% outhml.rch
outhmlrch = readouthmlrch(txtiodir, iprint);
% read point source
filename = [indir '\Xiang_industry_sub_monthly_Cd_TableToExcel.xls'];
filename = [indir '\Xiang_industry_sub_monthly_Cd.xls'];
% metalpoint = readpointsource(filename,SubNo);
metalpoint = readpointsource2(filename,SubNo);
yearS=proj.IYR+proj.NYSKIP; yearE=proj.IYR+proj.NBYR-1;

% subbasin output
metalpoint = metalpoint(metalpoint.YEAR>=yearS & metalpoint.YEAR<=yearE,:);
metalpoint_Year = groupsummary(metalpoint,{'YEAR'},'sum',{'Point'});
metalpoint_Mon = groupsummary(metalpoint,{'YEAR','MON'},'sum',{'Point'});
outputsub = outputsub(outputsub.YEAR>=yearS & outputsub.YEAR<=yearE & outputsub.MON<13,:);
outhmlsub = outhmlsub(outhmlsub.YEAR>=yearS & outhmlsub.YEAR<=yearE & outhmlsub.MON<13,:);
data1 = groupsummary(outputsub,{'YEAR','SUB'},'mean',{'AREAkm2'});
data2 = groupsummary(outputsub,{'YEAR','SUB'},'sum',{'PRECIPmm','WYLDmm','SURQmm','LATQmm','GW_Qmm','SYLDtha'});
data3 = groupsummary(outhmlsub,{'YEAR','SUB'},'sum',{'HM_SURQkg','HM_LATkg','LabHM_EROkg','NLabHM_EROkg'});

subdata_Year_Sub =[data1(:,[1:2,4]),data2(:,4:9),data3(:,4:7)];
subdata = [outputsub(:,2:end),outhmlsub(:,5:end),metalpoint(:,4)];

% reach output
outhmlrch = outhmlrch(outhmlrch.YEAR>=yearS & outhmlrch.YEAR<=yearE & outhmlrch.MON<13,:);
outputrch = outputrch(outputrch.YEAR>=yearS & outputrch.YEAR<=yearE & outputrch.MON<13,:);
rchdata_Year_Sub = [outputrch(:,2:end),outhmlrch(:,5:end)];
rchdata_Year_Sub.DisCONC = table2array(rchdata_Year_Sub(:,15))./table2array(rchdata_Year_Sub(:,6))*1000*1000/86400/30; % ug/L;
summary(rchdata_Year_Sub);
% writetable(data(:,[1,8,9,end]),[outdir '\hmlrch.csv']);

% monthly SWAT output.sub
data = outputsub(outputsub.YEAR>=yearS & outputsub.YEAR<=yearE & outputsub.MON<13 ,:);
data1 = groupsummary(data,{'YEAR','SUB'},'mean',{'AREAkm2','PRECIPmm','WYLDmm','SURQmm','LATQmm','GW_Qmm','SYLDtha'});
data2 = table2array(data1);
writetable(data1(data1.YEAR==2010,:),[outdir '\yearlyoutsub.csv']);
figure
bar(data2(data2(:,2)==26,[5,7:9])*12)
legend(strrep(data1.Properties.VariableNames([5,7:9]),'_','-'));
xticks([1:8])
xticklabels({'2009','2010','2011','2012','2013','2014','2015','2016'});

data1 = groupsummary(data,{'MON'},'mean',{'SYLDtha'});
data2 = table2array(data1(:,3));
fig=figure
set(gcf, 'Position',  [100, 100, 600, 400])
ba2 = bar(data2);
% set(ba2(1),'facecolor','r')
% set(ba2(2),'facecolor','g')
% legend(strrep(data.Properties.VariableNames(8:9),'_','-'))
legend('SYLT','FontSize',14);
legend boxoff;
xlim([0,13]);

data1 = groupsummary(data,{'SUB','MON'},'mean',{'SYLDtha'});
data2 = table2array(data1(:,4));
data3 = reshape(data2,12,SubNo);
fig=figure
set(gcf, 'Position',  [100, 100, 600, 400])
ba2 = boxplot(data3');
% set(ba2(1),'facecolor','r')
% set(ba2(2),'facecolor','g')
% legend(strrep(data.Properties.VariableNames(8:9),'_','-'))
legend('SYLDtha','FontSize',14);
legend boxoff;
xlim([0,13]);

data1 = groupsummary(data,{'SUB','MON'},'mean',{'PRECIPmm'});
data2 = table2array(data1(:,4));
data3 = reshape(data2,12,SubNo);
fig=figure
set(gcf, 'Position',  [100, 100, 600, 400])
ba2 = boxplot(data3');
% set(ba2(1),'facecolor','r')
% set(ba2(2),'facecolor','g')
% legend(strrep(data.Properties.VariableNames(8:9),'_','-'))
legend('PRECIPmm','FontSize',14);
legend boxoff;
xlim([0,13]);

% monthly sub h. metal
data = outhmlsub(outhmlsub.YEAR>=yearS & outhmlrch.YEAR<=yearE & outhmlsub.MON<13 ,:);
data1 = groupsummary(data,{'YEAR','MON'},'sum',{'HM_SURQkg','HM_LATkg','LabHM_EROkg'});
data2 = table2array(data1);
figure
bar(data2(:,4:end),'stacked')
legend(strrep(data1.Properties.VariableNames(4:6),'_','-'));
xlabel('Date');ylabel('Load/Kg');
xticks([1:12:97])
xticklabels({'2009','2010','2011','2012','2013','2014','2015','2016','2017'});

% yearly mean sub h. metal
data = outhmlsub(outhmlsub.YEAR>=yearS & outhmlrch.YEAR<=yearE & outhmlsub.MON<13 ,:);
data1 = groupsummary(data,{'YEAR','SUB'},{'mean','sum'},{'AREAkm2','HM_SURQkg','HM_LATkg','LabHM_EROkg'});
data1.HM_SURQ = data1.sum_HM_SURQkg./data1.mean_AREAkm2*100;
data1.HM_LAT = data1.sum_HM_LATkg./data1.mean_AREAkm2*100;
data1.LabHM_ERO = data1.sum_LabHM_EROkg./data1.mean_AREAkm2*100;
writetable(data1(data1.YEAR==2010,[1:2,12:14]),[outdir '\yearlyhmlsub.csv']);
data2 = table2array(data1);
figure
bar(data2(data2(:,2)==26,12:14),'stacked')
legend(strrep(data1.Properties.VariableNames(12:14),'_','-'));
xticks([1:8]);
xticklabels({'2009','2010','2011','2012','2013','2014','2015','2016'});

data3 = groupsummary(data,{'YEAR','MON'},'sum',{'HM_SURQkg','HM_LATkg','LabHM_EROkg'});
data4 = table2array(data3);
fig = figure
set(gcf, 'Position',  [100, 100, 600, 400])
b=bar([metalpoint_Mon.sum_Point,data4(:,4:5),data4(:,6)],'stacked');
b(1).FaceColor = [79,103,149]/255;
b(2).FaceColor = [161,186,211]/255;
b(3).FaceColor = [179,85,79]/255;
b(4).FaceColor = [62,95,78]/255;
% set(gca,'YScale','log');
set(gca,'LineWidth',2);
legend('地表径流','壤中流','侵蚀泥沙','工业点源','FontSize',18,'Location','north');
legend('Industrial emissions','Surface runoff','Lateral flow','Soil erosion','FontSize',12,'Location','northwest');
legend boxoff;
xlim([-2,195])
xticks([1:12:193]);
set(gca,'XTickLabel',{'2000','2001','2002','2003','2004','2005','2006', ...
    '2007','2008','2009','2010','2011','2012','2013','2014','2015','2016'},'FontSize',10);
set(gca, 'XTickLabelRotation',90)
% xlabel('年份','FontSize',22);ylabel('入河通量 (kg/年)','FontSize',22);
xlabel('Date','FontSize',16);ylabel('Land-to-river Cd fluxes (kg yr^{-1})','FontSize',16);
saveas(fig,[outdir '\入河通量月.tif']);
saveas(fig,[outdir '\入河通量月.fig']);
saveas(fig,[outdir '\入河通量月.jpg']);
saveas(fig,[outdir '\入河通量月.eps']);

data3 = groupsummary(data,{'YEAR'},'sum',{'HM_SURQkg','HM_LATkg','LabHM_EROkg'});
data4 = table2array(data3);
fig = figure
set(gcf, 'Position',  [100, 100, 600, 400])
b=bar([metalpoint_Year.sum_Point/1000, data4(:,5)/1000,data4(:,3:4)/1000],'stacked');
b(1).FaceColor = [62,95,78]/255;
b(2).FaceColor = [79,103,149]/255;
b(3).FaceColor = [179,85,79]/255;
b(4).FaceColor = [161,186,211]/255;
% set(gca,'YScale','log');
set(gca,'LineWidth',2);
legend('地表径流','壤中流','侵蚀泥沙','工业点源','FontSize',18,'Location','north');
legend('Industrial emissions','Soil erosion','Surface runoff','Lateral flow','FontSize',14,'Location','northwest');
legend boxoff;
ylim([0,120])
xlim([0,17])
% xticks([1:16]);
set(gca,'Xtick',1:16,'FontSize',14);
set(gca,'XTickLabel',{'2000','2001','2002','2003','2004','2005','2006', ...
    '2007','2008','2009','2010','2011','2012','2013','2014','2015'},'FontSize',12);
set(gca, 'XTickLabelRotation',90)
% xlabel('年份','FontSize',22);ylabel('入河通量 (kg/年)','FontSize',22);
xlabel('Year','FontSize',18);ylabel('Land-to-river Cd fluxes (Mg yr^{-1})','FontSize',18);
saveas(fig,[outdir '\入河通量.tif']);
saveas(fig,[outdir '\入河通量.fig']);
saveas(fig,[outdir '\ga-1.fig']);
saveas(fig,[outdir '\入河通量.jpg']);
saveas(fig,[outdir '\入河通量.eps']);
sum(data4(:,5))/sum(metalpoint_Year.sum_Point)
metal_in = [data4(:,3:4),data4(:,5),metalpoint_Year.sum_Point];
mean(metal_in)
xlswrite([outdir '\statsall.xls'], metal_in, 'metalinput','B2');

figure
b=bar([metalpoint_Year.sum_Point./(sum(data4(:,3:5),2)+metalpoint_Year.sum_Point), ...
    sum(data4(:,3:5),2)./(sum(data4(:,3:5),2)+metalpoint_Year.sum_Point)],'stacked');
legend('Nonpoint','point','FontSize',12,'Location','northwest');
set(gca,'Xtick',1:16,'FontSize',14);
set(gca,'XTickLabel',{'2000','2001','2002','2003','2004','2005','2006', ...
    '2007','2008','2009','2010','2011','2012','2013','2014','2015'},'FontSize',10);
set(gca, 'XTickLabelRotation',90)

% rch h. metal
data = outhmlrch(outhmlrch.YEAR>=yearS & outhmlrch.YEAR<=yearE & outhmlrch.MON<13 & outhmlrch.RCH==5,:);
data1 = table2array(data(:,[8,9]));
fig=figure
set(gcf, 'Position',  [100, 100, 600, 400])
%plot(data1,'-o','LineWidth',1.5)
ba1 = bar(data1/1000,'stacked');
set(ba1(1),'facecolor',[192,100,89]/255)
set(ba1(2),'facecolor',[79,103,149]/255)
% legend(strrep(data.Properties.VariableNames(8:9),'_','-'))
legend('Dissolved Cd','Particulate Cd','FontSize',14);
legend boxoff;
%xlim([1,97]);
set(gca,'Xtick',1:12:241,'FontSize',14);set(gca,'LineWidth',2);
set(gca,'XTickLabel',{'2000','2001','2002','2003','2004','2005','2006', ...
    '2007','2008','2009','2010','2011','2012','2013','2014','2015','2016'},'FontSize',12);
set(gca, 'XTickLabelRotation',90)
xlabel('Date','FontSize',18);ylabel('Cd load (Mg)','FontSize',18)
saveas(fig,[outdir '\河口重金属时间序列.tif']);
saveas(fig,[outdir '\河口重金属时间序列.fig']);
[sum(sum(data1(1:12,1:2))),sum(sum(data1(181:192,1:2))), ...
   sum(data1(:,1))/sum(sum(data1(:,1:2)))]

xlswrite([outdir '\statsall.xls'], data1, 'Dongting','C2');

[min(squeeze(sum(reshape(data1,12,16,2),1)));
    max(squeeze(sum(reshape(data1,12,16,2),1)))]

data2 = groupsummary(data,{'MON'},'mean',{'DisHM_OUTkg','LabHM_OUTkg'});
data3 = table2array(data2(:,3:4));
fig=figure
set(gcf, 'Position',  [100, 100, 600, 400])
ba2 = bar(data3/1000,'stacked');
set(ba2(1),'facecolor',[192,100,89]/255)
set(ba2(2),'facecolor',[79,103,149]/255)
% legend(strrep(data.Properties.VariableNames(8:9),'_','-'))
legend('Dissolved Cd','Particulate Cd','FontSize',14);
legend boxoff;
xlim([0,13]);
set(gca,'LineWidth',2);
set(gca,'Xtick',1:12,'FontSize',14);
set(gca,'XTickLabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'},'FontSize',12);
xlabel('Month','FontSize',18);ylabel('Cd load (Mg)','FontSize',18)
saveas(fig,[outdir '\河口重金属月份.tif']);
saveas(fig,[outdir '\河口重金属月份.fig']);
wetratio=[sum(sum(data3(3:8,1:2)))/sum(sum(data3(:,1:2)))];
parratio=[sum(sum(data3(:,2)))/sum(sum(data3(:,1:2)))];

data2 = groupsummary(data,{'YEAR'},'sum',{'DisHM_OUTkg','LabHM_OUTkg'});
data3 = sum(table2array(data2(:,3:4)),2);
% tributary metal flux
data3=[];
%tributaryNo=[4 9 23 32 43 49 60 67 69 89 97 105 115 125 136 121 120 111 101 77 76 68];
% Xiao R, Guan R, Chonglin R, Zheng R, Lei R, Mi R, Juan R, Lu R, Lian R, Liuyang R, Laodao R,Weishui R
tributaryNo=[712, 702, 604, 449, 495, 365, 239, 225, 178, 68, 51, 52, 5];
for ii=1:numel(tributaryNo)
    data1 = outhmlrch(outhmlrch.RCH==tributaryNo(ii),:);
    data2 = table2array(data1(:,[8,9]));
    data3(:,ii) = sum(sum(data2,2))/(yearE-yearS+1)/1000; % tons/yr
end
figure
bar(data3)
data3(end)/data3(1)
metal_out=data3(end);
sum(sum(metal_in))/1000/(yearE-yearS+1) - metal_out
metal_out*(yearE-yearS+1)/(sum(sum(metal_in))/1000)
xlswrite([outdir '\statsall.xls'], [data3,metal_out*(yearE-yearS+1)/(sum(sum(metal_in))/1000),wetratio,parratio], 'metalriver','B2');

% data = outhmlrch(outhmlrch.YEAR==2012 & outhmlrch.MON==1,:);
% data1 = outputrch(outputrch.YEAR==2012 & outputrch.MON==1,:);
% data2 = table2array(data(:,8))./table2array(data1(:,7))*1000*1000/86400/30; % ug/L
% data.CONC = data2;
% writetable(data(:,[1,8,9,end]),[outdir '\hmlrch.csv']);

% yearly load at subbasin scale
data1 = groupsummary(subdata,{'SUB'},'sum',{'HM_SURQkg','HM_LATkg','LabHM_EROkg','Point'});
figure
% subplot(221)
data = table2array(data1(:,3))/(yearE-yearS+1);
xiangsub = shaperead([shapdir '\subs2.shp'],'UseGeoCoords', true);
ax=worldmap([24.5 28.7], [110.2 114.6]);
%     setm(ax,'grid','off')
% setm(ax,'frame','off')
% setm(ax,'parallellabel','off')
% setm(ax,'meridianlabel','off')
max_data = max(data);
k=10;
% mycolormap = summer(k);
% c = jet(k);
% mycolormap = colormap(c);
mycolormap=[179,85,79;192,100,89;
            212,177,170;205,222,187;
            233,242,234;233,237,242;
            161,186,211;122,155,189;
            79,103,149;55,71,116]/255;
mycolormap = flipud(mycolormap);
colormap(mycolormap)
for i=1:SubNo
    count=data(i);
    mycoloridx=floor( k * count / max_data);
    mycoloridx(mycoloridx<1)=1;
    mysymbolspec{i} = {'Subbasin', i, 'FaceColor', mycolormap(mycoloridx, :)};
end
symbols=makesymbolspec('Polygon',{'default','FaceColor',[0.9 0.9 0.8],...
    'LineStyle','--','LineWidth',0.2,...
    'EdgeColor','none'},... %[0.8 0.9 0.9]},...
    mysymbolspec{:}...
    );
geoshow(ax,xiangsub,'SymbolSpec',symbols);
hcb = colorbar;
step=max_data/k;
aa = 0:step:max_data;
set(hcb,'YTickLabel',num2cell(roundn(aa,0)));
set(hcb,'FontSize',16);
hcb.Label.String = 'Surface runoff load (kg yr^{-1})';
saveas(gcf,[outdir '\地表径流subbasin.fig']);
saveas(gcf,[outdir '\地表径流subbasin.tif']);

figure
% subplot(222)
data = table2array(data1(:,4))/(yearE-yearS+1);
xiangsub = shaperead([shapdir '\subs2.shp'],'UseGeoCoords', true);
ax=worldmap([24.5 28.7], [110.2 114.6]);
%     setm(ax,'grid','off')
% setm(ax,'frame','off')
% setm(ax,'parallellabel','off')
% setm(ax,'meridianlabel','off')
max_data = max(data);
k=10;
% mycolormap = summer(k);
% c = jet(k);
% mycolormap = colormap(c);
mycolormap=[179,85,79;192,100,89;
            212,177,170;205,222,187;
            233,242,234;233,237,242;
            161,186,211;122,155,189;
            79,103,149;55,71,116]/255;
mycolormap = flipud(mycolormap);
colormap(mycolormap)
for i=1:SubNo
    count=data(i);
    mycoloridx=floor( k * count / max_data);
    mycoloridx(mycoloridx<1)=1;
    mysymbolspec{i} = {'Subbasin', i, 'FaceColor', mycolormap(mycoloridx, :)};
end
symbols=makesymbolspec('Polygon',{'default','FaceColor',[0.9 0.9 0.8],...
    'LineStyle','--','LineWidth',0.2,...
    'EdgeColor','none'},... %[0.8 0.9 0.9]},...
    mysymbolspec{:}...
    );
geoshow(ax,xiangsub,'SymbolSpec',symbols);
hcb = colorbar;
step=max_data/k;
aa = 0:step:max_data;
set(hcb,'YTickLabel',num2cell(roundn(aa,0)));
set(hcb,'FontSize',16);
hcb.Label.String = 'Lateral flow load (kg yr^{-1})';
saveas(gcf,[outdir '\壤中流subbasin.fig']);
saveas(gcf,[outdir '\壤中流subbasin.tif']);

figure
% subplot(223)
data = table2array(data1(:,5))/(yearE-yearS+1);
xiangsub = shaperead([shapdir '\subs2.shp'],'UseGeoCoords', true);
ax=worldmap([24.5 28.7], [110.2 114.6]);
%     setm(ax,'grid','off')
% setm(ax,'frame','off')
% setm(ax,'parallellabel','off')
% setm(ax,'meridianlabel','off')
max_data = max(data);
k=10;
% mycolormap = summer(k);
% c = jet(k);
% mycolormap = colormap(c);
mycolormap=[179,85,79;192,100,89;
            212,177,170;205,222,187;
            233,242,234;233,237,242;
            161,186,211;122,155,189;
            79,103,149;55,71,116]/255;
mycolormap = flipud(mycolormap);
colormap(mycolormap)
for i=1:SubNo
    count=data(i);
    mycoloridx=floor( k * count / max_data);
    mycoloridx(mycoloridx<1)=1;
    mysymbolspec{i} = {'Subbasin', i, 'FaceColor', mycolormap(mycoloridx, :)};
end
symbols=makesymbolspec('Polygon',{'default','FaceColor',[0.9 0.9 0.8],...
    'LineStyle','--','LineWidth',0.2,...
    'EdgeColor','none'},... %[0.8 0.9 0.9]},...
    mysymbolspec{:}...
    );
geoshow(ax,xiangsub,'SymbolSpec',symbols);
hcb = colorbar;
step=max_data/k;
aa = 0:step:max_data;
set(hcb,'YTickLabel',num2cell(roundn(aa,0)));
set(hcb,'FontSize',16);
hcb.Label.String = 'Soil erosion load (kg yr^{-1})';
saveas(gcf,[outdir '\土壤侵蚀subbasin.fig']);
saveas(gcf,[outdir '\土壤侵蚀subbasin.tif']);

figure
% subplot(224)
data = table2array(data1(:,6))/(yearE-yearS+1);
xiangsub = shaperead([shapdir '\subs2.shp'],'UseGeoCoords', true);
ax=worldmap([24.5 28.7], [110.2 114.6]);
%     setm(ax,'grid','off')
% setm(ax,'frame','off')
% setm(ax,'parallellabel','off')
% setm(ax,'meridianlabel','off')
max_data = max(data);
k=10;
% mycolormap = summer(k);
% c = jet(k);
% mycolormap = colormap(c);
mycolormap=[179,85,79;192,100,89;
            212,177,170;205,222,187;
            233,242,234;233,237,242;
            161,186,211;122,155,189;
            79,103,149;55,71,116]/255;
mycolormap = flipud(mycolormap);
colormap(mycolormap)
aa =[0,10,25,50,75,100,250,500,750,1000, max_data];
for i=1:SubNo
    count=data(i);
%     mycoloridx=floor( k * count / max_data);
%     mycoloridx(mycoloridx<1)=1;
    mycoloridx = sum (count >= aa);
    if mycoloridx==11; mycoloridx=10; end
    mysymbolspec{i} = {'Subbasin', i, 'FaceColor', mycolormap(mycoloridx, :)};
end
symbols=makesymbolspec('Polygon',{'default','FaceColor',[0.9 0.9 0.8],...
    'LineStyle','--','LineWidth',0.2,...
    'EdgeColor','none'},... %[0.8 0.9 0.9]},...
    mysymbolspec{:}...
    );
geoshow(ax,xiangsub,'SymbolSpec',symbols);
hcb = colorbar;
% step=max_data/k;
% aa = 0:step:max_data;
aa1 =[0,25,75,250,750, max_data];
set(hcb,'YTickLabel',num2cell(roundn(aa1,0)));
set(hcb,'FontSize',16);
hcb.Label.String = 'Industrial emission load (kg yr^{-1})';
saveas(gcf,[outdir '\工业点源subbasin.fig']);
saveas(gcf,[outdir '\工业点源subbasin.tif']);
% 清水塘
[sum(data([164,148,149,172]))*16,sum(data([164,148,149,172, 179]))/sum(data)];
% 水口山
[sum(data([164,148,149,172]))*16,sum(data([164,148,149,172]))/sum(data)]

% years = unique(subdata.YEAR);
% rch sediment
dataall= reshape(rchdata_Year_Sub.SED_OUTtons,SubNo,12,7);
for ii=1:numel(years)
    for jj=1:12
        data=dataall(:,jj,ii);
        figure
        xiangriv = shaperead([shapdir '\riv2.shp'], 'UseGeoCoords', true);
        xiangbasin = shaperead([shapdir '\basin2.shp'], 'UseGeoCoords', true) ;
        ax=worldmap([24.5 28.7], [110.2 114.6]);
        max_data = max(data);
        min_data = min(data);
        k=10;
        % mycolormap = summer(k);
        c = jet(k);
        mycolormap = colormap(c);
        for i=1:SubNo
            count=data(i);
            mycoloridx=floor(k * (log(count)-log(min_data+1)) /(log(max_data)-log(min_data+1)));
%             mycoloridx=floor(k * (count-min_data) /(max_data-min_data));
            mycoloridx(mycoloridx<1)=1;
            mycoloridx(mycoloridx>k)=k;
            mysymbolspec{i} = {'Subbasin', i, 'Color', mycolormap(mycoloridx, :)};
        end
        symbols=makesymbolspec('Line', {'default','LineWidth',1.5}, mysymbolspec{:});
        geoshow(ax,xiangriv,'SymbolSpec',symbols);
        geoshow(xiangbasin,'FaceColor', [1.0 1.0 1.0],'FaceAlpha',0.2);
        hcb = colorbar;
        step=max_data/k;
        aa = 0:step:max_data;
        set(hcb,'YTickLabel',num2cell(roundn(aa,-2)));
        hcb.Label.String = 'Tons';
        title(['水系--输沙量--', num2str(years(ii)), '年-第', num2str(jj) '月  (单位:Tons)']);
        saveas(gcf,['.\figs\Rch-输沙量-第', num2str(years(ii)), '年-第', num2str(jj) '月.jpg']);
        close all
    end
end

% rch dis hm
dataall= reshape(rchdata_Year_Sub.DisCONC,SubNo,12,7);
for ii=1:numel(years)
    for jj=1:12
        data=dataall(:,jj,ii);
        figure
        xiangriv = shaperead([shapdir '\riv2.shp'], 'UseGeoCoords', true);
        xiangbasin = shaperead([shapdir '\basin2.shp'], 'UseGeoCoords', true) ;
        ax=worldmap([24.5 28.7], [110.2 114.6]);
        %         setm(ax,'grid','off')
        % setm(ax,'frame','off')
        % setm(ax,'parallellabel','off')
        % setm(ax,'meridianlabel','off')
        max_data = max(data);
        %         max_data = prctile(data,0.99)
        min_data = min(data);
        %         min_data = prctile(data,0.05)
        k=6;
        % mycolormap = summer(k);
        c = jet(k);
        mycolormap = colormap(c);
        %         for i=1:SubNo
        %             count=data(i);
        %             mycoloridx=floor( k * (log(count)-log(min_data)) /(log(max_data)-log(min_data)));
        %             mycoloridx(mycoloridx<1)=1;
        %             mycoloridx(mycoloridx>k)=k;
        %             mysymbolspec{i} = {'Subbasin', i, 'Color', mycolormap(mycoloridx, :)};
        %         end
        for i=1:SubNo
            count=data(i);
            if count <= 0.46
                mycoloridx= 1;
            elseif count <= 1
                mycoloridx= 2;
            elseif count <= 5
                mycoloridx= 3;
            elseif count <= 10
                mycoloridx= 4;
            elseif count <= 38.88
                mycoloridx= 5;
            else
                mycoloridx= 6;
            end
            mysymbolspec{i} = {'Subbasin', i, 'Color', mycolormap(mycoloridx, :)};
        end
        symbols=makesymbolspec('Line', {'default','LineWidth',1.5}, mysymbolspec{:});
        geoshow(ax,xiangriv,'SymbolSpec',symbols);
        geoshow(xiangbasin,'FaceColor', [1.0 1.0 1.0],'FaceAlpha',0.2);
        %         hcb = colorbar;
        %         step = max_data/k;
        %         aa = 0:step:max_data;
        %         colorbar('Ticks',[-5,-2,1,4,7],...
        %          'TickLabels',{'Cold','Cool','Neutral','Warm','Hot'})
        step = 1/k;
        aa1 = 0:step:1;
        aa = [0, 0.46, 1, 5, 10, 38.8, 100];
        %         set(hcb,'Ticks',aa1,'TickLabel',num2cell(roundn(aa,-2)));
        hcb = colorbar('Ticks',aa1,...
            'TickLabels',{'0', '0.46', '1.00', '5.00', '10.00', '38.88', ''});
        hcb.Label.String = 'Conc (ug/L)';
        title(['水系--溶解态Cd浓度--', num2str(years(ii)), '年-第', num2str(jj) '月  (单位:ug/L)']);
        saveas(gcf,['.\figs\Rch-溶解态Cd-第', num2str(years(ii)), '年-第', num2str(jj) '月.jpg']);
        close all
    end
end

% plot surq hm
dataall = reshape(subdata.HM_SURQkg,SubNo,12,7);
for ii=1:numel(years)
    for jj=1:12
        data=dataall(:,jj,ii);
        figure
        xiangsub = shaperead([shapdir '\subs2.shp'],'UseGeoCoords', true);
        ax=worldmap([24.5 28.7], [110.2 114.6]);
        %     setm(ax,'grid','off')
        % setm(ax,'frame','off')
        % setm(ax,'parallellabel','off')
        % setm(ax,'meridianlabel','off')
        max_data = max(data);
        k=10;
        % mycolormap = summer(k);
        c = jet(k);
        mycolormap = colormap(c);
        for i=1:SubNo
            count=data(i);
            mycoloridx=floor( k * count / max_data);
            mycoloridx(mycoloridx<1)=1;
            mysymbolspec{i} = {'Subbasin', i, 'FaceColor', mycolormap(mycoloridx, :)};
        end
        symbols=makesymbolspec('Polygon',{'default','FaceColor',[0.9 0.9 0.8],...
            'LineStyle','--','LineWidth',0.2,...
            'EdgeColor',[0.8 0.9 0.9]},...
            mysymbolspec{:}...
            );
        geoshow(ax,xiangsub,'SymbolSpec',symbols);
        hcb = colorbar;
        step=max_data/k;
        aa = 0:step:max_data;
        set(hcb,'YTickLabel',num2cell(roundn(aa,-2)));
        hcb.Label.String = 'Load (kg)';
        title(['子流域-地表径流Cd通量--', num2str(years(ii)), '年-第', num2str(jj) '月  (单位:kg)']);
        saveas(gcf,['.\figs\Sub-地表径流Cd-', num2str(years(ii)), '年-第', num2str(jj) '月.jpg']);
        close all
    end
end

% plot sed hm
% dataall = reshape(subdata_Year_Sub.sum_HM_SURQkg+subdata_Year_Sub.sum_HM_SURQkg,SubNo,7);
dataall = reshape(subdata.LabHM_EROkg+subdata.NLabHM_EROkg,SubNo,12,7);
for ii=1:numel(years)
    for jj=1:12
        data=dataall(:,jj,ii);
        figure
        xiangsub = shaperead([shapdir '\subs2.shp'],'UseGeoCoords', true);
        ax=worldmap([24.5 28.7], [110.2 114.6]);
        setm(ax,'grid','off')
        % setm(ax,'frame','off')
        % setm(ax,'parallellabel','off')
        % setm(ax,'meridianlabel','off')
        max_data = max(data);
        k=10;
        % mycolormap = summer(k);
        c = jet(k);
        mycolormap = colormap(c);
        for i=1:SubNo
            count=data(i);
            mycoloridx=floor( k * count / max_data);
            mycoloridx(mycoloridx<1)=1;
            mysymbolspec{i} = {'Subbasin', i, 'FaceColor', mycolormap(mycoloridx, :)};
        end
        symbols=makesymbolspec('Polygon',{'default','FaceColor',[0.9 0.9 0.8],...
            'LineStyle','--','LineWidth',0.2,...
            'EdgeColor',[0.8 0.9 0.9]},...
            mysymbolspec{:}...
            );
        geoshow(ax,xiangsub,'SymbolSpec',symbols);
        hcb = colorbar;
        step = max_data/k;
        aa = 0:step:max_data;
        set(hcb,'YTickLabel',num2cell(roundn(aa,-2)));
        hcb.Label.String = 'Load (kg)';
        title(['子流域-泥沙侵蚀Cd通量--', num2str(years(ii)), '年-第', num2str(jj) '月  (单位:kg)']);
        saveas(gcf,['.\figs\Sub-泥沙侵蚀Cd-', num2str(years(ii)), '年-第', num2str(jj) '月.jpg']);
        close all
    end
end

% plot point hm
dataall = reshape(subdata.Point,SubNo,12,7);
for ii=1:numel(years)
    for jj=1:12
        data=dataall(:,jj,ii);
        figure
        xiangsub = shaperead([shapdir '\subs2.shp'],'UseGeoCoords', true);
        ax=worldmap([24.5 28.7], [110.2 114.6]);
        setm(ax,'grid','off')
        % setm(ax,'frame','off')
        % setm(ax,'parallellabel','off')
        % setm(ax,'meridianlabel','off')
        max_data = max(data);
        k=10;
        % mycolormap = summer(k);
        c = jet(k);
        mycolormap = colormap(c);
        for i=1:SubNo
            count=data(i);
            mycoloridx=floor(k * count / max_data);
            mycoloridx(mycoloridx<1)=1;
            if isnan(mycoloridx); mycoloridx = 1;end
            mysymbolspec{i} = {'Subbasin', i, 'FaceColor', mycolormap(mycoloridx, :)};
        end
        symbols=makesymbolspec('Polygon',{'default','FaceColor',[0.9 0.9 0.8],...
            'LineStyle','--','LineWidth',0.2,...
            'EdgeColor',[0.8 0.9 0.9]},...
            mysymbolspec{:}...
            );
        geoshow(ax,xiangsub,'SymbolSpec',symbols);
        hcb = colorbar;
        step = max_data/k;
        aa = 0:step:max_data;
        set(hcb,'YTickLabel',num2cell(roundn(aa,-2)));
        hcb.Label.String = 'Load (kg)';
        title(['子流域-工业点源Cd--', num2str(years(ii)), '年-第', num2str(jj) '月  (单位:kg)']);
        saveas(gcf,['.\figs\Sub-工业点源Cd-', num2str(years(ii)), '年-第', num2str(jj) '月.jpg']);
        close all
    end
end
