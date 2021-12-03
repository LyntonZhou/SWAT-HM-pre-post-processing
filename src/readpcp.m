function [ pcp ] = readpcp(txtinout_dir)
pcpfileid=fopen([txtinout_dir '\pcp1.pcp'],'r');

% matrix size
for ii=1:5
    tline = fgetl(pcpfileid);
end
fclose(pcpfileid);
nstations = (numel(tline)-7)/5;

pcpfileid=fopen([txtinout_dir '\pcp1.pcp'],'r');
for ii=1:4
    tline = fgetl(pcpfileid);
    disp(tline)
end

sizeA = [nstations+2, Inf];
formatSpec = ['%4d%3d',repmat('%5f',1,nstations),'\n']; 
pcp = fscanf(pcpfileid,formatSpec,sizeA);
pcp = pcp';
fclose(pcpfileid);

end



