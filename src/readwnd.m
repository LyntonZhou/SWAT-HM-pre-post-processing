function [ wnd ] = readwnd(txtinout_dir)
wndfileid=fopen([txtinout_dir '\wnd.wnd'],'r');

% matrix size
for ii=1:2
    tline = fgetl(wndfileid);
end
fclose(wndfileid);
nstations = (numel(tline)-7)/8;

wndfileid=fopen([txtinout_dir '\wnd.wnd'],'r');
for ii=1:1
    tline = fgetl(wndfileid);
    disp(tline)
end

sizeA = [nstations+2, Inf];
formatSpec = ['%4d%3d',repmat('%8f',1,nstations),'\n']; 
wnd = fscanf(wndfileid,formatSpec,sizeA);
wnd = wnd';
fclose(wndfileid);

end



