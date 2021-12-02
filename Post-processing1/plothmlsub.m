%% @Lingfeng Zhou
clc
clear
close all
promdir = pwd;
projdir = 'D:\XiangRiverProject\XiangRiver\1.Sufi2.SwatCup'; % folder of SWAT-HM project
outdir = 'D:\XiangRiverProject\XiangRiver\1\Outputs';
indir = 'D:\XiangRiverProject\XiangRiver\1\Inputs';
shapdir ='D:\XiangRiverProject\XiangRiver\1\Watershed\Shapes';

% read file.cio
[iprint,nyskip,SubNo,HruNo] = readfilecio(projdir);

%% rend SWAT & SWAT-HM output
% output.sub
outputsub = readoutputsub2(projdir, iprint);
% outhml.sub
outhmlsub = readouthmlsub(projdir, iprint);
% output.rch
% outputrch = readoutputrch(projdir, iprint);
outputrch = readoutputrch2(projdir, iprint);
% outhml.rch
outhmlrch = readouthmlrch(projdir, iprint);
% read point source
filename = [indir '\Xiang_industry_sub_monthly_Cd_TableToExcel.xls'];
% metalpoint = readpointsource(filename,SubNo);
metalpoint = readpointsource2(filename,SubNo);

% subbasin output
metalpoint = metalpoint(metalpoint.YEAR>2008,:);
metalpoint_Year = groupsummary(metalpoint,{'YEAR'},'sum',{'Point'});
outputsub = outputsub(outputsub.YEAR>2008 & outputsub.YEAR<2016 & outputsub.MON<13,:);
outhmlsub = outhmlsub(outhmlsub.YEAR>2008 & outhmlsub.YEAR<2016 & outhmlsub.MON<13,:);
data1 = groupsummary(outputsub,{'YEAR','SUB'},'mean',{'AREAkm2'});
data2 = groupsummary(outputsub,{'YEAR','SUB'},'sum',{'PRECIPmm','WYLDmm','SURQmm','LATQmm','GW_Qmm','SYLDtha'});
data3 = groupsummary(outhmlsub,{'YEAR','SUB'},'sum',{'HM_SURQkg','HM_LATkg','LabHM_EROkg','NLabHM_EROkg'});

subdata_Year_Sub =[data1(:,[1:2,4]),data2(:,4:9),data3(:,4:7)];
subdata = [outputsub(:,2:end),outhmlsub(:,5:end),metalpoint(:,4)];

% reach output
outhmlrch = outhmlrch(outhmlrch.YEAR>2008 & outhmlrch.YEAR<2016 & outhmlrch.MON<13,:);
outputrch = outputrch(outputrch.YEAR>2008 & outputrch.YEAR<2016 & outputrch.MON<13,:);
rchdata_Year_Sub = [outputrch(:,2:end),outhmlrch(:,5:end)];
rchdata_Year_Sub.DisCONC = table2array(rchdata_Year_Sub(:,15))./table2array(rchdata_Year_Sub(:,6))*1000*1000/86400/30; % ug/L;
summary(rchdata_Year_Sub);
% writetable(data(:,[1,8,9,end]),[outdir '\hmlrch.csv']);


years = unique(subdata.YEAR);
% rch sediment
dataall= reshape(rchdata_Year_Sub.SED_OUTtons,SubNo,12,7);
for ii=1:numel(years)
    for jj=1:12
        data=dataall(:,jj,ii);
        figure
        xiangriv = shaperead([shapdir '\riv2.shp'], 'UseGeoCoords', true);
        xiangbasin = shaperead([shapdir '\basin2.shp'], 'UseGeoCoords', true) ;
        ax=worldmap([24.5 28.7], [110.2 114.6]);
        max_data = max(data);
        min_data = min(data);
        k=10;
        % mycolormap = summer(k);
        c = jet(k);
        mycolormap = colormap(c);
        for i=1:SubNo
            count=data(i);
            mycoloridx=floor(k * (log(count)-log(min_data+1)) /(log(max_data)-log(min_data+1)));
%             mycoloridx=floor(k * (count-min_data) /(max_data-min_data));
            mycoloridx(mycoloridx<1)=1;
            mycoloridx(mycoloridx>k)=k;
            mysymbolspec{i} = {'Subbasin', i, 'Color', mycolormap(mycoloridx, :)};
        end
        symbols=makesymbolspec('Line', {'default','LineWidth',1.5}, mysymbolspec{:});
        geoshow(ax,xiangriv,'SymbolSpec',symbols);
        geoshow(xiangbasin,'FaceColor', [1.0 1.0 1.0],'FaceAlpha',0.2);
        hcb = colorbar;
        step=max_data/k;
        aa = 0:step:max_data;
        set(hcb,'YTickLabel',num2cell(roundn(aa,-2)));
        hcb.Label.String = 'Tons';
        title(['水系--输沙量--', num2str(years(ii)), '年-第', num2str(jj) '月  (单位:Tons)']);
        saveas(gcf,['.\figs\Rch-输沙量-第', num2str(years(ii)), '年-第', num2str(jj) '月.jpg']);
        close all
    end
