indir = 'D:\XiangRiverProject\XiangRiver\XRB210528V2\Inputs';
outdir = 'D:\XiangRiverProject\XiangRiver\XRB210528V2\Outputs\figs\fig17';

data = readtable([indir, '\ga.csv']);
data1 = table2array(data);

figure
subplot(1,2,1)
explode = [0 0 0 1];
X = [data1(1,1),data1(1,2),data1(1,3),sum(data1(1,4:6))];
labels = {'SE','LF','SR','Ind'};
pie(X,explode,labels)
subplot(1,2,2)
X = [data1(16,1),data1(16,2),data1(1,3),sum(data1(16,4:6))];
labels = {'SE','LF','SR','Ind'};
pie(X,explode,labels)

fig = figure
box on;
set(gcf, 'Position',  [200, 200, 850, 500])
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
yyaxis right
hold on
plot(data1(:,1),'-o','LineWidth',2,'MarkerSize',9)
ylabel('Land-to-river Cd fluxes (kg yr^{-1})','FontSize',16);
ylim([0,80000])
yyaxis left
plot(data1(:,2),'-s','LineWidth',2,'MarkerSize',9)
plot(data1(:,3),'-+','LineWidth',2,'MarkerSize',9)
plot(data1(:,4),'-*','LineWidth',2,'MarkerSize',9)
plot(data1(:,5),'-d','LineWidth',2,'MarkerSize',9)
plot(data1(:,6),'-h','LineWidth',2,'MarkerSize',9)
ylabel('Land-to-river Cd fluxes (kg yr^{-1})','FontSize',16);
xlim([0,17])
xticks([1:1:16]);
set(gca,'XTickLabel',{'2000','2001','2002','2003','2004','2005','2006', ...
    '2007','2008','2009','2010','2011','2012','2013','2014','2015','2016'},'FontSize',12);
set(gca, 'XTickLabelRotation',90)
xlabel('Year','FontSize',16);
legend('LF','SR','MPNMO','SPNM','Others','SE','FontSize',12,'Location','North')
legend boxoff
saveas(fig,[outdir '\ga.tif']);
saveas(fig,[outdir '\ga.fig']);
saveas(fig,[outdir '\ga.jpg']);
saveas(fig,[outdir '\ga.eps']);

figure
box on;
set(gcf, 'Position',  [200, 200, 900, 500])
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
yyaxis right
hold on
plot(data1(:,1),'-o','LineWidth',2,'MarkerSize',9)
ylabel('Land-to-river Cd fluxes (kg yr^{-1})','FontSize',16);
ylim([0,80000])
yyaxis left
bar(data1,'stacked')
% plot(data1(:,2),'-s','LineWidth',2,'MarkerSize',9)
% plot(data1(:,3),'-+','LineWidth',2,'MarkerSize',9)
% plot(data1(:,4),'-*','LineWidth',2,'MarkerSize',9)
% plot(data1(:,5),'-d','LineWidth',2,'MarkerSize',9)
% plot(data1(:,6),'-h','LineWidth',2,'MarkerSize',9)
ylabel('Land-to-river Cd fluxes (kg yr^{-1})','FontSize',16);
xlim([0,17])
xticks([1:1:16]);
set(gca,'XTickLabel',{'2000','2001','2002','2003','2004','2005','2006', ...
    '2007','2008','2009','2010','2011','2012','2013','2014','2015','2016'},'FontSize',12);
set(gca, 'XTickLabelRotation',90)
xlabel('Year','FontSize',16);
legend('LF','SR','MPNMO','SPNM','Others','SE','FontSize',12,'Location','North')
legend boxoff
saveas(fig,[outdir '\ga.tif']);
saveas(fig,[outdir '\ga.fig']);
saveas(fig,[outdir '\ga.jpg']);
saveas(fig,[outdir '\ga.eps']);