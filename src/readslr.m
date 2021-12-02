function [ slr ] = readslr(txtinout_dir)
slrfileid=fopen([txtinout_dir '\slr.slr'],'r');

% matrix size
for ii=1:2
    tline = fgetl(slrfileid);
end
fclose(slrfileid);
nstations = (numel(tline)-7)/8;

slrfileid=fopen([txtinout_dir '\slr.slr'],'r');
for ii=1:1
    tline = fgetl(slrfileid);
    disp(tline)
end

sizeA = [nstations+2, Inf];
formatSpec = ['%4d%3d',repmat('%8f',1,nstations),'\n']; 
slr = fscanf(slrfileid,formatSpec,sizeA);
slr = slr';
fclose(slrfileid);

end



