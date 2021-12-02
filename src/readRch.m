function outRch = readRch(workdir)
%%   @Lingfeng Zhou
% clear all
%% read reach flow sediment data
filename =[workdir '\output.rch'];
delimiter = {'\t',' '};
startRow = 6;
formatSpec = '%*37s%12f%12f%12f%12f%12f%12f%12f%[^\n\r]';
fileID = fopen(filename,'r');
textscan(fileID, '%[^\n\r]', startRow-1, 'ReturnOnError', false);
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'EmptyValue' ,NaN,'ReturnOnError', false);
fclose(fileID);
outRch = [dataArray{1:end-1}];
outRch=reshape(outRch,7,4018,7);
clearvars filename delimiter startRow formatSpec fileID dataArray ans;
end
