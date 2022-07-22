function outputsub = readoutputsub(projdir,iprint)

%% Initialize variables.
    startRow = 7;
    endRow = inf;

%% Read columns of data as text:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%6s%4s%9s%5s%11s%10s%10s%10s%10s%10s%10s%10s%10s%10s%10s%[^\n\r]';

%% Open the text file.
filename = [projdir '\output.sub'];
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
textscan(fileID, '%[^\n\r]', startRow(1)-1, 'WhiteSpace', '', 'ReturnOnError', false);
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'ReturnOnError', false, 'EndOfLine', '\r\n');
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

%% Convert the contents of columns containing numeric text to numbers.
% Replace non-numeric text with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[2,3,4,5,6,7,8,9,10,11,12,13,14,15]
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


%% Split data into numeric and string columns.
rawNumericColumns = raw(:, [2,3,4,5,6,7,8,9,10,11,12,13,14,15]);
rawStringColumns = string(raw(:, 1));


%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells

%% Make sure any text containing <undefined> is properly converted to an <undefined> categorical
idx = (rawStringColumns(:, 1) == "<undefined>");
rawStringColumns(idx, 1) = "";

%% Create output variable
outputsub = table;
outputsub.VarName1 = categorical(rawStringColumns(:, 1));
outputsub.VarName2 = cell2mat(rawNumericColumns(:, 1));
outputsub.VarName3 = cell2mat(rawNumericColumns(:, 2));
outputsub.VarName4 = cell2mat(rawNumericColumns(:, 3));
outputsub.VarName5 = cell2mat(rawNumericColumns(:, 4));
outputsub.VarName6 = cell2mat(rawNumericColumns(:, 5));
outputsub.VarName7 = cell2mat(rawNumericColumns(:, 6));
outputsub.VarName8 = cell2mat(rawNumericColumns(:, 7));
outputsub.VarName9 = cell2mat(rawNumericColumns(:, 8));
outputsub.VarName10 = cell2mat(rawNumericColumns(:, 9));
outputsub.VarName11 = cell2mat(rawNumericColumns(:, 10));
outputsub.VarName12 = cell2mat(rawNumericColumns(:, 11));
outputsub.VarName13 = cell2mat(rawNumericColumns(:, 12));
outputsub.VarName14 = cell2mat(rawNumericColumns(:, 13));
outputsub.VarName15 = cell2mat(rawNumericColumns(:, 14));

