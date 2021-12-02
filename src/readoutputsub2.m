function outputsub = readoutputsub2(projdir,iprint,SubNo,Simlength)

%% Initialize variables.
    startRow = 7;
    endRow = inf;

%% Format for each line of text:
formatSpec = '%6C%4f%9f%5f%11f%10f%10f%10f%10f%10f%10f%10f%10f%10f%10f%10f%10f%10f%10f%10f%10f%[^\n\r]';

%% Open the text file.
filename = [projdir '\output.sub'];
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
textscan(fileID, '%[^\n\r]', startRow(1)-1, 'WhiteSpace', '', 'ReturnOnError', false);
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'EmptyValue', NaN, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    textscan(fileID, '%[^\n\r]', startRow(block)-1, 'WhiteSpace', '', 'ReturnOnError', false);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'EmptyValue', NaN, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Create output variable
outputsub = table(dataArray{1:end-1}, 'VariableNames', {'VarName1','VarName2','VarName3','VarName4','VarName5','VarName6','VarName7','VarName8','VarName9','VarName10','VarName11','VarName12','VarName13','VarName14','VarName15','VarName16','VarName17','VarName18','VarName19','VarName20','VarName21'});
outputsub.Properties.VariableNames{'VarName2'} = 'SUB';
outputsub.Properties.VariableNames{'VarName3'} = 'YEAR';
outputsub.Properties.VariableNames{'VarName4'} = 'MON';
outputsub.Properties.VariableNames{'VarName5'} = 'AREAkm2';
outputsub.Properties.VariableNames{'VarName6'} = 'PRECIPmm';
outputsub.Properties.VariableNames{'VarName7'} = 'SNOMELTmm';
outputsub.Properties.VariableNames{'VarName8'} = 'PETmm';
outputsub.Properties.VariableNames{'VarName9'} = 'ETmm';
outputsub.Properties.VariableNames{'VarName10'} = 'SWmm';
outputsub.Properties.VariableNames{'VarName11'} = 'PERCmm';
outputsub.Properties.VariableNames{'VarName12'} = 'SURQmm';
outputsub.Properties.VariableNames{'VarName13'} = 'GW_Qmm';
outputsub.Properties.VariableNames{'VarName14'} = 'WYLDmm';
outputsub.Properties.VariableNames{'VarName15'} = 'SYLDtha';
outputsub.Properties.VariableNames{'VarName16'} = 'ORGNkgha';
outputsub.Properties.VariableNames{'VarName17'} = 'ORGPkgha';
outputsub.Properties.VariableNames{'VarName18'} = 'NSURQkgha';
outputsub.Properties.VariableNames{'VarName19'} = 'SOLPkgha';
outputsub.Properties.VariableNames{'VarName20'} = 'SEDPkgha';
outputsub.Properties.VariableNames{'VarName21'} = 'LATQmm';

outputsub = outputsub(outputsub.MON<13,:);
if (height(outputsub)/SubNo - Simlength) == 1
    outputsub(end-SubNo+1:end,:)=[];
end
end

