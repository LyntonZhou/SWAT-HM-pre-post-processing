%% Import data from text file.
clc
clear 
% close all
%% Initialize variables.
% filename = 'D:\LingfengZhou\20190324Cal.Sufi2.SwatCup\SUFI2.OUT\goal.txt';
filename = 'D:\LingfengZhou\20190309.Sufi2.SwatCup\SUFI2.OUT\goal.txt';
filename = 'D:\LingfengZhou\20190309.Sufi2.SwatCup\Iterations\Iter12\Sufi2.Out\goal.txt';
% filename = 'D:\LingfengZhou\20190309.Sufi2.SwatCup\Iterations\KGE_T_0.3\Sufi2.Out\goal.txt';
delimiter = ' ';
startRow = 5;

%% Format for each line of text:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
%% Create output variable
parsgoal = [dataArray{1:end-1}];
%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

idx_beh=parsgoal(:,end)>0.5;

%% Import data from text file.
%% Initialize variables.
% filename = 'D:\LingfengZhou\20190324Cal.Sufi2.SwatCup\SUFI2.OUT\outhmlsum.sub';
filename = 'D:\LingfengZhou\20190309.Sufi2.SwatCup\SUFI2.OUT\outhmlsum.rch';
filename = 'D:\LingfengZhou\20190309.Sufi2.SwatCup\Iterations\Iter12\Sufi2.Out\outhmlsum.rch';
% filename = 'D:\LingfengZhou\20190309.Sufi2.SwatCup\Iterations\KGE_T_0.3\Sufi2.Out\outhmlsum.sub';

delimiter = ' ';

%% Format for each line of text:
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue', NaN,  'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
%% Create output variable
outhmlsum = [dataArray{1:end-1}];
%% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans;

% areaBasin = 198859.6413; % ha
areaBasin = 1; % ha

outhmlsum([1:2:end],:)=[];
outhmlsum = outhmlsum/areaBasin/6; % 6 years kg/yr
figure
subplot(1,3,[1,2])
h_box=boxplot([outhmlsum(idx_beh,10),outhmlsum(idx_beh,7),outhmlsum(idx_beh,8),outhmlsum(idx_beh,9)] ,...
    'labels',{'Dif','Set','Res','Bur'}, ...
    'Colors',[27/256 158/256 119/256;27/256 158/256 119/256; ...
    217/256 95/256 2/256;117/256 112/256 179/256]);
    %'Colors','bbrr');
set(h_box,'LineWidth',2.5)
   
box_vars = findall(gca,'Tag','Box');
hLegend = legend(box_vars([4,2,1]), {'Input','Output','Internal'}, ...
                 'Location','NorthWest', ...
                 'FontSize',16);
legend boxoff;             
xlabel('Input and output pathways in channel bed sediment','FontSize',16);
ylabel('Input and output flux of Zn (kg yr^-^1)','FontSize',16);

[f,x]=ecdf((outhmlsum(idx_beh,7)-outhmlsum(idx_beh,8)+outhmlsum(idx_beh,10)));
subplot(1,3,3)
plot(x,f,'LineWidth',2.5,'Color','k');
hold on
% x_zero=x(x==0);
% f_zero=f(x==0);
% yTickvalues=[0,0.25,0.5,0.75,1];
% yTickvalues=[yTickvalues,f_zero];
% yTickvalues=sort(yTickvalues);
% plot([x_zero,x_zero],[0,f_zero],'LineWidth',2,'Color','k','LineStyle','--');
% plot([-600,x_zero],[f_zero,f_zero],'LineWidth',2,'Color','k','LineStyle','--');
% set(gca,'Ytick',yTickvalues);
% set(gca,'YTickLabel',{num2str(roundn(yTickvalues(1),-2)),num2str(roundn(yTickvalues(2),-2)), ...
%     num2str(roundn(yTickvalues(3),-2)),num2str(roundn(yTickvalues(4),-2)), ...
%     num2str(roundn(yTickvalues(5),-2)),num2str(roundn(yTickvalues(6),-2))},'FontSize',10);
xlabel('Net Zn balance (kg yr^-^1)','FontSize',16);
ylabel('CDF cumulative distribution function','FontSize',16);

figure
plot(x,1-f,'LineWidth',2);

prctile([outhmlsum(idx_beh,7:10)],[2.5 5 25 50 75 95 97.5]);

mean(outhmlsum(idx_beh,7:10));

prctile([outhmlsum(idx_beh,7)-outhmlsum(idx_beh,8)],[2.5 5 25 50 75 95 97.5]);
prctile([outhmlsum(idx_beh,7)-outhmlsum(idx_beh,8)+outhmlsum(idx_beh,10)],[2.5 5 25 50 75 95 97.5]);

