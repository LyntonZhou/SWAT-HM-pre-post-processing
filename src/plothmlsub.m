%% @Lingfeng Zhou
clc
clear
close all
promdir = pwd;
txtiodir = 'D:\XiangRiverProject\XiangRiver\XRB210528V2.Sufi2.SwatCup'; % folder of SWAT-HM project
outdir = 'D:\XiangRiverProject\XiangRiver\XRB210528V2\Outputs\figs\hmfig1';
mkdir(outdir)
indir = 'D:\XiangRiverProject\XiangRiver\XRB210528V2\Inputs';
shapdir ='D:\XiangRiverProject\XiangRiver\XRB210528V2\Watershed\Shapes';

% read file.cio
[iprint,nyskip,SubNo,HruNo] = readfilecio(txtiodir);
proj = readcio([txtiodir '\file.cio']);
proj = readsub(txtiodir,proj);
Simlength = 12*(proj.NBYR-proj.NYSKIP);

%% rend SWAT & SWAT-HM output
% output.sub
outputsub = readoutputsub2(txtiodir,iprint,SubNo,Simlength);
% outhml.sub
outhmlsub = readouthmlsub(txtiodir, iprint);
% output.rch
% outputrch = readoutputrch(txtiodir, iprint);
outputrch = readoutputrch2(txtiodir,iprint,SubNo,Simlength);
% outhml.rch
outhmlrch = readouthmlrch(txtiodir,iprint,SubNo,Simlength);
% read point source
filename = [indir '\Xiang_industry_sub_monthly_Cd.csv'];
% metalpoint = readpointsource(filename,SubNo);
metalpoint = readpointsource2(filename,SubNo);

% subbasin output
yearS=2000; yearE=2015;
metalpoint = metalpoint(metalpoint.YEAR>=yearS,:);
metalpoint_Year = groupsummary(metalpoint,{'YEAR'},'sum',{'Point'});
metalpoint_Sub = groupsummary(metalpoint,{'SUB'},'sum',{'Point'});
metalpoint_Year_Sub = groupsummary(metalpoint,{'YEAR','SUB'},'sum',{'Point'});

outputsub = outputsub(outputsub.YEAR>=yearS & outputsub.YEAR<=yearE & outputsub.MON<13,:);
outhmlsub = outhmlsub(outhmlsub.YEAR>=yearS & outhmlsub.YEAR<=yearE & outhmlsub.MON<13,:);
subdata = [outputsub(:,2:end),outhmlsub(:,5:end),metalpoint(:,4)];

data1=[];data2=[];data3=[];
data1 = groupsummary(outputsub,{'YEAR','SUB'},'mean',{'AREAkm2'});
data2 = groupsummary(outputsub,{'YEAR','SUB'},'sum',{'PRECIPmm','WYLDmm','SURQmm','LATQmm','GW_Qmm','SYLDtha'});
data3 = groupsummary(outhmlsub,{'YEAR','SUB'},'sum',{'HM_SURQkg','HM_LATkg','LabHM_EROkg','NLabHM_EROkg'});
subdata_Year_Sub =[data1(:,[1:2,4]),data2(:,4:9),data3(:,4:7),metalpoint_Year_Sub(:,4)];

data1=[];data2=[];data3=[];
data1 = groupsummary(outputsub,{'SUB'},'mean',{'AREAkm2'});
data2 = groupsummary(outputsub,{'SUB'},'sum',{'PRECIPmm','WYLDmm','SURQmm','LATQmm','GW_Qmm','SYLDtha'});
data3 = groupsummary(outhmlsub,{'SUB'},'sum',{'HM_SURQkg','HM_LATkg','LabHM_EROkg','NLabHM_EROkg'});
subdata_Sub =[data1(:,[1:2,3]),data2(:,3:8),data3(:,3:6),metalpoint_Sub(:,3)];
subdata_Sub.P2NP = table2array(subdata_Sub(:,14))./(table2array(subdata_Sub(:,14))+sum(table2array(subdata_Sub(:,10:13)),2)); 
 
