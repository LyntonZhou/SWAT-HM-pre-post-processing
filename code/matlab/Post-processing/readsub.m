function proj = readsub(txtiodir,proj)

filenames = dir([txtiodir '\0*.sub']);
proj.SubNo=numel(filenames);
for jj=1:numel(filenames)
    subfilename=filenames(jj).name;
    fid=fopen([txtiodir '\' subfilename],'r');
    L   = 0;
    while feof(fid) == 0
        L = L+1;
        line = fgets(fid);
        if L == 7
            proj.IRGAGE(jj) = str2num(strtok(line));
        end
    end
    fclose(fid);
end
    
end

