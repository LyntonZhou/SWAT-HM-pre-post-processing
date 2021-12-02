%% Import data from outhml.sub file
%% Initialize variables.
% filename = 'E:\SWAT-HM\SWAT-HMV1.1\FinalResults\outhml.sub';
% filename = 'D:\LingfengZhou\20190727.Sufi2.SwatCup\outhml.sub';
filename = 'F:\SWATCUP\LingfengZhou\20190727.Sufi2.SwatCup\outhml.sub';

delimiter = ' ';
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
%% Open the text file.
fileID = fopen(filename,'r');
%% Read columns of data according to format string.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true,  'ReturnOnError', false);
%% Close the text file.
fclose(fileID);
%% Post processing for unimportable data.
%% Create output variable
subhml = [dataArray{1:end-1}];
%% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans;
% xlswrite('subhml.xlsx',subhml,'subhmldaily','A2');

load ymd;
subhmltotaldaily = squeeze(sum(reshape(subhml,79,2192,15)));
[~,subhmltotalmonthly1,~,~]=DailyToMonthly1(subhmltotaldaily(:,5:10),ymd);
subhmltotalmonthly1(:,5)=subhmltotalmonthly1(:,5)+subhmltotalmonthly1(:,6);
subhmltotalmonthly1(:,6)=[];

datestrr =datenum(2011,1,1);
dateend = datenum(2016,12,31);
subhmltotalmonthly = zeros(12,6);
for ii=1:(dateend-datestrr+1)
    subhmltotalmonthly(month(datetime(datestr(datestrr+ii-1))),:)=  ...
        subhmltotalmonthly(month(datetime(datestr(datestrr+ii-1))),:) + subhmltotaldaily(ii,5:10);
end
subhmltotalmonthly(:,5)=subhmltotalmonthly(:,5)+subhmltotalmonthly(:,6);
subhmltotalmonthly(:,6)=[];
subhmltotalmonthly=subhmltotalmonthly/6;
% xlswrite('subhml.xlsx',subhmltotalmonthly,'subhmltotalmonthly');

subhmltotalmonthlyratio=subhmltotalmonthly./repmat(sum(subhmltotalmonthly,2),1,5);
figure
subplot(1,2,1)
bar(subhmltotalmonthly,'stacked');
legend('Surface runoff','Lateral flow','Percolation','Plant uptake','Soil erosion');
legend boxoff
ylabel('Zn (kg)','FontSize',16);% set(gca,'yscale','log');
xlim([0,13]); ylim([0,50000]);
set(gca,'XTickLabel',{'Jan' ;'Feb'; 'Mar'; 'Apr';'May'; ...
    'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'},'FontSize',14);
set(gca,'LineWidth',2);
subplot(1,2,2)
bar(subhmltotalmonthlyratio,'stacked');
% legend('Surface runoff','Lateral flow','Percolation','Soil erosion');
ylabel('Percentage','FontSize',16);
xlim([0,13]); ylim([0,1]);
set(gca,'XTickLabel',{'Jan' ;'Feb'; 'Mar'; 'Apr';'May'; ...
    'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'},'FontSize',14);
set(gca,'LineWidth',2);

sum(subhmltotalmonthly(:,3))./sum(sum(subhmltotalmonthly(:,:)))