subdata_Sub2=table2array(subdata_Sub);

% reach output
outhmlrch = outhmlrch(outhmlrch.YEAR>=yearS & outhmlrch.YEAR<=yearE & outhmlrch.MON<13,:);
outputrch = outputrch(outputrch.YEAR>=yearS & outputrch.YEAR<=yearE & outputrch.MON<13,:);
rchdata = [outputrch(:,2:end),outhmlrch(:,5:end),metalpoint(:,4)];
rchdata.DisCONC = table2array(rchdata(:,15))./table2array(rchdata(:,6))*1000*1000/86400/30; % ug/L;
rchDisCONC = rchdata.DisCONC;
save rchDisCONC rchDisCONC
data1=[];data2=[];
data1 = groupsummary(outhmlrch,{'RCH'},'mean',{'AREAkm2'});
data2 = groupsummary(outhmlrch,{'RCH'},'sum',{'DisHM_INkg','LabHM_INkg','NLabHM_INkg','DisHM_OUTkg','LabHM_OUTkg','NLabHM_OUTkg', ...
    'HMSETTLkg','HMRESUSPkg','HMLBURYkg','HMLDIFFkg'});
rchdata_Sub =[data1(:,[1,3]),data2(:,3:12),metalpoint_Sub(:,3)];
writetable(rchdata_Sub,[outdir '\hmlrch.csv']);

subno2 = unique(rchdata(rchdata.DisCONC>1,:).RCH);
P2NPV2 = -ones(SubNo,1);
P2NPV2(subno2)=subdata_Sub2(subno2,15);
subdata_Sub.P2NPV2 = P2NPV2;
writetable(subdata_Sub,[outdir '\hmlsub.csv']);

rchdata_Sub2=table2array(rchdata_Sub);
(rchdata_Sub2(:,3)+rchdata_Sub2(:,4)+rchdata_Sub2(:,5)+rchdata_Sub2(:,13)-rchdata_Sub2(:,6)-rchdata_Sub2(:,7)-rchdata_Sub2(:,8))- ...
    (rchdata_Sub2(:,9)-rchdata_Sub2(:,10)+rchdata_Sub2(:,12));
[(rchdata_Sub2(:,3)+rchdata_Sub2(:,4)+rchdata_Sub2(:,5)+rchdata_Sub2(:,13)-rchdata_Sub2(:,6)-rchdata_Sub2(:,7)-rchdata_Sub2(:,8)), ...
    (rchdata_Sub2(:,9)-rchdata_Sub2(:,10)+rchdata_Sub2(:,12))];

mean(rchdata.DisCONC)

figure
A=sum(subdata_Sub2(:,[10,11,14]),2);
[B,I] = sort(A,'descend');
bar(subdata_Sub2(I,[10,11,14]),'stacked');
xlim([-5,597]);
% set(gca,'yscale','log');
xticks([1,100,200,300,400,500,591]);
xticklabels({'1','100','200','300','400','500','591'});
xlabel('Subbasin 子流域','fontsize',20);ylabel('Total Load (kg)','fontsize',18);
sum(B(1:10))/sum(B)

% monthly SWAT output.sub
data = outputsub(outputsub.YEAR>=yearS & outputsub.YEAR<=yearE & outputsub.MON<13 ,:);
data1 = groupsummary(data,{'YEAR'},'sum',{'AREAkm2','PRECIPmm','WYLDmm','SURQmm','LATQmm','GW_Qmm','SYLDtha'});
data2 = table2array(data1);
figure
bar(data2(:,[4,6:8])/591)
legend(strrep(data1.Properties.VariableNames([4,6:8]),'_','-'));
xticks([1:(yearE-yearS)])
xticklabels({'2006','2007','2008','2009','2010','2011','2012','2013','2014','2015','2016'});

