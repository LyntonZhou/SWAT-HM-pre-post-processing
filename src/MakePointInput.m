%% Setup the Import Options
opts = spreadsheetImportOptions("NumVariables", 32);

% Specify sheet and range
opts.Sheet = "Xiang_industry_sub_TableToExcel";
opts.DataRange = "A2:AF27054";

% Specify column names and types
opts.VariableNames = ["FID", "FID_Sheet1", "FID_", "Year", "gridid", "Hg", "Cd", "Cr", "Pb", "As", "gridlat", "gridlng", "FID_Waters", "GRIDCODE", "Subbasin", "Area", "Slo1", "Len1", "Sll", "Csl", "Wid1", "Dep1", "Lat", "Long_", "Elev", "ElevMin", "ElevMax", "Bname", "Shape_Leng", "Shape_Area", "HydroID", "OutletID"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "categorical", "double", "double", "double", "double"];
opts = setvaropts(opts, 28, "EmptyFieldRule", "auto");

% Import the data
Xiangindustrysub = readtable("D:\XiangRiverProject\XiangRiver\1\Inputs\Xiang_industry_sub_TableToExcel.xls", opts, "UseExcel", false);

%% Clear temporary variables
clear opts

MetalPoint = groupsummary(Xiangindustrysub,{'Year','Subbasin'},'sum',{'Cd','Hg','As','Pb','Cr'});

yearS = MetalPoint.Year(1);
yearE = MetalPoint.Year(end);
MetalPointCd = table2array(MetalPoint(:,[1,2,4]));

SubNo = 591;
ndays = datenum(yearE,12,31) - datenum(yearS,1,1) + 1;
for jj = 1:SubNo
    jj
    for ii=1:ndays
         t = datevec(ii+datenum(yearS,1,1)-1);
         t0 = t;
         t0(:,2:3) = 1;
         cuttentYear = t(1);
         doy = datenum(t) - datenum(t0) + 1;
         idx = find(MetalPointCd(:,1)==cuttentYear & MetalPointCd(:,2) == jj);
         MetalPoint2(ii,1) = doy;
         MetalPoint2(ii,2) = cuttentYear;
         if isempty(idx)
             MetalPoint2(ii,jj+2) = 0 ;      
         else 
            MetalPoint2(ii,jj+2) = MetalPointCd(idx,3)/365/1000; %kg
         end
    end
end
names(1)="DAY";
names(2)="YEAR";
for ii=1:SubNo
    names(ii+2)=['SUB' num2str(ii)];
end
MetalPoint2T = array2table(MetalPoint2,'VariableNames',names);

writetable(MetalPoint2T,'HeavyMetalModuleDataBase_XiangRiver.xlsx','Sheet','Point')
