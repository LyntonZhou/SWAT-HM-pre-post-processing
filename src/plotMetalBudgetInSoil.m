%% Import data from text file.
clc
clear 
close all
%% Initialize variables.
% filename = 'D:\LingfengZhou\20190324Cal.Sufi2.SwatCup\SUFI2.OUT\goal.txt';
filename = 'D:\LingfengZhou\20190309.Sufi2.SwatCup\SUFI2.OUT\goal.txt';
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

idx_beh=parsgoal(:,end)>0.3;

%% Import data from text file.
%% Initialize variables.
% filename = 'D:\LingfengZhou\20190324Cal.Sufi2.SwatCup\SUFI2.OUT\outhmlsum.sub';
filename = 'D:\LingfengZhou\20190309.Sufi2.SwatCup\SUFI2.OUT\outhmlsum.sub';
% filename = 'D:\LingfengZhou\20190309.Sufi2.SwatCup\Iterations\KGE_T_0.3\Sufi2.Out\outhmlsum.sub';

delimiter = ' ';

%% Format for each line of text:
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

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

areaBasin = 198859.6413; % ha
% areaBasin = 1; % ha

outhmlsum([1:2:end],:)=[];
outhmlsum = outhmlsum/areaBasin/6*1000; % 6 years 
figure
subplot(1,3,[1,2])
% boxplot([outhmlsum(idx_beh,1:4),outhmlsum(idx_beh,5)+outhmlsum(idx_beh,5),outhmlsum(idx_beh,7:9)]);
h_box=boxplot([outhmlsum(idx_beh,1:4),outhmlsum(idx_beh,5)+outhmlsum(idx_beh,6),outhmlsum(idx_beh,7:9)] ,...
    'labels',{'S','L','P','U','E','D','W','A'}, ...
    'Colors',[217/256 95/256 2/256;217/256 95/256 2/256;217/256 95/256 2/256;...
              217/256 95/256 2/256;217/256 95/256 2/256; ...
              27/256 158/256 119/256;27/256 158/256 119/256;27/256 158/256 119/256]);
    %'Colors','rrrrrbbb');  
set(h_box,'LineWidth',2.5)
   
box_vars = findall(gca,'Tag','Box');
hLegend = legend(box_vars([1,6]), {'Input','Onput'}, ...
                 'Location','NorthWest', ...
                 'FontSize',16);
legend boxoff;             
xlabel('Input and output pathways in upland soil','FontSize',16);
ylabel('Input and output flux of Zn (g ha^-^1 yr^-^1)','FontSize',16);

nethml=outhmlsum(idx_beh,11)-outhmlsum(idx_beh,10);
[f,x]=ecdf(nethml);
subplot(1,3,3)
plot(x,f,'LineWidth',2.5,'Color','k');
hold on
x_zero=x(x==0);
f_zero=f(x==0);
yTickvalues=[0,0.25,0.5,0.75,1];
yTickvalues=[yTickvalues,f_zero];
yTickvalues=sort(yTickvalues);
plot([x_zero,x_zero],[0,f_zero],'LineWidth',2,'Color','k','LineStyle','--');
plot([-600,x_zero],[f_zero,f_zero],'LineWidth',2,'Color','k','LineStyle','--');
set(gca,'Ytick',yTickvalues);
set(gca,'YTickLabel',{num2str(roundn(yTickvalues(1),-2)),num2str(roundn(yTickvalues(2),-2)), ...
    num2str(roundn(yTickvalues(3),-2)),num2str(roundn(yTickvalues(4),-2)), ...
    num2str(roundn(yTickvalues(5),-2)),num2str(roundn(yTickvalues(6),-2))},'FontSize',10);
xlabel('Net Zn balance (g ha^-^1 yr^-^1)','FontSize',16);
ylabel('CDF cumulative distribution function','FontSize',16);

figure
plot(x,1-f,'LineWidth',2);

figure
hist((outhmlsum(idx_beh,11)-outhmlsum(idx_beh,10)))

% figure
% for ii=1:31
%     subplot(6,6,ii)
%     scatter(parsgoal(:,ii+1),nethml)
% end
    
prctile([outhmlsum(idx_beh,1:4),outhmlsum(idx_beh,5)+outhmlsum(idx_beh,6), ...
    outhmlsum(idx_beh,7:9)],[2.5 25 50 75 97.5]);

mean([outhmlsum(idx_beh,1:4),outhmlsum(idx_beh,5)+outhmlsum(idx_beh,6), ...
    outhmlsum(idx_beh,7:9)]);

prctile([outhmlsum(idx_beh,11),outhmlsum(idx_beh,10)],[2.5 25 50 75 97.5]);

mean((outhmlsum(idx_beh,9)./outhmlsum(idx_beh,11))./ ...
    (outhmlsum(idx_beh,8)./outhmlsum(idx_beh,11)))
min(outhmlsum(idx_beh,9)./outhmlsum(idx_beh,11))
max(outhmlsum(idx_beh,9)./outhmlsum(idx_beh,11))
min(outhmlsum(idx_beh,8)./outhmlsum(idx_beh,11))
max(outhmlsum(idx_beh,8)./outhmlsum(idx_beh,11))