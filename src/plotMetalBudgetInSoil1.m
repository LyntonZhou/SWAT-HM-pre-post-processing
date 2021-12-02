clc
clear
close all
load simobs parval goalval outhmlsubsum
load hmStats

figure
hold on
ns_metal=cell2mat(ns{3,3});
[ns_metal_sort,idx_idx] = sort(ns_metal,'descend');
RR_metal=cell2mat(RR{1,3});
pb_metal=cell2mat(pb{1,3});
idx_idx1=5;idx_idx2=idx_idx1+1;
plot(1:8,[outhmlsubsum(idx_idx(idx_idx1),1:4), ...
    outhmlsubsum(idx_idx(idx_idx1),5)+outhmlsubsum(idx_idx(idx_idx1),6),...
    outhmlsubsum(idx_idx(idx_idx1),7:9)],'o-','MarkerSize',10,'LineWidth',2)
plot(1:8,[outhmlsubsum(idx_idx(idx_idx2),1:4), ...
    outhmlsubsum(idx_idx(idx_idx2),5)+outhmlsubsum(idx_idx(idx_idx2),6),...
    outhmlsubsum(idx_idx(idx_idx2),7:9)],'o-','MarkerSize',10,'LineWidth',2);
xlim([0,9]);
set(gca,'Xtick',1:8);
set(gca,'XTickLabel',{'S','L','P','U','E','D','W','A'},'FontSize',14);
box on
set(gca,'LineWidth',2);
ylabel('Input and output flux (g ha^-^1 yr^-^1)','FontSize',14);
xlabel('Input and output pathways in upland soil','FontSize',14);
legend(['\itNS= ' num2str(roundn(ns_metal(idx_idx(idx_idx1)),-2))], ...
    ['\itNS= ' num2str(roundn(ns_metal(idx_idx(idx_idx2)),-2))],'Location','NorthWest')
legend boxoff

ns_idx = find(cell2mat(ns{1,3})>0.35);
pb_idx = find(abs(cell2mat(pb{1,3}))<0.30);
RR_idx = find(cell2mat(RR{1,3})>0.30);
int_idx = intersect(ns_idx,pb_idx);


[min(cell2mat(ns{1,3})),max(cell2mat(ns{1,3}))]
[min(cell2mat(pb{1,3})),max(cell2mat(pb{1,3}))]
[min(cell2mat(RR{1,3})),max(cell2mat(RR{1,3}))]

% ns_idx = find(cell2mat(ns{1,3})>0.50);
% pb_idx = find(abs(cell2mat(pb{1,3}))<0.20);
% RR_idx = find(cell2mat(RR{1,3})>0.60);
% int_idx = intersect(ns_idx,pb_idx);

% idx_beh=ns_idx;
% idx_beh=pb_idx;
% idx_beh=RR_idx;
% idx_beh=int_idx;

figure
subplot(1,3,1)
hold on
yTickvalues=[0,0.25,0.5,0.75,1];
for ii=1:4
    if ii == 1
        idx_beh = RR_idx;
    elseif ii == 2
        idx_beh = ns_idx;
    elseif ii == 3
        idx_beh = pb_idx;
    else
        idx_beh = int_idx;
    end
    nethml = outhmlsubsum(idx_beh,11)-outhmlsubsum(idx_beh,10);
    [f,x]=ecdf(nethml);
    x_zero=x(x==0);
    f_zero=f(x==0);
    yTickvalues=[yTickvalues,f_zero];
    if ii == 1
        f1=plot(x,f,'LineWidth',2.5,'Color',[161/256 218/256 180/256]);
        plot([-1000,x_zero],[f_zero,f_zero],'LineWidth',2, ...
            'Color',[161/256 218/256 180/256],'LineStyle','--');
    elseif ii == 2
        f2=plot(x,f,'LineWidth',2.5,'Color',[65/256 182/256 196/256]);
        plot([-1000,x_zero],[f_zero,f_zero],'LineWidth',2, ...
            'Color',[65/256 182/256 196/256],'LineStyle','--');
    elseif ii == 3
        f3=plot(x,f,'LineWidth',2.5,'Color',[44/256 127/256 184/256]);
        plot([-1000,x_zero],[f_zero,f_zero],'LineWidth',2, ...
            'Color',[44/256 127/256 184/256],'LineStyle','--');
    else
        f4=plot(x,f,'LineWidth',2.5,'Color',[37/256 52/256 148/256]);
        plot([-1000,x_zero],[f_zero,f_zero],'LineWidth',2, ...
            'Color',[37/256 52/256 148/256],'LineStyle','--');
    end
    plot([x_zero,x_zero],[0,f_zero],'LineWidth',2,'Color','k','LineStyle','--');
