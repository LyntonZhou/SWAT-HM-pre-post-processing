function [ tmp ] = readtmp(txtinout_dir)
tmpfileid=fopen([txtinout_dir '\Tmp1.Tmp'],'r');

% matrix size
for ii=1:5
    tline = fgetl(tmpfileid);
end
fclose(tmpfileid);
nstations = (numel(tline)-7)/5;

tmpfileid=fopen([txtinout_dir '\Tmp1.Tmp'],'r');
for ii=1:4
    tline = fgetl(tmpfileid);
    disp(tline)
end

sizeA = [nstations+2, Inf];
formatSpec = ['%4d%3d',repmat('%5f',1,nstations),'\n']; 
tmp = fscanf(tmpfileid,formatSpec,sizeA);
tmp = tmp';
fclose(tmpfileid);

end



