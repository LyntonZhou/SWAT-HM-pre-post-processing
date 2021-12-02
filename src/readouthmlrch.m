function outhmlrch = readouthmlrch(projdir,iprint,SubNo,Simlength)

%% Initialize variables.
startRow = 2;
endRow = inf;

%% Format for each line of text:
formatSpec = '%4f%8f%6f%13f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%15f%f%[^\n\r]';

%% Open the text file.
filename = [projdir '\outhml.rch'];
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
outhmlrch = table(dataArray{1:end-1}, 'VariableNames', {'RCH','YEAR','MON','AREAkm2','DisHM_INkg','LabHM_INkg','NLabHM_INkg','DisHM_OUTkg','LabHM_OUTkg','NLabHM_OUTkg','HMSETTLkg','HMRESUSPkg','HMLBURYkg','HMLDIFFkg','SedDisHMkgm3','SedLabHMkgm3','SedNLabHMkgm3'});

outhmlrch = outhmlrch(outhmlrch.MON<13,:);
if (height(outhmlrch)/SubNo - Simlength) == 1
    outhmlrch(end-SubNo+1:end,:)=[];
end
end

