%% Initialize variables.
simNo = 1000;
obsNo1 = 1097;
obsNo2 = 40;
% close all
workdir = 'D:\LingfengZhou\20190309.Sufi2.SwatCup\Iterations\Iter12';
% workdir = 'D:\LingfengZhou\20190324Val.Sufi2.SwatCup\Iterations\Iter9';
filename = [workdir '\Sufi2.Out\FLOW_OUT_66.txt'];
delimiter = ' ';
%% Format for each line of text:
formatSpec = '%f%f%[^\n\r]';
%% Open the text file.
fileID = fopen(filename,'r');
%% Read columns of data according to the format.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'EmptyValue', NaN,  'ReturnOnError', false);
%% Close the text file.
fclose(fileID);
%% Post processing for unimportable data.
%% Create output variable
behFLOWOUT = [dataArray{1:end-1}];
%% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans;

%% Initialize variables.
filename = [workdir '\Sufi2.Out\SED_OUT_66.txt'];
delimiter = ' ';
%% Format for each line of text:
formatSpec = '%f%f%[^\n\r]';
%% Open the text file.
fileID = fopen(filename,'r');
%% Read columns of data according to the format.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'EmptyValue', NaN,  'ReturnOnError', false);
%% Close the text file.
fclose(fileID);
%% Post processing for unimportable data.
%% Create output variable
behSEDOUT = [dataArray{1:end-1}];
%% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans;

%% Import data from text file.
%% Initialize variables.
filename = [workdir '\Sufi2.Out\HM_TOT_OUT_66.txt'];
delimiter = ' ';
%% Format for each line of text:
formatSpec = '%f%f%[^\n\r]';
%% Open the text file.
fileID = fopen(filename,'r');
%% Read columns of data according to the format.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'EmptyValue', NaN,  'ReturnOnError', false);
%% Close the text file.
fclose(fileID);
%% Post processing for unimportable data.
%% Create output variable
behHMTOTOUT = [dataArray{1:end-1}];
%% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans;

behFLOWOUT = reshape(behFLOWOUT,obsNo1,simNo,2);
behSEDOUT = reshape(behSEDOUT,obsNo1,simNo,2);
behHMTOTOUT = reshape(behHMTOTOUT,obsNo2,simNo,2);

load ymd
load obs
for ii=1:simNo
 [behFLOWOUTM(:,ii),~,~] = DailyToMonthly1(behFLOWOUT(2:end,ii,2),ymd(1:1096,:));
 [behSEDOUTM(:,ii),~,~] = DailyToMonthly1(behSEDOUT(2:end,ii,2),ymd(1:1096,:)); 
end  
[ObsFLOWOUTM,~,~] = DailyToMonthly1(flowobsout66(1:1096),ymd(1:1096,:)); 
[ObsSEDOUTM,~,~] = DailyToMonthly1(sedobsout66(1:1096),ymd(1:1096,:)); 

figure
subplot(2,1,1)
plot(max(behFLOWOUTM'),'b','LineWidth',2)
plot(quantile(behFLOWOUTM',0.975),'k','LineWidth',2)
hold on 
plot(min(behFLOWOUTM'),'b','LineWidth',2)
plot(quantile(behFLOWOUTM',0.025),'k','LineWidth',2)
scatter(1:36,ObsFLOWOUTM,'r','filled')

subplot(2,1,2)
plot(max(behSEDOUTM'),'b','LineWidth',2)
plot(quantile(behSEDOUTM',0.975),'k','LineWidth',2)
hold on 
plot(min(behSEDOUTM'),'b','LineWidth',2)
plot(quantile(behSEDOUTM',0.025),'k','LineWidth',2)
scatter(1:36,ObsSEDOUTM,'r','filled')

[pp,rr]=prfactor(quantile(behFLOWOUTM',0.975),quantile(behFLOWOUTM',0.025), ...
   ObsFLOWOUTM,0.1);
[pp,rr]=prfactor(quantile(behSEDOUTM',0.975),quantile(behSEDOUTM',0.025), ...
   ObsSEDOUTM,0.1);
nscoeff([(quantile(behSEDOUTM',0.975))',ObsSEDOUTM])