end

% rch dis hm
dataall= reshape(rchdata_Year_Sub.DisCONC,SubNo,12,7);
for ii=1:numel(years)
    for jj=1:12
        data=dataall(:,jj,ii);
        figure
        xiangriv = shaperead([shapdir '\riv2.shp'], 'UseGeoCoords', true);
        xiangbasin = shaperead([shapdir '\basin2.shp'], 'UseGeoCoords', true) ;
        ax=worldmap([24.5 28.7], [110.2 114.6]);
        %         setm(ax,'grid','off')
        % setm(ax,'frame','off')
        % setm(ax,'parallellabel','off')
        % setm(ax,'meridianlabel','off')
        max_data = max(data);
        %         max_data = prctile(data,0.99)
        min_data = min(data);
        %         min_data = prctile(data,0.05)
        k=6;
        % mycolormap = summer(k);
        c = jet(k);
        mycolormap = colormap(c);
        %         for i=1:SubNo
        %             count=data(i);
        %             mycoloridx=floor( k * (log(count)-log(min_data)) /(log(max_data)-log(min_data)));
        %             mycoloridx(mycoloridx<1)=1;
        %             mycoloridx(mycoloridx>k)=k;
        %             mysymbolspec{i} = {'Subbasin', i, 'Color', mycolormap(mycoloridx, :)};
        %         end
        for i=1:SubNo
            count=data(i);
            if count <= 0.46
                mycoloridx= 1;
            elseif count <= 1
                mycoloridx= 2;
            elseif count <= 5
                mycoloridx= 3;
            elseif count <= 10
                mycoloridx= 4;
            elseif count <= 38.88
                mycoloridx= 5;
            else
                mycoloridx= 6;
            end
            mysymbolspec{i} = {'Subbasin', i, 'Color', mycolormap(mycoloridx, :)};
        end
        symbols=makesymbolspec('Line', {'default','LineWidth',1.5}, mysymbolspec{:});
        geoshow(ax,xiangriv,'SymbolSpec',symbols);
        geoshow(xiangbasin,'FaceColor', [1.0 1.0 1.0],'FaceAlpha',0.2);
        %         hcb = colorbar;
        %         step = max_data/k;
        %         aa = 0:step:max_data;
        %         colorbar('Ticks',[-5,-2,1,4,7],...
        %          'TickLabels',{'Cold','Cool','Neutral','Warm','Hot'})
        step = 1/k;
        aa1 = 0:step:1;
        aa = [0, 0.46, 1, 5, 10, 38.8, 100];
        %         set(hcb,'Ticks',aa1,'TickLabel',num2cell(roundn(aa,-2)));
        hcb = colorbar('Ticks',aa1,...
            'TickLabels',{'0', '0.46', '1.00', '5.00', '10.00', '38.88', ''});
        hcb.Label.String = 'Conc (ug/L)';
        title(['水系--溶解态Cd浓度--', num2str(years(ii)), '年-第', num2str(jj) '月  (单位:ug/L)']);
        saveas(gcf,['.\figs\Rch-溶解态Cd-第', num2str(years(ii)), '年-第', num2str(jj) '月.jpg']);
        close all
    end
end

% plot surq hm
dataall = reshape(subdata.HM_SURQkg,SubNo,12,7);
for ii=1:numel(years)
    for jj=1:12
        data=dataall(:,jj,ii);
        figure
        xiangsub = shaperead([shapdir '\subs2.shp'],'UseGeoCoords', true);
        ax=worldmap([24.5 28.7], [110.2 114.6]);
        %     setm(ax,'grid','off')
        % setm(ax,'frame','off')
        % setm(ax,'parallellabel','off')
        % setm(ax,'meridianlabel','off')
        max_data = max(data);
        k=10;
        % mycolormap = summer(k);
        c = jet(k);
        mycolormap = colormap(c);
        for i=1:SubNo
            count=data(i);
            mycoloridx=floor( k * count / max_data);
            mycoloridx(mycoloridx<1)=1;
            mysymbolspec{i} = {'Subbasin', i, 'FaceColor', mycolormap(mycoloridx, :)};
        end
        symbols=makesymbolspec('Polygon',{'default','FaceColor',[0.9 0.9 0.8],...
            'LineStyle','--','LineWidth',0.2,...
            'EdgeColor',[0.8 0.9 0.9]},...
            mysymbolspec{:}...
            );
        geoshow(ax,xiangsub,'SymbolSpec',symbols);
        hcb = colorbar;
        step=max_data/k;
        aa = 0:step:max_data;
        set(hcb,'YTickLabel',num2cell(roundn(aa,-2)));
        hcb.Label.String = 'Load (kg)';
        title(['子流域-地表径流Cd通量--', num2str(years(ii)), '年-第', num2str(jj) '月  (单位:kg)']);
        saveas(gcf,['.\figs\Sub-地表径流Cd-', num2str(years(ii)), '年-第', num2str(jj) '月.jpg']);
        close all
    end
