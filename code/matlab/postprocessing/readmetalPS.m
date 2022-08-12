%% Initialize variables
clc
clear
close all
outdir = 'D:\XiangRiverProject\XiangRiver\XRB210528V2\Outputs\figs\final0504-4';
filename = 'D:\XiangRiverProject\XiangRiver\XRB210528V2\Inputs\湘江月行业\行业代码2002标准.csv';
delimiter = '\t';
startRow = 2;

%% Format for each line of text:
formatSpec = '%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

%% Close the text file.
fclose(fileID);

%% Create output variable
Untitled = [dataArray{1:end-1}];
Untitled(2,:)=[];
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

filename = 'D:\XiangRiverProject\XiangRiver\XRB210528V2\Inputs\湘江月行业\湘江镉月克_行业.csv';
delimiter = ',';
startRow = 2;

%% Format for each line of text:
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r','n','UTF-8');
% Skip the BOM (Byte Order Mark).
fseek(fileID, 3, 'bof');

%% Read columns of data according to the format.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

%% Close the text file.
fclose(fileID);

%% Create output variable
metalPS = table(dataArray{1:end-1}, 'VariableNames', {'Year','Code','Y1','Y2','Y3','Y4','Y5','Y6','Y7','Y8','Y9','Y10','Y11','Y12','gridid','gridlat','gridlng'});

%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

indir = 'D:\XiangRiverProject\XiangRiver\XRB210528V2\Inputs';
txtiodir = 'D:\XiangRiverProject\XiangRiver\XRB210528V2_1.Sufi2.SwatCup-5'; % folder of SWAT-HM project
filename = [indir '\Xiang_industry_sub_monthly_Cd.xls'];
% read file.cio
[iprint,nyskip,SubNo,HruNo] = readfilecio(txtiodir);
[~,GridID] = readpointsource2(filename,SubNo);

toDelete = ismember(metalPS.gridid,GridID.gridid);
metalPS(~toDelete,:) = [];

metalPS_Code = groupsummary(metalPS,{'Code'},'sum',{'Y1','Y2','Y3','Y4','Y5','Y6','Y7','Y8','Y9','Y10','Y11','Y12'});
metalPS_Code1 = table2array(metalPS_Code);

metalPS_year = groupsummary(metalPS,{'Year'},'sum',{'Y1','Y2','Y3','Y4','Y5','Y6','Y7','Y8','Y9','Y10','Y11','Y12'});
metalPS_year1 = table2array(metalPS_year);

figure
bar(metalPS_Code1(:,3:end),'stacked')
xticks([1:1:39]);
xticklabels(Untitled(:,1));

figure
bar(metalPS_year1(:,3:end)/1000,'stacked')
xticks([1:1:16]);
xticklabels({'2000','2001','2002','2003','2004','2005','2006','2007','2008','2009','2010','2011','2012','2013','2014','2015','2016'});

data1 = groupsummary(metalPS,{'Year','Code'},'sum',{'Y1','Y2','Y3','Y4','Y5','Y6','Y7','Y8','Y9','Y10','Y11','Y12'});
data2 = table2array(data1);
codes = unique(data1.Code);
nn =0;
for ii=2000:1:2015
    for jj=1:12
        nn = nn+1;
        for kk=1:numel(codes)
            data3(nn,1)=ii;
            data3(nn,2)=jj;
%             data3(nn,3)=codes(kk);
            idx = find(data2(:,1)==ii & data2(:,2)==codes(kk));
            if idx
                data3(nn,kk+2)=data2(idx,jj+3);
            else
                data3(nn,kk+2)=0;
            end
        end
    end
end

figure
bar(data3(:,3:end),'stacked')
xlim([-2,195])
xticks([1:12:193]);
xticklabels({'2000','2001','2002','2003','2004','2005','2006','2007','2008','2009','2010','2011','2012','2013','2014','2015','2016'});
legend(Untitled(:,1))

data3(:,3:40)=data3(:,3:40)/1000;
data4=[data3(:,5),data3(:,28)];
data5=sum(data3(:,3:40),2)-sum(data4,2);
fig = figure
set(gcf, 'Position',  [100, 100, 600, 400])
b = bar([data4,data5],'stacked')
b(1).FaceColor = [79,103,149]/255;
b(2).FaceColor = [179,85,79]/255;
b(3).FaceColor = [62,95,78]/255;
set(gca,'LineWidth',2);
xlim([-2,195])
xticks([1:12:193]);
set(gca,'XTickLabel',{'2000','2001','2002','2003','2004','2005','2006', ...
    '2007','2008','2009','2010','2011','2012','2013','2014','2015','2016'},'FontSize',9);
