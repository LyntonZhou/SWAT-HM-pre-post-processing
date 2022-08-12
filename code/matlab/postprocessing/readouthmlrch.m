function outhmlrch = readouthmlrch(txtiodir, iprint)

%% Initialize variables.
startRow = 2;
endRow = inf;

%% Format for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: double (%f)
%   column7: double (%f)
%	column8: double (%f)
%   column9: double (%f)
%	column10: double (%f)
%   column11: double (%f)
%	column12: double (%f)
%   column13: double (%f)
%	column14: double (%f)
%   column15: double (%f)
%	column16: double (%f)
%   column17: double (%f)
formatSpec = '%4f%8f%6f%13f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%f%[^\n\r]';

%% Open the text file.
filename = [txtiodir '\outhml.rch'];
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
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
outhmlrch = table(dataArray{1:end-1}, 'VariableNames', {'RCH','YEAR','MON','AREAkm2','DisHM_INkg','LabHM_INkg','NLabHM_INkg','DisHM_OUTkg','LabHM_OUTkg','NLabHM_OUTkg','HMSETTLkg','HMRESUSPkg','HMLBURYkg','HMLDIFFkg','SedDisHMkgm3','SedLabHMkgm3','SedNLabHMkgm3'});

