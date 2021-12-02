%% @Lingfeng Zhou

clc
clear
promdir = pwd;
projdir = 'E:\SWAT-HM\SWAT-HMV1.1\20190307.Sufi2.SwatCup'; % folder of SWAT-HM project

%% read file.cio
filename = [projdir '\file.cio'];
fileid=fopen(filename,'r');
for ii=1:7
    fgetl(fileid);
end
nyr = fscanf(fileid,'%f     %*s'); % | NBYR : Number of years simulated
fgetl(fileid);
syr1 = fscanf(fileid,'%f     %*s');
eyr = syr1 + nyr - 1;
for ii=1:50
    fgetl(fileid);
end
iprint = fscanf(fileid,'%f     %*s'); % | IPRINT: print code (month, day, year)
fgetl(fileid);
nyskip = fscanf(fileid,'%f     %*s'); % | NYSKIP: number of years to skip output printing/summarization
syr2 = syr1 + nyskip;
fclose(fileid);

SubNo = numel(dir([projdir '\0*.sub']));
HruNo = numel(dir([projdir '\0*.hru']));

%% read outhml.rch
filename = [projdir '\outhml.rch'];
delimiter = ' ';
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN, 'ReturnOnError', false);
fclose(fileID);
outhmlrch = [dataArray{1:end-1}];
clearvars filename delimiter formatSpec fileID dataArray ans; % Clear temporary variables

header_rch={' RCH','    YEAR','  MON','     AREAkm2'...
    '  DISHM_INkg','  LabHM_INkg',' NLabHM_INkg', ...
    ' DISHM_OUTkg',' LabHM_OUTkg','NLabHM_OUTkg', ...
    '    SET_HMkg','    RES_HMkg','    MIX_HMkg','    BUR_HMkg', ...
    '  DISHM_CONC','  LabHM_CONC',' NLabHM_CONC'};

if (iprint == 0) % Monthly
    
    outhmlrch = reshape(outhmlrch,SubNo,13*(nyr-nyskip),17);
    outhmlrch(:,(13:13:78),:) = [];
    outhmlrch = reshape(outhmlrch,SubNo*12*(nyr-nyskip),17);
    filename = [promdir '\outhml2.rch'];
    fid1=fopen(filename,'w');
    formatSpec = '%s %s %s %s%s%s%s%s%s%s%s%s%s%s%s%s%s\n';
    fprintf(fid1, formatSpec, header_rch{1:17});
    formatSpec = '%4i %8i %5i %12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e\n';
    for ii=1:numel(outhmlrch(:,1))
        fprintf(fid1, formatSpec, outhmlrch(ii,:));
    end
    fclose(fid1);
    
elseif (iprint == 1)   % Daily
    filename = [promdir '\outhml2.rch'];
    fid1=fopen(filename,'w');
    formatSpec = '%s %s %s %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n';
    fprintf(fid1, formatSpec, header_rch{1:17});
    formatSpec = '%4i %8i %5i %12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e\n';
    for ii=1:numel(outhmlrch(:,1))
        fprintf(fid1, formatSpec, outhmlrch(ii,:));
    end
    fclose(fid1);
    
elseif (iprint == 2)  % Yearly
    filename = [promdir '\outhml2.rch'];
    fid1=fopen(filename,'w');
    formatSpec = '%s %s %s %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n';
    fprintf(fid1, formatSpec, header_rch{1:17});
    formatSpec = '%4i %8i %5i %12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e\n';
    for ii=1:numel(outhmlrch(:,1))
        fprintf(fid1, formatSpec, outhmlrch(ii,:));
    end
    fclose(fid1);
end

%% read outhml.sub
filename = [projdir '\outhml.sub'];
delimiter = ' ';
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN, 'ReturnOnError', false);
fclose(fileID);
outhmlsub = [dataArray{1:end-1}];
clearvars filename delimiter formatSpec fileID dataArray ans; % Clear temporary variables

header_sub={' SUB','    YEAR','  MON','     AREAkm2'...
    '   HM_SURQkg','    HM_LATkg','   HM_PERCkg','  HM_PLANTkg', ...
    ' LabHM_EROkg','NLabHM_EROkg','   HM_ATMOkg','   HM_WETHkg', ...
    '    HM_AGRkg','   HM_TOTINkg','HM_TOTOUTkg'};

if (iprint == 0) % Monthly
    
    outhmlsub = reshape(outhmlsub,SubNo,13*(nyr-nyskip),15);
    outhmlsub(:,(13:13:78),:) = [];
    outhmlsub = reshape(outhmlsub,SubNo*12*(nyr-nyskip),15);
    filename = [promdir '\outhml2.sub'];
    fid2=fopen(filename,'w');
    formatSpec = '%s %s %s %s%s%s%s%s%s%s%s%s%s%s%s\n';
    fprintf(fid2, formatSpec, header_sub{1:15});
    formatSpec = '%4i %8i %5i %12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e\n';
    for ii=1:numel(outhmlsub(:,1))
        fprintf(fid2, formatSpec, outhmlsub(ii,:));
    end
    fclose(fid2);
    
elseif (iprint == 1)   % Daily
    filename = [promdir '\outhml2.sub'];
    fid2=fopen(filename,'w');
    formatSpec = '%s %s %s %s%s%s%s%s%s%s%s%s%s%s%s\n';
    fprintf(fid2, formatSpec, header_sub{1:15});
    formatSpec = '%4i %8i %5i %12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e\n';
    for ii=1:numel(outhmlsub(:,1))
        fprintf(fid2, formatSpec, outhmlsub(ii,:));
    end
    fclose(fid2);
    
elseif (iprint == 2)  % Yearly
    filename = [promdir '\outhml2.sub'];
    fid2=fopen(filename,'w');
    formatSpec = '%s %s %s %s%s%s%s%s%s%s%s%s%s%s%s\n';
    fprintf(fid2, formatSpec, header_sub{1:15});
    formatSpec = '%4i %8i %5i %12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e%12.4e\n';
    for ii=1:numel(outhmlsub(:,1))
        fprintf(fid2, formatSpec, outhmlsub(ii,:));
    end
    fclose(fid2);
end

