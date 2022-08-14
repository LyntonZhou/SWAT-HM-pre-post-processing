function proj = readcio(filename)
fid = fopen(filename, 'r');
L   = 0;
while feof(fid) == 0
    L = L+1;
    line = fgets(fid);
    if L == 8
        proj.NBYR = str2num(strtok(line));
    elseif L == 9
        proj.IYR = str2num(strtok(line));
    elseif L == 10
        proj.IDAF = str2num(strtok(line));
    elseif L == 11
        proj.IDAL = str2num(strtok(line));
    elseif L == 19
        proj.NRGAGE = str2num(strtok(line));
    elseif L == 19
        proj.NRTOT = str2num(strtok(line));
    elseif L == 20
        proj.NRGFIL = str2num(strtok(line));
    elseif L == 22
        proj.NTGAGE = str2num(strtok(line));
    elseif L == 23
        proj.NTTOT = str2num(strtok(line));
    elseif L == 24
        proj.NTGFIL = str2num(strtok(line));
    elseif L == 59
        proj.IPRINT = str2num(strtok(line));
    elseif L == 60
        proj.NYSKIP = str2num(strtok(line));
    end
end
fclose(fid);

proj.date_str_sim = datenum(proj.IYR,1,1); 
proj.date_end_sim = datenum(proj.IYR+proj.NBYR-1,12,31);
proj.date_str_print = datenum(proj.IYR+proj.NYSKIP,1,1);
proj.simtime = proj.date_str_sim:proj.date_end_sim;
proj.printtime = proj.date_str_print:proj.date_end_sim;

ymd = [year(proj.printtime);month(proj.printtime);day(proj.printtime)];
ymd=ymd';
ymd(:,4)=proj.printtime'-datenum(ymd(:,1),1,1)+1;
proj.ymd=ymd;

end

