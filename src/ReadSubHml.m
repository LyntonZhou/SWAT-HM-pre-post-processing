%% Import data from outhml.sub
%% Initialize variables.
filename = 'D:\LingfengZhou\20190309.Sufi2.SwatCup\outhml.sub';
delimiter = ' ';

%% Format for each line of text:
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'EmptyValue', NaN,  'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
%% Create output variable
outhmlsub = [dataArray{1:end-1}];
%% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans;

xlswrite('outhmlsub.xlsx',outhmlsub);