end
legend([f1,f2,f3,f4],{'group 1','group 2','group 3','group 4'}, ...
    'Location','NorthWest', 'FontSize',16);
legend boxoff;
yTickvalues=sort(yTickvalues);
set(gca,'Ytick',yTickvalues);
set(gca,'YTickLabel',{num2str(roundn(yTickvalues(1),-2)),num2str(roundn(yTickvalues(2),-2)), ...
    num2str(roundn(yTickvalues(3),-2)),num2str(roundn(yTickvalues(4),-2)), ...
    num2str(roundn(yTickvalues(5),-2)),num2str(roundn(yTickvalues(6),-2)), ...
    num2str(roundn(yTickvalues(7),-2)),num2str(roundn(yTickvalues(8),-2)), ...
    num2str(roundn(yTickvalues(9),-2))}, 'FontSize',10);
xlabel('Net Zn balance (g ha^-^1 yr^-^1)','FontSize',16);
ylabel('CDF cumulative distribution function','FontSize',16);
set(gca,'LineWidth',2);xlim([-1000,1000]);box on;
set(gca,'FontSize',12);
set(gca,'tickdir','out');
hold on;
xL=xlim;yL=ylim;
plot([xL(2),xL(2)],[yL(1),yL(2)],'k','linewidth',2)
plot(xL,[yL(2),yL(2)],'k','linewidth',2)
box off
axis([xL yL]);
text(730,0.95,'(a)','FontSize',16);

% figure
subplot(1,3,[2,3])
h_box=boxplot([outhmlsubsum(idx_beh,1:4),outhmlsubsum(idx_beh,5)+outhmlsubsum(idx_beh,6),outhmlsubsum(idx_beh,7:9)] ,...
    'labels',{'S','L','P','U','E','D','W','A'}, ...
    'Colors',[217/256 95/256 2/256;217/256 95/256 2/256;217/256 95/256 2/256;...
    217/256 95/256 2/256;217/256 95/256 2/256; ...
    27/256 158/256 119/256;27/256 158/256 119/256;27/256 158/256 119/256]);
%'Colors','rrrrrbbb');
set(h_box,'LineWidth',2.5)
box_vars = findall(gca,'Tag','Box');
hLegend = legend(box_vars([1,6]), {'Input','Onput'}, ...
    'Location','NorthWest', ...
    'FontSize',16);
legend boxoff;
xlabel('Input and output pathways in upland soil','FontSize',16);
ylabel('Input and output flux of Zn (g ha^-^1 yr^-^1)','FontSize',16);
set(gca,'LineWidth',2); box on;
set(gca,'FontSize',12);
set(gca,'tickdir','out');
hold on;
xL=xlim;yL=ylim;
plot([xL(2),xL(2)],[yL(1),yL(2)],'k','linewidth',2)
plot(xL,[yL(2),yL(2)],'k','linewidth',2)
box off
axis([xL yL]);
text(7.8,0.92*10^3,'(b)','FontSize',16);

figure
subplot(1,3,[1,2])
h_box=boxplot([outhmlsubsum(idx_beh,1:4),outhmlsubsum(idx_beh,5)+outhmlsubsum(idx_beh,6),outhmlsubsum(idx_beh,7:9)] ,...
    'labels',{'S','L','P','U','E','D','W','A'}, ...
    'Colors',[217/256 95/256 2/256;217/256 95/256 2/256;217/256 95/256 2/256;...
    217/256 95/256 2/256;217/256 95/256 2/256; ...
    27/256 158/256 119/256;27/256 158/256 119/256;27/256 158/256 119/256]);