xlabel('年份','FontSize',18);ylabel('Industrial emissions (kg)','FontSize',18);
% legend('黑色金属矿采选业','有色金属矿采选业','黑色金属冶炼和压延加工业','有色金属冶炼和压延加工业','化学原料和化学制品制造业','其他行业')
legend('Mining and Processing of Non-ferrous Metal Ores','Smelting and Pressing of Non-ferrous Metals','Others','FontSize',12)
legend boxoff
xlabel('Month','FontSize',16);ylabel('Industrial emissions (kg)','FontSize',16);
saveas(fig,[outdir '\不同行业1.tif']);
saveas(fig,[outdir '\不同行业1.fig']);
saveas(fig,[outdir '\不同行业1.jpg']);
saveas(fig,[outdir '\不同行业1.eps']);
sum(sum(data4))/sum(sum(data3(:,3:end)))

data4=[];data5=[];
for ii=1:1:16
    idx = find(data3(:,1)==(ii+1999));
    data4(ii,:)=sum(data3(idx,:));
end
data5=[data4(:,5),data4(:,28)];
data6=sum(data4(:,3:40),2)-sum(data5,2);
fig = figure
set(gcf, 'Position',  [100, 100, 600, 400])
b = bar([data5/1000,data6/1000],'stacked')
b(1).FaceColor = [79,103,149]/255;
b(2).FaceColor = [179,85,79]/255;
b(3).FaceColor = [62,95,78]/255;
set(gca,'LineWidth',2);
xlim([0,17])
xticks([1:1:16]);
set(gca,'XTickLabel',{'2000','2001','2002','2003','2004','2005','2006', ...
    '2007','2008','2009','2010','2011','2012','2013','2014','2015','2016'},'FontSize',10);
set(gca, 'XTickLabelRotation',90)
xlabel('年份','FontSize',18);ylabel('Industrial emissions (kg)','FontSize',18);
% legend('黑色金属矿采选业','有色金属矿采选业','黑色金属冶炼和压延加工业','有色金属冶炼和压延加工业','化学原料和化学制品制造业','其他行业')
legend('Mining and Processing of Non-ferrous Metal Ores','Smelting and Pressing of Non-ferrous Metals','Others','FontSize',12)
legend('MPNMO','SPNM','Others','FontSize',12)
legend boxoff
xlabel('Year','FontSize',16);ylabel('Industrial emissions (Mg yr^{-1})','FontSize',16);
saveas(fig,[outdir '\不同行业2.tif']);
saveas(fig,[outdir '\不同行业2.fig']);
saveas(fig,[outdir '\不同行业2.jpg']);
saveas(fig,[outdir '\不同行业2.eps']);

fig = figure
set(gcf, 'Position',  [100, 100, 600, 400])
a = area([data5/1000,data6/1000])
a(1).FaceColor = [79,103,149]/255;
a(2).FaceColor = [179,85,79]/255;
a(3).FaceColor = [62,95,78]/255;
set(gca,'LineWidth',2);
xlim([0.5,16.5])
xticks([1:1:16]);
set(gca,'XTickLabel',{'2000','2001','2002','2003','2004','2005','2006', ...
    '2007','2008','2009','2010','2011','2012','2013','2014','2015','2016'},'FontSize',12);
set(gca, 'XTickLabelRotation',90)
legend('Mining','Smelting','Other industries','FontSize',14)
legend boxoff
xlabel('Year','FontSize',18);ylabel('Industrial emissions (Mg yr^{-1})','FontSize',18);
saveas(fig,[outdir '\ga-2.tif']);
saveas(fig,[outdir '\ga-2.fig']);

% from 2008 to 2015
(sum([data5(1,:),data6(1,:)])-sum([data5(end,:),data6(end,:)]))/sum([data5(1,:),data6(1,:)])
(sum([data5(8,:),data6(8,:)])-sum([data5(end,:),data6(end,:)]))/sum([data5(8,:),data6(8,:)])

data4=[data3(73:end,4),data3(73:end,5),data3(73:end,27),data3(73:end,28),data3(73:end,21)];
data5=sum(data3(73:end,3:40),2)-sum(data4,2);
fig = figure
set(gcf, 'Position',  [100, 100, 600, 400])
bar([data4,data5],'stacked')
xlim([-2,123])
xticks([1:12:121]);
xticklabels({'2006','2007','2008','2009','2010','2011','2012','2013','2014','2015','2016'});
xlabel('年份','FontSize',18);ylabel('入河通量 (kg)','FontSize',18);
legend('黑色金属矿采选业','有色金属矿采选业','黑色金属冶炼和压延加工业','有色金属冶炼和压延加工业','化学原料和化学制品制造业','其他行业')
legend('黑色金属矿采选业','有色金属矿采选业','黑色金属冶炼和压延加工业','有色金属冶炼和压延加工业','化学原料和化学制品制造业','其他行业')
legend boxoff
xlabel('Month','FontSize',9);ylabel('Land-to-river Cd flux (kg/year)','FontSize',16);
saveas(fig,[outdir '\不同行业.tif']);
saveas(fig,[outdir '\不同行业.fig']);