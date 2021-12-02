%% Initialize variables.
clear
close all
simNo = 500;
obsNo1 = 2193;
obsNo2 = 78;
% close all
% workdir = 'D:\LingfengZhou\20190309.Sufi2.SwatCup\Iterations\Iter12';
workdir = 'D:\LingfengZhou\20190726.Sufi2.SwatCup\Iterations\Iter2';
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

%% Import data from text file.
%% Initialize variables.
filename = [workdir '\Sufi2.Out\best_sim.txt'];
delimiter = ' ';

%% Read columns of data as text:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string',  'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric text to numbers.
% Replace non-numeric text with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2]
    % Converts text in the input cell array to numbers. Replaced non-numeric
    % text with NaN.
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


%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

%% Create output variable
bestobssim = raw;
%% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp R;
bestobssim=cell2mat(bestobssim);
idx=find(isnan(bestobssim(:,1)));

observedFLOW = bestobssim((idx(1)+1):(idx(2)-2),1);
observedSED = bestobssim((idx(2)+1):(idx(3)-2),1);
observedHMTOT = bestobssim((idx(3)+1):end,1);

ns=cell(1,3);
ns_temp=[];
for jj=1:simNo
    ns_temp{jj}=nscoeff([observedFLOW,behFLOWOUT(2:end,jj,2)]);
end
ns{1,1}=ns_temp';
ns_temp=[];
for jj=1:simNo
    ns_temp{jj}=nscoeff([observedSED,behSEDOUT(2:end,jj,2)]);
end
ns{1,2}=ns_temp';
ns_temp=[];
for jj=1:simNo
    ns_temp{jj}=nscoeff([observedHMTOT,behHMTOTOUT(2:end,jj,2)]);
end
ns{1,3}=ns_temp';

% figure
% subplot(311)
% hist(cell2mat(ns{1,1}),20)
% title('NS histogram streamflow')
% xlim([-1,1]);
% subplot(312)
% hist(cell2mat(ns{1,2}),20)
% title('NS histogram sediment load')
% xlim([-1,1]);
% subplot(313)
% hist(cell2mat(ns{1,3}),20)
% xlim([-1,1]);
% title('NS histogram Zn load')

pb=cell(1,3);
pb_temp=[];
for jj=1:simNo
    pb_temp{jj}=pbias([observedFLOW,behFLOWOUT(2:end,jj,2)]);
end
pb{1,1}=pb_temp';
pb_temp=[];
for jj=1:simNo
    pb_temp{jj}=pbias([observedSED,behSEDOUT(2:end,jj,2)]);
end
pb{1,2}=pb_temp';
pb_temp=[];
for jj=1:simNo
    pb_temp{jj}=pbias([observedHMTOT,behHMTOTOUT(2:end,jj,2)]);
end
pb{1,3}=pb_temp';

% figure
% subplot(311)
% hist(cell2mat(pb{1,1}),20)
% title('pbias histogram streamflow')
% xlim([-1,1]);
% subplot(312)
% hist(cell2mat(pb{1,2}),20)
% title('pbias histogram sediment load')
% xlim([-1,1]);
% subplot(313)
% hist(cell2mat(pb{1,3}),20)
% title('pbias histogram Zn load')
% xlim([-1,1]);

RR=cell(1,3);
RR_temp=[];
for jj=1:simNo
    rho=corr([observedFLOW,behFLOWOUT(2:end,jj,2)]);
    RR_temp{jj}=(rho(1,2))^2;
end
RR{1,1}=RR_temp';
RR_temp=[];
for jj=1:simNo
    rho=corr([observedSED,behSEDOUT(2:end,jj,2)]);
    RR_temp{jj}=(rho(1,2))^2;
end
RR{1,2}=RR_temp';
RR_temp=[];
for jj=1:simNo
    rho=corr([observedHMTOT,behHMTOTOUT(2:end,jj,2)]);
    RR_temp{jj}=(rho(1,2))^2;
end
RR{1,3}=RR_temp';

% figure
% subplot(311)
% hist(cell2mat(RR{1,1}),20)
% hold on
% xlim([0,1]);
% title('R2 histogram streamflow')
% % subplot(312)
% hist(cell2mat(RR{1,2}),20)
% xlim([0,1]);
% title('R2 histogram sediment load')
% subplot(313)
% hist(cell2mat(RR{1,3}),20,'FaceColor','g')
% xlim([0,1]);
% title('R2 histogram Zn load')


% filename = [workdir '\Sufi2.Out\goal.txt'];
% [goal,parname] = readgoal(filename);
% objfn={'NS','pbias','R2'};
% for jj=1:3
%     for kk=1:3
%         mkdir(['D:\LingfengZhou\Post-processing\scatterplots-' objfn{jj} '-' num2str(kk)]);
%         for ii=1:31
%             fig=figure;
%             if jj==1
%                 scatter(goal(:,ii+1),cell2mat(ns{1,kk}),45,'filled');
%                 ylabel('NS');box on;
%             elseif jj==2
%                 scatter(goal(:,ii+1),cell2mat(pb{1,kk}),45,'filled');
%                 ylabel('pbias');box on;
%             else
%                 scatter(goal(:,ii+1),cell2mat(RR{1,kk}),45,'filled');
%                 ylabel('R2');box on;
%             end
%             set(gca,'LineWidth',2.5);
%             tltname=parname{ii+1};
%             legend(tltname);
%             saveas(fig,['D:\LingfengZhou\Post-processing\scatterplots-' objfn{jj} '-' num2str(kk) '\' num2str(ii) '.jpg']);
%             close all
%         end
%     end
% end

filename = [workdir '\Sufi2.Out\goal.txt'];
[goal,parname] = readgoal(filename);
objfn={'NS','pbias','R2'};
for jj=1:3
    for kk=1:3
        mkdir(['D:\LingfengZhou\Post-processing\scatterplots-' objfn{jj} '-' num2str(kk)]);
        figure
        for ii=1:31
%             fig=figure;
            if jj==1
                subplot(4,8,ii)
                scatter(goal(:,ii+1),cell2mat(ns{1,kk}),45,'filled');
                ylabel('NS');box on;
            elseif jj==2
                scatter(goal(:,ii+1),cell2mat(pb{1,kk}),45,'filled');
                ylabel('pbias');box on;
            else
                scatter(goal(:,ii+1),cell2mat(RR{1,kk}),45,'filled');
                ylabel('R2');box on;
            end
            set(gca,'LineWidth',2.5);
            tltname=parname{ii+1};
            legend(tltname);
%             saveas(fig,['D:\LingfengZhou\Post-processing\scatterplots-' objfn{jj} '-' num2str(kk) '\' num2str(ii) '.jpg']);
%             close all
        end
    end
end