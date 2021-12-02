clc
clear 
% close all
load simobs parval goalval outhmlrchsum
load hmStats

ns_idx = find(cell2mat(ns{1,3})>0.35);
pb_idx = find(abs(cell2mat(pb{1,3}))<0.30);
RR_idx = find(cell2mat(RR{1,3})>0.30);
int_idx = intersect(ns_idx,pb_idx);

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
    nethml = (outhmlrchsum(idx_beh,7)-outhmlrchsum(idx_beh,8)+outhmlrchsum(idx_beh,10));
    [f,x]=ecdf(nethml);
    if ii == 1
        f1=plot(x,f,'LineWidth',2.5,'Color',[161/256 218/256 180/256]);
    elseif ii == 2
        f2=plot(x,f,'LineWidth',2.5,'Color',[65/256 182/256 196/256]);
    elseif ii == 3
        f3=plot(x,f,'LineWidth',2.5,'Color',[44/256 127/256 184/256]);
    else
        f4=plot(x,f,'LineWidth',2.5,'Color',[37/256 52/256 148/256]);
    end
end
legend([f1,f2,f3,f4],{'group 1','group 2','group 3','group 4'}, ...
    'Location','SouthEast','FontSize',16);
legend boxoff;
xlabel('Net Zn balance (kg yr^-^1)','FontSize',16);
ylabel('CDF cumulative distribution function','FontSize',16);
set(gca,'LineWidth',2);box on;
set(gca,'FontSize',12);
set(gca,'tickdir','out');
hold on;
xL=xlim;yL=ylim;
plot([xL(2),xL(2)],[yL(1),yL(2)],'k','linewidth',2)
plot(xL,[yL(2),yL(2)],'k','linewidth',2)
box off
axis([xL yL]);
text(80000,0.95,'(a)','FontSize',16);

subplot(1,3,[2,3])
h_box=boxplot([outhmlrchsum(idx_beh,10),outhmlrchsum(idx_beh,7),outhmlrchsum(idx_beh,8),outhmlrchsum(idx_beh,9)] ,...
    'labels',{'Dif','Set','Res','Bur'}, ...
    'Colors',[27/256 158/256 119/256;27/256 158/256 119/256; ...
    217/256 95/256 2/256;117/256 112/256 179/256]);
    %'Colors','bbrr');
set(h_box,'LineWidth',2.5)
   
box_vars = findall(gca,'Tag','Box');
hLegend = legend(box_vars([4,2,1]), {'Input','Output','Internal'}, ...
                 'Location','NorthWest', ...
                 'FontSize',16);
legend boxoff;
set(gca,'LineWidth',2); box on;
xlabel('Input and output pathways in channel bed sediment','FontSize',16);
ylabel('Input and output flux of Zn (kg yr^{-1})','FontSize',16);
set(gca,'FontSize',12);
set(gca,'tickdir','out');
hold on;
xL=xlim;yL=ylim;
plot([xL(2),xL(2)],[yL(1),yL(2)],'k','linewidth',2)
plot(xL,[yL(2),yL(2)],'k','linewidth',2)
box off
axis([xL yL]);
text(4,0.92*10^5,'(b)','FontSize',16);

prctile([outhmlrchsum(idx_beh,7:10)],[2.5 5 25 50 75 95 97.5]);

mean(outhmlrchsum(idx_beh,7:10));

prctile([outhmlrchsum(idx_beh,7)-outhmlrchsum(idx_beh,8)],[2.5 5 25 50 75 95 97.5]);
prctile([outhmlrchsum(idx_beh,7)-outhmlrchsum(idx_beh,8)+outhmlrchsum(idx_beh,10)],[2.5 5 25 50 75 95 97.5]);

