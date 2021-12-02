clc
clear
close all
load simobs

%apply GLUE
figure
GLF = goalval;
threshold = -100;
Y_sim = HMTOTOUT66';
[ idx, Llim, Ulim ] = GLUE(GLF,threshold,Y_sim);
% plot(Y_sim','b')
hold on
plot(Ulim,'b')
plot(Llim,'b')
scatter(obsHMTOT66_idx,obsHMTOT66,60,'r','filled');
text(obsHMTOT66_idx+2,obsHMTOT66,num2cell(1:77));
xlabel('time (days)'); ylabel('Zn (kg/day)')
set(gca,'yscale','log');
xlim([1,2192]); box on;

figure
hold on
plot(obsHMTOT66,'r');
plot(HMTOTOUT66(obsHMTOT66_idx,1661),'b');

ns=cell(3,3);
ns_temp=[];
for jj=1:simNo
    ns_temp1{jj}=nscoeff([obsFLOW66,FLOWOUT66(:,jj)]);
    ns_temp2{jj}=nscoeff([obsFLOW66(1:1096),FLOWOUT66(1:1096,jj)]);
    ns_temp3{jj}=nscoeff([obsFLOW66(1097:end),FLOWOUT66(1097:end,jj)]);
end
ns{1,1}=ns_temp1';
ns{2,1}=ns_temp2';
ns{3,1}=ns_temp3';
ns_temp1=[]; ns_temp2=[];  ns_temp3=[];
for jj=1:simNo
    ns_temp1{jj}=nscoeff([obsSED66,SEDOUT66(:,jj)]);
    ns_temp2{jj}=nscoeff([obsSED66(1:1096),SEDOUT66(1:1096,jj)]);
    ns_temp3{jj}=nscoeff([obsSED66(1097:end),SEDOUT66(1097:end,jj)]);
end
ns{1,2}=ns_temp1';
ns{2,2}=ns_temp2';
ns{3,2}=ns_temp3';
ns_temp1=[]; ns_temp2=[];  ns_temp3=[];
for jj=1:simNo
    ns_temp1{jj}=nscoeff([obsHMTOT66,HMTOTOUT66(obsHMTOT66_idx,jj)]);
    ns_temp2{jj}=nscoeff([obsHMTOT66(1:39),HMTOTOUT66(obsHMTOT66_idx(1:39),jj)]);
    ns_temp3{jj}=nscoeff([obsHMTOT66(40:77),HMTOTOUT66(obsHMTOT66_idx(40:77),jj)]);
end
ns{1,3}=ns_temp1';
ns{2,3}=ns_temp2';
ns{3,3}=ns_temp3';
ns_temp1=[]; ns_temp2=[];  ns_temp3=[];

[goalval_sort,goalval_idx] = sort(goalval,'descend');
[ns{2,3}{goalval_idx};ns{3,3}{goalval_idx}];

figure
subplot(311)
hist(cell2mat(ns{1,1}),20)
title('NS histogram streamflow')
xlim([-1,1]);
subplot(312)
hist(cell2mat(ns{1,2}),20)
title('NS histogram sediment load')
xlim([-1,1]);
subplot(313)
hist(cell2mat(ns{1,3}),20)
xlim([-1,1]);
title('NS histogram Zn load')

sum(cell2mat(ns{1,3}) < 0.)

% figure
% subplot(311)
% hist(cell2mat(ns{2,1}),20)
% title('NS histogram streamflow')
% xlim([-1,1]);
% subplot(312) 
% hist(cell2mat(ns{2,2}),20)
% title('NS histogram sediment load')
% xlim([-1,1]);
% subplot(313) 
% hist(cell2mat(ns{2,3}),20)
% xlim([-1,1]);
% title('NS histogram Zn load')

pb=cell(1,3);
pb_temp=[];
for jj=1:simNo
    pb_temp{jj}=pbias([obsFLOW66,FLOWOUT66(:,jj)]);
end
pb{1,1}=pb_temp';
pb_temp=[];
for jj=1:simNo
    pb_temp{jj}=pbias([obsSED66,SEDOUT66(:,jj)]);
end
pb{1,2}=pb_temp';
pb_temp=[];
for jj=1:simNo
    pb_temp{jj}=pbias([obsHMTOT66,HMTOTOUT66(obsHMTOT66_idx,jj)]);
end
pb{1,3}=pb_temp';

figure
subplot(311)
hist(cell2mat(pb{1,1}),20)
title('pbias histogram streamflow')
xlim([-1,1]);
subplot(312)
hist(cell2mat(pb{1,2}),20)
title('pbias histogram sediment load')
xlim([-1,1]);
subplot(313)
hist(cell2mat(pb{1,3}),20)
title('pbias histogram Zn load')
xlim([-1,1]);

RR=cell(1,3);
RR_temp=[];
for jj=1:simNo
    rho=corr([obsFLOW66,FLOWOUT66(:,jj)]);
    RR_temp{jj}=(rho(1,2))^2;
end
RR{1,1}=RR_temp';
RR_temp=[];
for jj=1:simNo
    rho=corr([obsSED66,SEDOUT66(:,jj)]);
    RR_temp{jj}=(rho(1,2))^2;
end
RR{1,2}=RR_temp';
RR_temp=[];
for jj=1:simNo
    rho=corr([obsHMTOT66,HMTOTOUT66(obsHMTOT66_idx,jj)]);
    RR_temp{jj}=(rho(1,2))^2;
end
RR{1,3}=RR_temp';

figure
subplot(311)
hist(cell2mat(RR{1,1}),20)
hold on
xlim([0,1]);
title('R2 histogram streamflow')
subplot(312)
hist(cell2mat(RR{1,2}),20)
xlim([0,1]);
title('R2 histogram sediment load')
subplot(313)
hist(cell2mat(RR{1,3}),20,'FaceColor','g')
xlim([0,1]);
title('R2 histogram Zn load')

figure
subplot(311)
h=histogram(cell2mat(ns{1,3}),20,'FaceColor',[228/256 26/256 28/256]);
% set(h,'LineWidth',1.5);
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
legend({' (a) {\itNS} histogram Zn load'},'FontSize',16,'Location','NorthWest'); 
legend boxoff
xlim([0,1]);ylim([0,600]);xlabel('{\itNS}','FontSize',16);ylabel('Counts','FontSize',16);
set(gca,'tickdir','out');
hold on;
xL=xlim;yL=ylim;
plot([xL(2),xL(2)],[yL(1),yL(2)],'k','linewidth',2)
plot(xL,[yL(2),yL(2)],'k','linewidth',2)
box off
axis([xL yL]);
% title('NS histogram of Zn load')
subplot(312)
h=histogram(cell2mat(pb{1,3}),20,'FaceColor',[55/256 126/256 184/256]);
% set(h,'LineWidth',1.5);
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
legend({' (b) {\itPBIAS} histogram of Zn load'},'FontSize',16,'Location','NorthWest');
legend boxoff;
xlim([-1,1]);xlabel('{\itPBIAS}','FontSize',16);ylabel('Counts','FontSize',16);
set(gca,'tickdir','out');
hold on;
xL=xlim;yL=ylim;
plot([xL(2),xL(2)],[yL(1),yL(2)],'k','linewidth',2)
plot(xL,[yL(2),yL(2)],'k','linewidth',2)
box off
axis([xL yL]);
% title('pbias histogram Zn load')
subplot(313)
h=histogram(cell2mat(RR{1,3}),20,'FaceColor',[77/256 175/256 74/256]);
% set(h,'LineWidth',1.5);
set(gca,'LineWidth',2);
set(gca,'FontSize',12);
legend({' (c) {\itR}^2 histogram of Zn load'},'FontSize',16,'Location','NorthWest');
legend boxoff;
xlim([0,1]);xlabel('{\itR}^2','FontSize',16);ylabel('Counts','FontSize',16);
set(gca,'tickdir','out');
hold on;
xL=xlim;yL=ylim;
plot([xL(2),xL(2)],[yL(1),yL(2)],'k','linewidth',2)
plot(xL,[yL(2),yL(2)],'k','linewidth',2)
box off
axis([xL yL]);
% title('R2 histogram Zn load')

save hmStats ns pb RR

figure
subplot(2,2,1)
scatter(cell2mat(ns{1,3}),cell2mat(RR{1,3}))
xlabel('NS');ylabel('R^2');
subplot(2,2,2)
scatter(cell2mat(ns{1,3}),cell2mat(pb{1,3}))
xlabel('NS');ylabel('PBIAS');
subplot(2,2,3)
scatter(cell2mat(RR{1,3}),cell2mat(pb{1,3}))
xlabel('R^2');ylabel('PBIAS');
subplot(2,2,4)
scatter3(cell2mat(ns{1,3}),cell2mat(RR{1,3}),cell2mat(pb{1,3}))
xlabel('NS');ylabel('R^2');zlabel('PBIAS');
