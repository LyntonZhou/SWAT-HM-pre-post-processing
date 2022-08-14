function [MetalPoint_T] = readpointsource(filename,SubNo)
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
% filename = [projdir '\output.sub'];
Xiangindustrysub = readtable(filename, opts, "UseExcel", false);

%% Clear temporary variables
clear opts

MetalPoint = groupsummary(Xiangindustrysub,{'Year','Subbasin'},'sum',{'Cd','Hg','As','Pb','Cr'});
MetalPoint_A = table2array(MetalPoint);
years = unique(MetalPoint.Year);
MetalPoint1 = zeros(numel(years)*SubNo,7);
for ii = 1:numel(years)
    for jj = 1:SubNo
        MetalPoint1(SubNo*(ii-1)+jj,1) = years(ii);
        MetalPoint1(SubNo*(ii-1)+jj,2) = jj;
        idx = find(MetalPoint_A(:,1)==years(ii) & MetalPoint_A(:,2)==jj);
        if isempty(idx)
            MetalPoint1(SubNo*(ii-1)+jj,3:7) = 0;
        else
            MetalPoint1(SubNo*(ii-1)+jj,3) = MetalPoint_A(idx,4)/1000; %Cd
            MetalPoint1(SubNo*(ii-1)+jj,4) = MetalPoint_A(idx,5)/1000000; %Hg
            MetalPoint1(SubNo*(ii-1)+jj,5:7) = MetalPoint_A(idx,6:8)/1000; %As, Pb, Cr
        end
    end
end
MetalPoint_T = array2table(MetalPoint1,'VariableNames',{'YEAR','SUB','PointCd','PointHg','PointAs','PointPb','PointCr'});

end

