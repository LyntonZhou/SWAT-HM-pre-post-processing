%% Setup the Import Options
clc
clear
indir = 'D:\XiangRiverProject\XiangRiver\XRB210528V2\Inputs';
outdir = 'D:\XiangRiverProject\XiangRiver\XRB210528V2\Outputs\figs\fig17';

opts = spreadsheetImportOptions("NumVariables", 39);

% Specify sheet and range
opts.Sheet = "湘江镉月克_行业_Sub_Int";
opts.DataRange = "A2:AM48751";

% Specify column names and types
opts.VariableNames = ["OBJECTID", "FID___Clip_Project", "Year", "Code", "Y1", "Y2", "Y3", "Y4", "Y5", "Y6", "Y7", "Y8", "Y9", "Y10", "Y11", "Y12", "gridid", "gridlat", "gridlng", "FID_subs2", "OBJECTID_1", "GRIDCODE", "Subbasin", "Area", "Slo1", "Len1", "Sll", "Csl", "Wid1", "Dep1", "Lat", "Long_", "Elev", "ElevMin", "ElevMax", "Bname", "Shape_Leng", "HydroID", "OutletID"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "categorical", "double", "double", "double"];
opts = setvaropts(opts, 36, "EmptyFieldRule", "auto");

% Import the data
PointSubInt = readtable("D:\XiangRiverProject\XiangRiver\XRB210528V2\Inputs\湘江月行业\湘江镉月克_行业_Sub_Int.xls", opts, "UseExcel", false);

%% Clear temporary variables
clear opts

order = csvread([indir '\streamorder\order1.csv']);
[~,idx] = sort(order(:,1));
order = order(idx,:);

PointMonSubInt= table2array(PointSubInt(:,[3:16,22]));

codes = [9,33];
streams = squeeze(order(order(:,2)==1,1));
nn =0;
PointMonSubInt_S=[];
for co=1:numel(codes)
    for ll=1:numel(streams)
        nn=0;
        for ii=2000:1:2015
            for jj=1:1:12
                nn = nn+1;
                PointMonSubInt_S(nn,1,ll,co)=ii;
                PointMonSubInt_S(nn,2,ll,co)=jj;
                idx = find(PointMonSubInt(:,1)==ii & PointMonSubInt(:,2)==codes(co) & PointMonSubInt(:,15)==streams(ll));
                if idx
                    PointMonSubInt_S(nn,3,ll,co)=PointMonSubInt(idx(1),jj+2);
                else
                    PointMonSubInt_S(nn,3,ll,co)=0;
                end
            end
        end
    end
end

% PointMonSubInt_Mining=sum(PointMonSubInt_S,3);
% PointMonSubInt_Smelting=sum(PointMonSubInt_S,3);

fig = figure
set(gcf, 'Position',  [100, 100, 750, 500])
plot(sum(PointMonSubInt_S(:,3,:,1),3)/1000,'r','LineWidth',2)
hold on
plot(sum(PointMonSubInt_S(:,3,:,2),3)/1000,'b','LineWidth',2)
xlim([-2,195])
ylim([0,350])
xticks([1:12:193]);
set(gca,'LineWidth',2);
set(gca,'XTickLabel',{'2000','2001','2002','2003','2004','2005','2006', ...
    '2007','2008','2009','2010','2011','2012','2013','2014','2015','2016'},'FontSize',10);
xlabel('Date','FontSize',16);ylabel('Industrial emissions in order 1 subbasins (kg)','FontSize',16);
legend('Mining and Processing of Non-ferrous Metal Ores','Smelting and Pressing of Non-ferrous Metals','FontSize',12)
legend boxoff
saveas(fig,[outdir '\工业点源order1.tif']);
saveas(fig,[outdir '\工业点源order1.fig']);