% monthly sub h. metal
data = outhmlsub(outhmlsub.YEAR>=yearS & outhmlsub.MON<13 ,:);
data1 = groupsummary(data,{'YEAR','MON'},'sum',{'HM_SURQkg','HM_LATkg','LabHM_EROkg','NLabHM_EROkg'});
data2 = table2array(data1);
figure
bar(data2(:,4:end),'stacked')
legend(strrep(data1.Properties.VariableNames(4:7),'_','-'));
xlabel('Date');ylabel('Load/Kg');
xticks([1:12:121])
xticklabels({'2006','2007','2008','2009','2010','2011','2012','2013','2014','2015','2016'});

% yearly mean sub h. metal
data = outhmlsub(outhmlsub.YEAR>=yearS & outhmlsub.MON<13 ,:);
data1 = groupsummary(data,{'YEAR','SUB'},{'mean','sum'},{'AREAkm2','HM_SURQkg','HM_LATkg','LabHM_EROkg','NLabHM_EROkg'});
data1.HM_SURQ = data1.sum_HM_SURQkg./data1.mean_AREAkm2*100;
data1.HM_LAT = data1.sum_HM_LATkg./data1.mean_AREAkm2*100;
data1.LabHM_ERO = data1.sum_LabHM_EROkg./data1.mean_AREAkm2*100;
data1.NLabHM_ERO = data1.sum_NLabHM_EROkg./data1.mean_AREAkm2*100;
writetable(data1(data1.YEAR==2010,[1:2,14:17]),[outdir '\yearlyhmlsub.csv']);
data2 = table2array(data1);
figure
bar(data2(data2(:,2)==397,14:17),'stacked')
legend(strrep(data1.Properties.VariableNames(14:17),'_','-'));
xticks([1:(yearE-yearS)]);
xticklabels({'2006','2007','2008','2009','2010','2011','2012','2013','2014','2015','2016'});

data3 = groupsummary(data,{'YEAR'},'sum',{'HM_SURQkg','HM_LATkg','LabHM_EROkg','NLabHM_EROkg'});
data4 = table2array(data3);
figure
bar([data4(:,3:4),data4(:,5)+data4(:,6),metalpoint_Year.sum_Point]);
% ll=strrep(data3.Properties.VariableNames(3:end),'_','-');
% ll{1,5}='工业点源';
set(gca,'yscale','log');
set(gca,'LineWidth',2,'FontSize',20);
legend('地表径流','壤中流','侵蚀泥沙','工业点源','FontSize',18,'Location','north','Orientation', 'horizontal');
legend boxoff;
xlabel('年份','FontSize',22);ylabel('入河通量 (kg/年)','FontSize',22);
xticks([1:(yearE-yearS)]);
xticklabels({'2006','2007','2008','2009','2010','2011','2012','2013','2014','2015','2016'});

% rch h. metal
data = outhmlrch(outhmlrch.YEAR>=yearS & outhmlrch.MON<13 & outhmlrch.RCH==5,:);
data1 = table2array(data(:,[8,9,10]));
figure
plot(data1,'-o','LineWidth',1.5)
legend(strrep(data.Properties.VariableNames(8:10),'_','-'))
xlim([1,121]);
set(gca,'Xtick',1:12:121,'FontSize',14);set(gca,'LineWidth',2);
set(gca,'XTickLabel',{'2006','2007','2008','2009','2010','2011','2012','2013','2014','2015','2016'},'FontSize',14);

data = outhmlrch(outhmlrch.YEAR>=yearS & outhmlrch.MON<13 & outhmlrch.RCH==5,:);
data1 = table2array(data(:,[8,9,10]));
data2 = [data1(:,1),data1(:,2)+data1(:,3)];
figure
bar(data2,'stacked')
% legend(strrep(data.Properties.VariableNames(8:10),'_','-'))
legend('溶解态Cd','颗粒态Cd'); legend box off;
xlabel('Date','fontsize',20);ylabel('Load (kg)','fontsize',20);
xlim([-1,122]);
set(gca,'Xtick',1:12:121,'FontSize',14);set(gca,'LineWidth',2);
set(gca,'XTickLabel',{'2006','2007','2008','2009','2010','2011','2012','2013','2014','2015','2016'},'FontSize',14);