end


% plot sed hm
% dataall = reshape(subdata_Year_Sub.sum_HM_SURQkg+subdata_Year_Sub.sum_HM_SURQkg,SubNo,7);
dataall = reshape(subdata.LabHM_EROkg+subdata.NLabHM_EROkg,SubNo,12,7);
for ii=1:numel(years)
    for jj=1:12
        data=dataall(:,jj,ii);
        figure
        xiangsub = shaperead([shapdir '\subs2.shp'],'UseGeoCoords', true);
        ax=worldmap([24.5 28.7], [110.2 114.6]);
        setm(ax,'grid','off')
        % setm(ax,'frame','off')
        % setm(ax,'parallellabel','off')
        % setm(ax,'meridianlabel','off')
        max_data = max(data);
        k=10;
        % mycolormap = summer(k);
        c = jet(k);
        mycolormap = colormap(c);
        for i=1:SubNo
            count=data(i);
            mycoloridx=floor( k * count / max_data);
            mycoloridx(mycoloridx<1)=1;
            mysymbolspec{i} = {'Subbasin', i, 'FaceColor', mycolormap(mycoloridx, :)};
        end
        symbols=makesymbolspec('Polygon',{'default','FaceColor',[0.9 0.9 0.8],...
            'LineStyle','--','LineWidth',0.2,...
            'EdgeColor',[0.8 0.9 0.9]},...
            mysymbolspec{:}...
            );
        geoshow(ax,xiangsub,'SymbolSpec',symbols);
        hcb = colorbar;
        step = max_data/k;
        aa = 0:step:max_data;
        set(hcb,'YTickLabel',num2cell(roundn(aa,-2)));
        hcb.Label.String = 'Load (kg)';
        title(['子流域-泥沙侵蚀Cd通量--', num2str(years(ii)), '年-第', num2str(jj) '月  (单位:kg)']);
        saveas(gcf,['.\figs\Sub-泥沙侵蚀Cd-', num2str(years(ii)), '年-第', num2str(jj) '月.jpg']);
        close all
    end
end

% plot point hm
dataall = reshape(subdata.Point,SubNo,12,7);
for ii=1:numel(years)
    for jj=1:12
        data=dataall(:,jj,ii);
        figure
        xiangsub = shaperead([shapdir '\subs2.shp'],'UseGeoCoords', true);
        ax=worldmap([24.5 28.7], [110.2 114.6]);
        setm(ax,'grid','off')
        % setm(ax,'frame','off')
        % setm(ax,'parallellabel','off')
        % setm(ax,'meridianlabel','off')
        max_data = max(data);
        k=10;
        % mycolormap = summer(k);
        c = jet(k);
        mycolormap = colormap(c);
        for i=1:SubNo
            count=data(i);
            mycoloridx=floor(k * count / max_data);
            mycoloridx(mycoloridx<1)=1;
            if isnan(mycoloridx); mycoloridx = 1;end
            mysymbolspec{i} = {'Subbasin', i, 'FaceColor', mycolormap(mycoloridx, :)};
        end
        symbols=makesymbolspec('Polygon',{'default','FaceColor',[0.9 0.9 0.8],...
            'LineStyle','--','LineWidth',0.2,...
            'EdgeColor',[0.8 0.9 0.9]},...
            mysymbolspec{:}...
            );
        geoshow(ax,xiangsub,'SymbolSpec',symbols);
        hcb = colorbar;
        step = max_data/k;
        aa = 0:step:max_data;
        set(hcb,'YTickLabel',num2cell(roundn(aa,-2)));
        hcb.Label.String = 'Load (kg)';
        title(['子流域-工业点源Cd--', num2str(years(ii)), '年-第', num2str(jj) '月  (单位:kg)']);
        saveas(gcf,['.\figs\Sub-工业点源Cd-', num2str(years(ii)), '年-第', num2str(jj) '月.jpg']);
        close all
    end
