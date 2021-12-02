function [MetalPoint_T,GridID] = readpointsource2(filename,SubNo)
%% Setup the Import Options

XiangindustrysubmonthlyTableToExcel = readtable(filename);

% GridID = [XiangindustrysubmonthlyTableToExcel.gridid,XiangindustrysubmonthlyTableToExcel.Subbasin];
GridID = unique(XiangindustrysubmonthlyTableToExcel(:,[16,22]));
%% Clear temporary variables
clear opts

MetalPoint = groupsummary(XiangindustrysubmonthlyTableToExcel,{'Year','Subbasin'},'sum',{'Y1','Y2','Y3','Y4','Y5','Y6','Y7','Y8','Y9','Y10','Y11','Y12'});
MetalPoint_A = table2array(MetalPoint);
years = unique(MetalPoint.Year);
MetalPoint1 = zeros(numel(years)*12*SubNo,4);
count = 0;
for ii = 1:numel(years)
    for kk = 1:12
        for jj = 1:SubNo
            count = count + 1;
            MetalPoint1(count,1) = years(ii);
            MetalPoint1(count,2) = kk;
            MetalPoint1(count,3) = jj;
            idx = find(MetalPoint_A(:,1)==years(ii) & MetalPoint_A(:,2)==jj);
            if isempty(idx)
                MetalPoint1(count,4) = 0;
            else
                MetalPoint1(count,4) = MetalPoint_A(idx,kk+3)/1000; %Cd
            end
        end
    end
end
MetalPoint_T = array2table(MetalPoint1,'VariableNames',{'YEAR','MON','SUB','Point'});

end

