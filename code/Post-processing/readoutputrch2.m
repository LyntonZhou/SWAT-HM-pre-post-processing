function outputrch = readoutputrch2(txtiodir,iprint)

%% Initialize variables.
    startRow = 7;
    endRow = inf;

%% Read columns of data as text:
formatSpec = '%5s%5f%9f%6f%12f%12f%12f%12f%12f%12f%12f%12f%[^\n\r]';

%% Open the text file.
filename = [txtiodir '\output.rch'];
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
textscan(fileID, '%[^\n\r]', startRow(1)-1, 'WhiteSpace', '', 'ReturnOnError', false);
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'EmptyValue', NaN, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    textscan(fileID, '%[^\n\r]', startRow(block)-1, 'WhiteSpace', '', 'ReturnOnError', false);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Create output variable
outputrch = table(dataArray{1:end-1}, 'VariableNames', {'VarName1','VarName2','VarName3','VarName4','VarName5','VarName6','VarName7','VarName8','VarName9','VarName10','VarName11','VarName12'});
% outputrch.VarName1 = categorical(rawStringColumns(:, 1));
% outputrch.VarName2 = cell2mat(rawNumericColumns(:, 1));
% outputrch.VarName3 = cell2mat(rawNumericColumns(:, 2));
% outputrch.VarName4 = cell2mat(rawNumericColumns(:, 3));
% outputrch.VarName5 = cell2mat(rawNumericColumns(:, 4));
% outputrch.VarName6 = cell2mat(rawNumericColumns(:, 5));
% outputrch.VarName7 = cell2mat(rawNumericColumns(:, 6));
% outputrch.VarName8 = cell2mat(rawNumericColumns(:, 7));
% outputrch.VarName9 = cell2mat(rawNumericColumns(:, 8));
% outputrch.VarName10 = cell2mat(rawNumericColumns(:, 9));
% outputrch.VarName11 = cell2mat(rawNumericColumns(:, 10));
% outputrch.VarName12 = cell2mat(rawNumericColumns(:, 11));
outputrch.Properties.VariableNames{'VarName2'} = 'RCH';
outputrch.Properties.VariableNames{'VarName3'} = 'YEAR';
outputrch.Properties.VariableNames{'VarName4'} = 'MON';
outputrch.Properties.VariableNames{'VarName5'} = 'AREAkm2';
outputrch.Properties.VariableNames{'VarName6'} = 'FLOW_INcms';
outputrch.Properties.VariableNames{'VarName7'} = 'FLOW_OUTcms';
outputrch.Properties.VariableNames{'VarName8'} = 'EVAPcms';
outputrch.Properties.VariableNames{'VarName9'} = 'TLOSScms';
outputrch.Properties.VariableNames{'VarName10'} = 'SED_INtons';
outputrch.Properties.VariableNames{'VarName11'} = 'SED_OUTtons';
outputrch.Properties.VariableNames{'VarName12'} = 'SEDCONCmgkg';

