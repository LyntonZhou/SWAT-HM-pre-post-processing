%% Initialize variables
clc
clear
close all
filename = 'C:\Users\lenovo\Desktop\湘江月行业\行业代码2002标准.csv';
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

filename = 'C:\Users\lenovo\Desktop\湘江月行业\湘江镉月克_行业.csv';
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

indir = 'D:\XiangRiverProject\XiangRiver\XRB210517V2\Inputs';
projdir = 'D:\XiangRiverProject\XiangRiver\XRB210518V2.Sufi2.SwatCup'; % folder of SWAT-HM project
filename = [indir '\Xiang_industry_sub_monthly_Cd_TableToExcel.xls'];
% read file.cio
[iprint,nyskip,SubNo,HruNo] = readfilecio(projdir);
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
            idx = find(data2(:,1)==ii & data2(:,2)==codes(kk))
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
data4=[data3(73:end,4),data3(73:end,5),data3(73:end,27),data3(73:end,28),data3(73:end,21)];
data5=sum(data3(73:end,3:40),2)-sum(data4,2);
figure
bar([data4,data5],'stacked')
xlim([-2,123])
xticks([1:12:121]);
xticklabels({'2006','2007','2008','2009','2010','2011','2012','2013','2014','2015','2016'});
xlabel('年份','FontSize',22);ylabel('入河通量 (kg)','FontSize',22);
legend('黑色金属矿采选业','有色金属矿采选业','黑色金属冶炼和压延加工业','有色金属冶炼和压延加工业','化学原料和化学制品制造业','其他行业')