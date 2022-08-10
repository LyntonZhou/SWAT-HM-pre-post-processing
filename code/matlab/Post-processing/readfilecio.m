function [iprint,nyskip,SubNo,HruNo] = readfilecio(projdir)

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

end

