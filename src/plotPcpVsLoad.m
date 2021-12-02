% Initialize variables.
filename = 'F:\SWATCUP\LingfengZhou\Post-processing\Tmp1.Tmp';
startRow = 5;
% Format string for each line of text:
formatSpec = '%4f%3f%5f%5f%5f%5f%[^\n\r]';
% Open the text file.
fileID = fopen(filename,'r');
%% Read columns of data according to format string.
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
% Close the text file.
fclose(fileID);
% Post processing for unimportable data.
% Create output variable
Tmpdaily = [dataArray{1:end-1}];
% Clear temporary variables
clearvars filename startRow formatSpec fileID dataArray ans;
Tmpdaily(1:1096,:)=[];
Tmpdaily(:,1:2)=[];

load ymd;
[Tmpmonthly1,~,~,~]=DailyToMonthly1(Tmpdaily,ymd);

%% Import data from text file.
% Initialize variables.
filename = 'F:\SWATCUP\LingfengZhou\Post-processing\pcp1.pcp';
startRow = 5;
% Read columns of data as strings:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%4s%3s%5s%5s%5s%5s%5s%5s%5s%5s%5s%[^\n\r]';
% Open the text file.
fileID = fopen(filename,'r');
% Read columns of data according to format string.
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
% Close the text file.
fclose(fileID);
% Convert the contents of columns containing numeric strings to numbers.
% Replace non-numeric strings with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2,3,4,5,6,7,8,9,10,11,12]
    % Converts strings in the input cell array to numbers. Replaced non-numeric
    % strings with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(thousandsRegExp, ',', 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric strings to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end

% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

%% Create output variable
pcpdaily = cell2mat(raw);
%% Clear temporary variables
clearvars filename startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me R;
pcpdaily(1:1096,:)=[];
pcpdaily(:,1:2)=[];

% datestrr =datenum(2011,1,1);
% dateend = datenum(2016,12,31);
% pcpmonthly = zeros(12,9);
% for ii=1:(dateend-datestrr+1)
%     pcpmonthly(month(datetime(datestr(datestrr+ii-1))),:)=  ...
%         pcpmonthly(month(datetime(datestr(datestrr+ii-1))),:) + pcpdaily(ii,1:9);
% end
% pcpmonthly=pcpmonthly/6;

[~,pcpmonthly1,~,~]=DailyToMonthly1(pcpdaily,ymd);

figure 
hold on
legendtext={'(a) Surface runoff (kg)','(b) Lateral flow (kg)', ...
    '(c) Percolation (kg)', '(d) Plant uptake (kg)','(e) Soil erosion (kg)'};
for ii=1:5
subplot(2,3,ii)
scatter(mean(pcpmonthly1,2),subhmltotalmonthly1(:,ii),50,'filled');
xlabel('Pcp (mm)','FontSize',16);ylabel(legendtext{ii},'FontSize',16);
% legend(legendtext{ii});
% legend boxoff;
box on
set(gca,'LineWidth',2);
end
subplot(2,3,6)
scatter(mean(Tmpmonthly1,2),subhmltotalmonthly1(:,4),50,'filled');
xlabel('Tmp (^oC)','FontSize',16);ylabel('(f) plant uptake (kg)','FontSize',16);
box on
set(gca,'LineWidth',2);
% legend(legendtext{4});
% legend boxoff;

figure 
hold on
legendtext={'(a) Surface runoff (kg)','(b) Lateral flow (kg)', ...
    '(c) Percolation (kg)', '(d) Plant uptake (kg)','(e) Soil erosion (kg)'};
for ii=1:5
subplot(2,3,ii)
scatter(mean(pcpmonthly1,2),subhmltotalmonthly1(:,ii),50,'filled');
xlabel('Pcp (mm)','FontSize',16);ylabel(legendtext{ii},'FontSize',16);
% legend(legendtext{ii});
% legend boxoff;
box on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
end

figure 
hold on
legendtext={'(a) Surface runoff (kg)','(b) Lateral flow (kg)', ...
    '(c) Percolation (kg)', '(d) Plant uptake (kg)','(e) Soil erosion (kg)'};
for ii=1:5
subplot(2,3,ii)
scatter(mean(pcpmonthly1,2),subhmltotalmonthly1(:,ii),50,'filled');
xlabel('Pcp (mm)','FontSize',16);ylabel(legendtext{ii},'FontSize',16);
% legend(legendtext{ii});
% legend boxoff;
box on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
end
subplot(2,3,6)
scatter(mean(pcpmonthly1,2),sum(subhmltotalmonthly1(:,:),2),50,'filled');
xlabel('Pcp (mm)','FontSize',16);ylabel('(f) Total output (kg)','FontSize',16);
box on
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
% legend(legendtext{4});
% legend boxoff;

figure
% subplot(511)
plot(subhmltotalmonthly1(:,1),'LineWidth',2);
xlim([1,72]);
xlabel('month');ylabel('Surface runoff  kg');
figure
% subplot(512)
plot(subhmltotalmonthly1(:,2),'LineWidth',2);
xlim([1,72]);
xlabel('month');ylabel('Lateral flow  kg');
figure
% subplot(513)
plot(subhmltotalmonthly1(:,3),'LineWidth',2);
xlim([1,72]);
xlabel('month');ylabel('Percolation  kg');
figure
% subplot(514)
plot(subhmltotalmonthly1(:,4),'LineWidth',2);
xlim([1,72]);
xlabel('month');ylabel('plant uptake  kg');
figure
% subplot(515)
plot(subhmltotalmonthly1(:,5),'LineWidth',2);
xlim([1,72]);
xlabel('month');ylabel('Soil erosion  kg');