function outhmlsub = readouthmlsub(projdir,iprint)
%% Initialize variables.

startRow = 2;
endRow = inf;

%% Format for each line of text:
formatSpec = '%4f%8f%6f%13f%13f%13f%13f%13f%13f%13f%13f%13f%13f%13f%13f%f%[^\n\r]';

%% Open the text file.
filename = [projdir '\outhml.sub'];
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Create output variable
outhmlsub = table(dataArray{1:end-1}, 'VariableNames', {'SUB','YEAR','MON','AREAkm2','HM_SURQkg','HM_LATkg','HM_PERCkg','HM_PLANTkg','HM_GWkg','LabHM_EROkg','NLabHM_EROkg','HM_ATMOkg','HM_WETHkg','HM_AGRkg','HM_INkg','HM_OUTkg'});