data = outhmlrch(outhmlrch.YEAR>=yearS & outhmlrch.MON<13 & outhmlrch.RCH==5,:);
data1 = groupsummary(data,{'MON'},'mean',{'DisHM_OUTkg','LabHM_OUTkg','NLabHM_OUTkg'});
data2 = table2array(data1(:,[3,4,5]));
data3 = [data2(:,1),data2(:,2)+data2(:,3)];
figure
bar(data3,'stacked')
% legend(strrep(data.Properties.VariableNames(8:10),'_','-'))
legend('溶解态Cd','颗粒态Cd','颗粒态Cd'); legend box off;
xlabel('Date','fontsize',20);ylabel('Load (kg)','fontsize',20);
xlim([0,13]);
set(gca,'Xtick',1:12,'FontSize',14);set(gca,'LineWidth',2);
set(gca,'XTickLabel',{'一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月'},'FontSize',14);
sum(sum(data3(4:9,:),2))/sum(sum(data3,2))

data3=[];
tributaryNo=[4 9 23 32 43 49 60 67 69 89 97 105 115 125 136 121 120 111 101 77 76 68];
for ii=1:numel(tributaryNo)
    data = rchdata(rchdata.RCH==tributaryNo(ii),:);
    data1 = table2array(data(:,[15,16,17]));
    data2 = table2array(data(:,6));
    data3(:,ii) = sum(data1,2); % tons/yr
end

