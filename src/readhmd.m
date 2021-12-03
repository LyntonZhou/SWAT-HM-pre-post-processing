function [ hmd ] = readhmd(txtinout_dir)
hmdfileid=fopen([txtinout_dir '\hmd.hmd'],'r');

% matrix size
for ii=1:2
    tline = fgetl(hmdfileid);
end
fclose(hmdfileid);
nstations = (numel(tline)-7)/8;

hmdfileid=fopen([txtinout_dir '\hmd.hmd'],'r');
for ii=1:1
    tline = fgetl(hmdfileid);
    disp(tline)
end

sizeA = [nstations+2, Inf];
formatSpec = ['%4d%3d',repmat('%8f',1,nstations),'\n']; 
hmd = fscanf(hmdfileid,formatSpec,sizeA);
hmd = hmd';
fclose(hmdfileid);

end