end


% monthly SWAT output.sub
data = outputsub(outputsub.YEAR>2008 & outputsub.YEAR<2016 & outputsub.MON<13 ,:);
data1 = groupsummary(data,{'YEAR','SUB'},'mean',{'AREAkm2','PRECIPmm','WYLDmm','SURQmm','LATQmm','GW_Qmm','SYLDtha'});
data2 = table2array(data1);
writetable(data1(data1.YEAR==2010,:),[outdir '\yearlyoutsub.csv']);
figure
bar(data2(data2(:,2)==26,[5,7:9])*12)
legend(strrep(data1.Properties.VariableNames([5,7:9]),'_','-'));
xticks([1:8])
xticklabels({'2009','2010','2011','2012','2013','2014','2015','2016'});

% monthly sub h. metal
data = outhmlsub(outhmlsub.YEAR>2008 & outhmlsub.MON<13 ,:);
data1 = groupsummary(data,{'YEAR','MON'},'sum',{'HM_SURQkg','HM_LATkg','LabHM_EROkg','NLabHM_EROkg'});
data2 = table2array(data1);
figure
bar(data2(:,4:end),'stacked')
legend(strrep(data1.Properties.VariableNames(4:7),'_','-'));
xlabel('Date');ylabel('Load/Kg');
xticks([1:12:97])
xticklabels({'2009','2010','2011','2012','2013','2014','2015','2016','2017'});

% yearly mean sub h. metal
data = outhmlsub(outhmlsub.YEAR>2008 & outhmlsub.MON<13 ,:);
data1 = groupsummary(data,{'YEAR','SUB'},{'mean','sum'},{'AREAkm2','HM_SURQkg','HM_LATkg','LabHM_EROkg','NLabHM_EROkg'});
data1.HM_SURQ = data1.sum_HM_SURQkg./data1.mean_AREAkm2*100;
data1.HM_LAT = data1.sum_HM_LATkg./data1.mean_AREAkm2*100;
data1.LabHM_ERO = data1.sum_LabHM_EROkg./data1.mean_AREAkm2*100;
data1.NLabHM_ERO = data1.sum_NLabHM_EROkg./data1.mean_AREAkm2*100;
writetable(data1(data1.YEAR==2010,[1:2,14:17]),[outdir '\yearlyhmlsub.csv']);
data2 = table2array(data1);
figure
bar(data2(data2(:,2)==26,14:17),'stacked')
legend(strrep(data1.Properties.VariableNames(14:17),'_','-'));
xticks([1:8]);
xticklabels({'2009','2010','2011','2012','2013','2014','2015','2016'});

data3 = groupsummary(data,{'YEAR'},'sum',{'HM_SURQkg','HM_LATkg','LabHM_EROkg','NLabHM_EROkg'});
data4 = table2array(data3);
figure
bar([data4(:,3:4),data4(:,5)+data4(:,6),metalpoint_Year.sum_Point]);
% ll=strrep(data3.Properties.VariableNames(3:end),'_','-');
% ll{1,5}='工业点源';
set(gca,'LineWidth',2,'FontSize',20);
legend('地表径流','壤中流','侵蚀泥沙','工业点源','FontSize',18,'Location','north');
% legend boxoff;
xlabel('年份','FontSize',22);ylabel('入河通量 (kg/年)','FontSize',22);
xticks([1:8]);
xticklabels({'2009','2010','2011','2012','2013','2014','2015','2016'});

% rch h. metal
data = outhmlrch(outhmlrch.YEAR>2008 & outhmlrch.MON<13 & outhmlrch.RCH==1,:);
data1 = table2array(data(:,[8,9,10]));
figure
plot(data1,'-o','LineWidth',1.5)
legend(strrep(data.Properties.VariableNames(8:10),'_','-'))
xlim([1,97]);
set(gca,'Xtick',1:12:97,'FontSize',14);set(gca,'LineWidth',2);
set(gca,'XTickLabel',{'2009','2010','2011','2012','2013','2014','2015','2016','2017'},'FontSize',14);

data = outhmlrch(outhmlrch.YEAR==2012 & outhmlrch.MON==1,:);
data1 = outputrch(outputrch.YEAR==2012 & outputrch.MON==1,:);
data2 = table2array(data(:,8))./table2array(data1(:,7))*1000*1000/86400/30; % ug/L
data.CONC = data2;
writetable(data(:,[1,8,9,end]),[outdir '\hmlrch.csv']);