figure
plot(data3')

% sediment budget
s1=sum(table2array(subdata_Year_Sub(:,3)).*table2array(subdata_Year_Sub(:,9))*100)
s2=sum(table2array(rchdata(rchdata.RCH==5,10)))
s3=-(sum(outputrch.SED_OUTtons)-sum(outputrch.SED_INtons))
[s1,s2,s3]
(s1-s2-s3)/s1

m1=sum(sum(table2array(subdata_Year_Sub(:,[10,11,12,13,14]))))
m2=sum(sum(table2array(rchdata(rchdata.RCH==5,[15,16,17]))))
m3=-sum(sum(table2array(outhmlrch(:,8:10))))+sum(sum(table2array(outhmlrch(:,5:7))))+sum(sum(table2array(subdata_Year_Sub(:,[14]))))
m1-m2-m3
(m1-m2-m3)/m1

years = unique(subdata.YEAR);

% rch hm
dataall= reshape(rchdata.HMSETTLkg-rchdata.HMRESUSPkg+rchdata.HMLDIFFkg,SubNo,12,numel(years));
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
%             mycoloridx=floor(k * (log(count)-log(min_data+1)) /(log(max_data)-log(min_data+1)));
            mycoloridx=floor(k * (count-min_data) /(max_data-min_data));
            mycoloridx(mycoloridx<1)=1;
            mycoloridx(mycoloridx>k)=k;
            mysymbolspec{i} = {'Subbasin', i, 'Color', mycolormap(mycoloridx, :)};
        end
        symbols=makesymbolspec('Line', {'default','LineWidth',1.5}, mysymbolspec{:});
        geoshow(ax,xiangriv,'SymbolSpec',symbols);
        geoshow(xiangbasin,'FaceColor', [1.0 1.0 1.0],'FaceAlpha',0.2);
        hcb = colorbar;
        step=(max_data-min_data)/k;
        aa = min_data:step:max_data;
        set(hcb,'YTickLabel',num2cell(roundn(aa,-2)));
        hcb.Label.String = 'Tons';
        title(['水系--底泥--', num2str(years(ii)), '年-第', num2str(jj) '月  (单位:kg)']);
        saveas(gcf,[outdir  '\Rch-底泥-第', num2str(years(ii)), '年-第', num2str(jj) '月.jpg']);
        close all
    end
end

% sub hm lateral flow
dataall= reshape(subdata.HM_LATkg,SubNo,12,numel(years));
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
        min_data = min(data);
        k=10;
        % mycolormap = summer(k);
        c = jet(k);
        mycolormap = colormap(c);
        for i=1:SubNo
            count=data(i);
            mycoloridx=floor( k * count / max_data);
%             mycoloridx=floor(k * (log(count)-log(min_data+1)) /(log(max_data)-log(min_data+1)));
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
        title(['子流域-壤中流--', num2str(years(ii)), '年-第', num2str(jj) '月  (单位:kg)']);
        saveas(gcf,[outdir '\Sub-壤中流-', num2str(years(ii)), '年-第', num2str(jj) '月.jpg']);
        close all
    end
end

% sub soil erosion
dataall= reshape(subdata_Year_Sub.sum_SYLDtha,SubNo,1,numel(years));
for ii=1:numel(years)
    for jj=1:1
        data=dataall(:,jj,ii);
        figure
        xiangsub = shaperead([shapdir '\subs2.shp'],'UseGeoCoords', true);
        ax=worldmap([24.5 28.7], [110.2 114.6]);
        %     setm(ax,'grid','off')
        % setm(ax,'frame','off')
        % setm(ax,'parallellabel','off')
        % setm(ax,'meridianlabel','off')
        max_data = max(data);
        min_data = min(data);
        k=10;
        % mycolormap = summer(k);
        c = jet(k);
        mycolormap = colormap(c);
        for i=1:SubNo
            count=data(i);
%             mycoloridx=floor( k * count / max_data);
            mycoloridx=floor(k * (log(count)-log(min_data+1)) /(log(max_data)-log(min_data+1)));
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
        hcb.Label.String = 'Tons/ha';
        title(['子流域-泥沙侵蚀--', num2str(years(ii)), '年-第', num2str(jj) '月  (单位:Tons/ha)']);
        saveas(gcf,[outdir '\Sub-泥沙侵蚀-', num2str(years(ii)), '年-第', num2str(jj) '月.jpg']);
        close all
    end
end

% rch sediment
dataall= reshape(rchdata.SED_OUTtons,SubNo,12,numel(years));
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
        saveas(gcf,[outdir  '\Rch-输沙量-第', num2str(years(ii)), '年-第', num2str(jj) '月.jpg']);
        close all
    end
end

% rch dis hm
dataall= reshape(rchdata.DisCONC,SubNo,12,numel(years));
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
        saveas(gcf,[outdir '\Rch-溶解态Cd-第', num2str(years(ii)), '年-第', num2str(jj) '月.jpg']);
        close all
    end
end

% plot surq hm
dataall = reshape(subdata.HM_SURQkg,SubNo,12,numel(years));
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
        saveas(gcf,[outdir '\Sub-地表径流Cd-', num2str(years(ii)), '年-第', num2str(jj) '月.jpg']);
        close all
    end
end


% plot sed hm
% dataall = reshape(subdata_Year_Sub.sum_HM_SURQkg+subdata_Year_Sub.sum_HM_SURQkg,SubNo,7);
dataall = reshape(subdata.LabHM_EROkg+subdata.NLabHM_EROkg,SubNo,12,numel(years));
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
        saveas(gcf,[outdir '\Sub-泥沙侵蚀Cd-', num2str(years(ii)), '年-第', num2str(jj) '月.jpg']);
        close all
    end
end

% plot point hm
dataall = reshape(subdata.Point,SubNo,12,numel(years));
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
        saveas(gcf,['.\Sub-工业点源Cd-', num2str(years(ii)), '年-第', num2str(jj) '月.jpg']);
        close all
    end
end
