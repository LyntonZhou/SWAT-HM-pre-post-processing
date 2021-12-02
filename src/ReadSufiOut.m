clc
clear
simNo = 2000;
% behSimNo =674;
obsNo1 = 2192 %1096 %2192;
obsNo2 = 77 %39 %77;
load obs;
load ymd;
workdir = 'D:\LingfengZhou\20190726.Sufi2.SwatCup\Iterations\Iter21';
% workdir = 'D:\LingfengZhou\20190309.Sufi2.SwatCup\Iterations\Iter12';

%% best simulation
filename = [workdir '\Sufi2.Out\best_sim_nr.txt'];
delimiter = ' ';
endRow = 1;
formatSpec = '%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, endRow, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);
bestsimNo = [dataArray{1:end-1}];
clearvars filename delimiter endRow formatSpec fileID dataArray ans;

%% goal txt
filename = [workdir '\Sufi2.Out\goal.txt'];
[parval, goalval, parname] = readgoal(filename);

%% FLow
filename = [workdir '\Sufi2.Out\FLOW_OUT_66.txt'];
delimiter = ' ';
formatSpec = '%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'EmptyValue', NaN,  'ReturnOnError', false);
fclose(fileID);
FLOWOUT66 = [dataArray{1:end-1}];
clearvars filename delimiter formatSpec fileID dataArray ans;

%% Behavioral FLow
% filename = [workdir '\Sufi2.Out\beh_FLOW_OUT_66.txt'];
% delimiter = ' ';
% formatSpec = '%f%f%[^\n\r]';
% fileID = fopen(filename,'r');
% dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'EmptyValue', NaN,  'ReturnOnError', false);
% fclose(fileID);
% behFLOWOUT66 = [dataArray{1:end-1}];
% clearvars filename delimiter formatSpec fileID dataArray ans;

%% Sediment
filename = [workdir '\Sufi2.Out\SED_OUT_66.txt'];
delimiter = ' ';
formatSpec = '%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'EmptyValue', NaN,  'ReturnOnError', false);
fclose(fileID);
SEDOUT66 = [dataArray{1:end-1}];
clearvars filename delimiter formatSpec fileID dataArray ans;

%% Behavioral Sediment
% filename = [workdir '\Sufi2.Out\beh_SED_OUT_66.txt'];
% delimiter = ' ';
% formatSpec = '%f%f%[^\n\r]';
% fileID = fopen(filename,'r');
% dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'EmptyValue', NaN,  'ReturnOnError', false);
% fclose(fileID);
% behSEDOUT66 = [dataArray{1:end-1}];
% clearvars filename delimiter formatSpec fileID dataArray ans;

%% Heavy metal
filename = [workdir '\Sufi2.Out\R-HM_TOT_OUT_66.txt'];
delimiter = ' ';
formatSpec = '%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'EmptyValue', NaN,  'ReturnOnError', false);
fclose(fileID);
HMTOTOUT66 = [dataArray{1:end-1}];
clearvars filename delimiter formatSpec fileID dataArray ans;

FLOWOUT66 = reshape(FLOWOUT66,obsNo1+1,simNo,2);
temp = FLOWOUT66;
FLOWOUT66 = [];
FLOWOUT66 = temp(2:end,:,2);
% behFLOWOUT66 = reshape(behFLOWOUT66,obsNo1+1,behSimNo,2);
SEDOUT66 = reshape(SEDOUT66,obsNo1+1,simNo,2);
temp = SEDOUT66;
SEDOUT66 = [];
SEDOUT66 = temp(2:end,:,2);
% behSEDOUT66 = reshape(behSEDOUT66,obsNo1+1,behSimNo,2);
HMTOTOUT66 = reshape(HMTOTOUT66,obsNo1+1,simNo,2);
temp = HMTOTOUT66;
HMTOTOUT66 = [];
HMTOTOUT66 = temp(2:end,:,2);

%% Best simulation Vs. observation
filename = [workdir '\Sufi2.Out\best_sim.txt'];
delimiter = ' ';
formatSpec = '%s%s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string',  'ReturnOnError', false);
fclose(fileID);
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));
for col=[1,2]
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^[-/+]*\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric text to numbers.
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells
bestobssim = raw;
clearvars filename delimiter formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp R;
bestobssim=cell2mat(bestobssim);

idx=find(isnan(bestobssim(:,1)));
obsFLOW66 = bestobssim((idx(1)+1):(idx(2)-2),1);
obsSED66 = bestobssim((idx(2)+1):(idx(3)-2),1);
obsHMTOT66 = bestobssim((idx(3)+1):end,1);
obsHMTOT66_idx = hmlobsconc66(:,1);

simbestFLOW = bestobssim((idx(1)+1):(idx(2)-2),2);
simbestSED = bestobssim((idx(2)+1):(idx(3)-2),2);
simbestHMTOT = bestobssim((idx(3)+1):end,2);

%% subbasin heavy metal
filename = [workdir '\Sufi2.Out\outhmlsum.sub'];
delimiter = ' ';
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue', NaN,  'ReturnOnError', false);
fclose(fileID);
outhmlsum = [dataArray{1:end-1}];
clearvars filename delimiter formatSpec fileID dataArray ans;

areaBasin = 198859.6413; % ha
% areaBasin = 1; % ha

outhmlsum([1:2:end],:)=[];
outhmlsubsum = outhmlsum/areaBasin/6*1000; % 6 years 

%% river reach heavy metal
filename = [workdir '\Sufi2.Out\outhmlsum.rch'];
delimiter = ' ';
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue', NaN,  'ReturnOnError', false);
fclose(fileID);
outhmlsum = [dataArray{1:end-1}];
clearvars filename delimiter formatSpec fileID dataArray ans;

% areaBasin = 198859.6413; % ha
areaBasin = 1; % ha

outhmlsum([1:2:end],:)=[];
outhmlrchsum = outhmlsum/areaBasin/6; % 6 years kg/yr

%% Monthly data
for ii=1:simNo
 [FLOWOUT66M(:,ii),~,~] = DailyToMonthly1(FLOWOUT66(:,ii),ymd);
 [SEDOUT66M(:,ii),~,~] = DailyToMonthly1(SEDOUT66(:,ii),ymd); 
end  
[ObsFLOW66M,~,~] = DailyToMonthly1(obsFLOW66,ymd); 
[ObsSED66M,~,~] = DailyToMonthly1(obsSED66,ymd);

%%
filename = 'D:\LingfengZhou\Post-processing\obshm.txt';
delimiter = '\t';
formatSpec = '%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string',  'ReturnOnError', false);
fclose(fileID);
obshm = [dataArray{1:end-1}];
obsHMTOT66 = obshm(:,2);
obsHMTOT66_idx = obshm(:,1);
clearvars filename delimiter formatSpec fileID dataArray ans;

save simobs FLOWOUT66 SEDOUT66 HMTOTOUT66 ...
obsFLOW66 obsSED66 obsHMTOT66 obsHMTOT66_idx ...
simbestFLOW simbestSED simbestHMTOT bestsimNo simNo ...
parval goalval parname ...
outhmlsubsum outhmlrchsum ...
FLOWOUT66M SEDOUT66M ObsFLOW66M ObsSED66M
