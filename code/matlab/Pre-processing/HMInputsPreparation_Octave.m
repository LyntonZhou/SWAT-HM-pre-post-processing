%% @ Lingfeng Zhou 
%% generate input files for SWAT-HM
% icc: control code for for HM inputs files
% 1. metal.dat
% 2. .hml files: hru level inputs and parameters for metals
% 3. .swq files: river channel level and parameters for metals
% 4. ***p.dat files: point source files

%% Define inputs
clc
clear
promdir = pwd;
xlsdir = [promdir '\HeavyMetalModuleDataBase_XiangRiver_XRB210528V2.xlsx']; % database excel file directory
% projdir = 'D:\XiangRiverProject\XiangRiver\XRB210528V2.Sufi2.SwatCup'; % folder of SWAT-HM project
projdir = 'D:\XiangRiverProject\XiangRiver\XRB210528V2_1.Sufi2.SwatCup'; % folder of SWAT-HM project
[iprint,nyskip,SubNo,HruNo] = readfilecio(projdir);
icc=[1,0,1,0]; % icc: control code for for HM inputs files, 1=yes, 0=no
PointSourceNo=[1:SubNo]; % if icc(4)=1, then PointSourceNo is the No of point source files

tic
for ii=1:numel(icc)
    %% metal.dat file
    if (ii==1 && icc(ii)==1)
        % change the range of excel sheet in your case
        [~, ~, HmlPar] = xlsread(xlsdir,'Hml_Prameters','A2:O2');
        filename = [projdir '\metal.dat'];
        fid=fopen(filename,'w');
        formatSpec = '%3i%10s%3i%10.3f%10.3f%10.3f%10.6f%10.6f%10.3f%10.6f%10.6f%10.6f%10.3f%10.6f%10.6f\n\r';
        fprintf(fid, formatSpec, HmlPar{1:15});
        fclose(fid);
        disp('1 metal.dat file is modified')
        clearvars fid filename formatSpec
    end
    %% .hml files
    if (ii==2 && icc(ii)==1)
        % change the range of excel sheet in your case
        [num, ~, ~] = xlsread(xlsdir,'Hml_Hru');
        HmlHru = num(:,2:11);
        
        filenames = dir([projdir '\0*.hru']);
        for jj=1:numel(filenames)
            hrufilename=filenames(jj).name;
            hmlfilename=[hrufilename(1:9), '.hml'];
            hrufileid=fopen([projdir '\' hrufilename],'r');
            tline = fgetl(hrufileid);
            fclose(hrufileid);
            
            hmlfileid=fopen([projdir '\' hmlfilename],'w');
            fprintf(hmlfileid,[' .hml' tline(6:end),'\n']);
            fprintf(hmlfileid,'Soil Heavy Metal Data\n');
            fprintf(hmlfileid,'%10d    |HML_P1: Metal number [#]\n',1);
            fprintf(hmlfileid,'%10.6f    |HML_P2: Heavy metal Nonpoint source Area Fraction [-]\n',HmlHru(jj,1));
            fprintf(hmlfileid,'%10.3f    |HML_P3: Heavy metal in Rock [kg/ha]\n',HmlHru(jj,2));
            fprintf(hmlfileid,'%10.3f    |HML_P4: Labile metal in 1st layer soil [mg/kg]\n',HmlHru(jj,3));
            fprintf(hmlfileid,'%10.3f    |HML_P5: Non-labile metal in 1st layer soil [mg/kg]\n',HmlHru(jj,4));
            fprintf(hmlfileid,'%10.3f    |HML_P6: Enrichment ratio of heavy metal [-]\n',HmlHru(jj,5));
            %fprintf(hmlfileid,'%10.3f    |HML_P7: Soil pH [-]\n',HmlHru(jj,7));
            fprintf(hmlfileid,'%10.3f    |HML_P8: Total metal input from agricultural use [g/ha/yr]\n',HmlHru(jj,6));
            fprintf(hmlfileid,'%10.3f    |HML_P9: Fraction of labile metal in fertilizers or animal manure [-]\n',HmlHru(jj,7));
            fprintf(hmlfileid,'%10.3f    |HML_P10: Total metal input from atmospheric deposition [g/ha/yr]\n',HmlHru(jj,8));
            fprintf(hmlfileid,'%10.3f    |HML_P11: Fraction of labile metal in atmospheric deposition [-]\n',HmlHru(jj,9));
            fprintf(hmlfileid,'%10.3f    |HML_P12: Dissolved metal in groundwater [ug/L]\n',HmlHru(jj,10));
            fclose(hmlfileid);
        end
        disp([num2str(jj) ' .hml files are modified'])
        clearvars num filenames hmlfilename hrufilename hmlfileid hrufileid tline
    end
    %% .swq files
    if (ii==3 && icc(ii)==1)
        [num, ~, ~] = xlsread(xlsdir,'Hml_Swq');
        HmlSwq = num;
        
        filenames = dir([projdir '\0*.swq']);
        for jj=1:numel(filenames)
            filename=filenames(jj).name;
            swqfileid=fopen([projdir '\' filename],'r+');
            for kk=1:30
                headline=fgetl(swqfileid);
            end
            fseek(swqfileid,0,'cof');
            fprintf(swqfileid,'Heavy Metal Parameters: \n');
            fprintf(swqfileid,'     %10.4f     | SWQ_HML_STL: Settling velocity for Heavy Metal [m/d]\n',HmlSwq(jj,2));
            fprintf(swqfileid,'     %10.4f     | SWQ_HML_RSP: Resuspension velocity for Heavy Metal [m/d]\n',HmlSwq(jj,3));
            fprintf(swqfileid,'     %10.4f     | SWQ_HML_MIX: Mixing velocity for Heavy Metal [m/d]\n',HmlSwq(jj,4));
            fprintf(swqfileid,'     %10.5f     | SWQ_HML_BRY: Burial velocity for Heavy Metal [m/d]\n',HmlSwq(jj,5));
            fprintf(swqfileid,'     %10.4f     | SWQ_HML_LabileCONC: Initial HM concentration in reach bed sediment [kg/m3]\n',HmlSwq(jj,6));
            fprintf(swqfileid,'     %10.4f     | SWQ_HML_NonLabileCONC: Initial HM concentration in reach bed sediment [kg/m3]\n',HmlSwq(jj,7));
            fprintf(swqfileid,'     %10.4f     | SWQ_HML_ACT: Depth of active sediment layer for heavy metal [m]\n',HmlSwq(jj,8));
            fclose(swqfileid);
        end
        disp([num2str(jj) ' .swq files are modified'])
        clearvars kk num filenames filename headline swqfileid
    end
    %% point source file
    if (ii==4 && icc(ii)==1)
        [num, ~, ~] = xlsread(xlsdir,'PointSource');
         HmlPoint = num;
        for jj=1:numel(PointSourceNo)

            psfilename = [projdir '\' num2str(PointSourceNo(jj)) 'p.dat'];
            Notes={'2016/4/21 0:00:00 .dat file Daily Record Subbasin  10 ArcSWAT 2012.10_2.16 interface';
                '    ';
                '    ';
                '    ';
                '    ';
                ' DAY YEAR          FLOCNST          SEDCNST         ORGNCNST         ORGPCNST          NO3CNST          NH3CNST          NO2CNST         MINPCNST         CBODCNST        DISOXCNST         CHLACNST       SOLPSTCNST       SRBPSTCNST        BACTPCNST       BACTLPCNST        CMTL1CNST        CMTL2CNST        CMTL3CNST';
                };
            
            psfileid=fopen(psfilename,'w');
            for kk=1:numel(Notes)
                fprintf(psfileid,[Notes{kk} '\n']);
            end
            formatSpec='%4s%5s %16.3E %16.3E %16.3E %16.3E %16.3E %16.3E %16.3E %16.3E %16.3E %16.3E %16.3E %16.3E %16.3E %16.3E %16.3E %16.3E %16.3E %16.3E\n';
            for kk=1:numel(HmlPoint(:,1))
                fprintf(psfileid,formatSpec,num2str(HmlPoint(kk,1)),num2str(HmlPoint(kk,2)),...
                    HmlPoint(kk,jj+2)*50000,zeros(1,14),HmlPoint(kk,jj+2),zeros(1,2));
            end
            fclose(psfileid);
        end
        disp([num2str(numel(PointSourceNo)) ' point source files are modified'])
        clearvars kk num psfilename psfileid formatSpec Notes
    end
end
toc
