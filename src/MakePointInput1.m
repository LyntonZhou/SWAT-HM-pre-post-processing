%% Setup the Import Options
% opts = spreadsheetImportOptions("NumVariables", 39);
% 
% % Specify sheet and range
% opts.Sheet = "Xiang_industry_monthly_Cd_Pr_in";
% opts.DataRange = "A2:AM26330";
% 
% % Specify column names and types
% opts.VariableNames = ["FID", "FID_Xiang_", "Year", "Y1", "Y2", "Y3", "Y4", "Y5", "Y6", "Y7", "Y8", "Y9", "Y10", "Y11", "Y12", "gridid", "gridlat", "gridlng", "FID_subs1", "OBJECTID", "GRIDCODE", "Subbasin", "Area", "Slo1", "Len1", "Sll", "Csl", "Wid1", "Dep1", "Lat", "Long_", "Elev", "ElevMin", "ElevMax", "Bname", "Shape_Leng", "Shape_Area", "HydroID", "OutletID"];
% opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "categorical", "double", "double", "double", "double"];
% opts = setvaropts(opts, 35, "EmptyFieldRule", "auto");

% Import the data
XiangindustrysubmonthlyTableToExcel = readtable("D:\XiangRiverProject\XiangRiver\XRB210528V2\Inputs\Xiang_industry_monthly\Xiang_industry_monthly_Cd_Pr_int_TableToExcel.csv");

%% Clear temporary variables
% clear opts

MetalPoint = groupsummary(XiangindustrysubmonthlyTableToExcel,{'Year','Subbasin'},'sum',{'Y1','Y2','Y3','Y4','Y5','Y6','Y7','Y8','Y9','Y10','Y11','Y12'});

yearS = MetalPoint.Year(1);
yearE = MetalPoint.Year(end);
MetalPointCd = table2array(MetalPoint(:,[1,2,4:15]));

SubNo = 1118;
ndays = datenum(yearE,12,31) - datenum(yearS,1,1) + 1;
for jj = 1:SubNo
    jj
    for ii=1:ndays
         t = datevec(ii+datenum(yearS,1,1)-1);
         t0 = t;
         t0(:,2:3) = 1;
         cuttentYear = t(1);
         doy = datenum(t) - datenum(t0) + 1;
         idx = find(MetalPointCd(:,1)==cuttentYear & MetalPointCd(:,2)==jj);
         MetalPoint2(ii,1) = doy;
         MetalPoint2(ii,2) = cuttentYear;
         if isempty(idx)
             MetalPoint2(ii,jj+2) = 0 ;      
         else
            [MonthNum, ~] = month(datenum(t));
            DayMonth = eomday(cuttentYear,MonthNum);
            MetalPoint2(ii,jj+2) = MetalPointCd(idx,MonthNum+2)/DayMonth/1000; % montlhy g to kg
         end
    end
end
names(1)="DAY";
names(2)="YEAR";

for ii=1:SubNo
    names(ii+2)=['SUB' num2str(ii)];
end

MetalPoint2T = array2table(MetalPoint2,'VariableNames',names);

MetalPoint2_1998 = MetalPoint2(367:731,:);
MetalPoint2_1998(:,2) = 1998;
MetalPoint2_1999 = MetalPoint2(732:1096,:);
MetalPoint2_1999(:,2) = 1999;
MetalPoint2 = [MetalPoint2_1998;MetalPoint2_1998;MetalPoint2];
MetalPoint2T = array2table(MetalPoint2,'VariableNames',names);
writetable(MetalPoint2T,'HeavyMetalModuleDataBase_XiangRiver_XRB210528V2.xlsx','Sheet','PointSource')