%'Colors','rrrrrbbb');
set(h_box,'LineWidth',2.5)
box_vars = findall(gca,'Tag','Box');
hLegend = legend(box_vars([1,6]), {'Input','Onput'}, ...
    'Location','NorthWest', ...
    'FontSize',16);
legend boxoff;
xlabel('Input and output pathways in upland soil','FontSize',16);
ylabel('Input and output flux of Zn (g ha^-^1 yr^-^1)','FontSize',16);
set(gca,'LineWidth',2); box on;


subplot(1,3,3)
hold on
yTickvalues=[0,0.25,0.5,0.75,1];
idx_beh = int_idx;
nethml = outhmlsubsum(idx_beh,11)-outhmlsubsum(idx_beh,10);
[f,x]=ecdf(nethml);
x_zero=x(x==0);
f_zero=f(x==0);
yTickvalues=[yTickvalues,f_zero];
f4=plot(x,f,'LineWidth',2.5,'Color',[37/256 52/256 148/256]);
plot([-1000,x_zero],[f_zero,f_zero],'LineWidth',2, ...
    'Color',[37/256 52/256 148/256],'LineStyle','--');
plot([x_zero,x_zero],[0,f_zero],'LineWidth',2,'Color','k','LineStyle','--');
% legend([f1,f2,f3,f4],{'beh1','beh2','beh3','beh4'},'Location','NorthWest',...
%     'FontSize',16);
% legend boxoff;
yTickvalues=sort(yTickvalues);
set(gca,'Ytick',yTickvalues);
set(gca,'YTickLabel',{num2str(roundn(yTickvalues(1),-2)),num2str(roundn(yTickvalues(2),-2)), ...
    num2str(roundn(yTickvalues(3),-2)),num2str(roundn(yTickvalues(4),-2)), ...
    num2str(roundn(yTickvalues(5),-2)),num2str(roundn(yTickvalues(6),-2)), ...
    num2str(roundn(yTickvalues(7),-2)),num2str(roundn(yTickvalues(8),-2)), ...
    num2str(roundn(yTickvalues(9),-2))}, 'FontSize',10);
xlabel('Net Zn balance (g ha^-^1 yr^-^1)','FontSize',16);
ylabel('CDF cumulative distribution function','FontSize',16);
set(gca,'LineWidth',2);xlim([-1000,1000]);box on;


prctile([outhmlsubsum(idx_beh,1:4),outhmlsubsum(idx_beh,5)+outhmlsubsum(idx_beh,6), ...
    outhmlsubsum(idx_beh,7:9)],[2.5 25 50 75 97.5]);

mean([outhmlsubsum(idx_beh,1:4),outhmlsubsum(idx_beh,5)+outhmlsubsum(idx_beh,6), ...
    outhmlsubsum(idx_beh,7:9)]);

prctile([outhmlsubsum(idx_beh,11),outhmlsubsum(idx_beh,10)],[2.5 25 50 75 97.5]);

mean((outhmlsubsum(idx_beh,9)./outhmlsubsum(idx_beh,11))./ ...
    (outhmlsubsum(idx_beh,8)./outhmlsubsum(idx_beh,11)))
min(outhmlsubsum(idx_beh,9)./outhmlsubsum(idx_beh,11))
max(outhmlsubsum(idx_beh,9)./outhmlsubsum(idx_beh,11))
min(outhmlsubsum(idx_beh,8)./outhmlsubsum(idx_beh,11))
max(outhmlsubsum(idx_beh,8)./outhmlsubsum(idx_beh,11))
min(outhmlsubsum(idx_beh,7)./outhmlsubsum(idx_beh,11))
max(outhmlsubsum(idx_beh,7)./outhmlsubsum(idx_beh,11))