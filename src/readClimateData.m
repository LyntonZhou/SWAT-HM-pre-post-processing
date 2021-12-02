function [pcp,tmp,wnd,slr,hmd] = readClimateData(txtinout_dir)
% read climate files in SWAT txtinout
pcp = readpcp(txtinout_dir);
tmp = readtmp(txtinout_dir);
wnd = readwnd(txtinout_dir);
slr = readslr(txtinout_dir);
hmd = readhmd(txtinout_dir);

end



