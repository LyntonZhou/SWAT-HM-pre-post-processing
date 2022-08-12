function [ monthlymeandata,monthlysumdata,monthlystddata,monthlyskewdata,ym] = DailyToMonthly1(data,ysmd)
% DailyToMonthly

%% Monthly
[~,cols]=size(data);
dailydata = [ysmd(:,1:3),data];
[a,~,c] = unique(dailydata(:,1:2),'rows');
for ii = 1:cols
%     switch ii
%         case {1,2,3,4,5,6,7,8,9,10,11,12}
%             monthlytemp = [a, accumarray(c,dailydata(:,ii+3),[],@sum)];
%         case {13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36}
%             monthlytemp = [a, accumarray(c,dailydata(:,ii+3),[],@mean)];
%     end
       monthlymeantemp = [a, accumarray(c,dailydata(:,ii+3),[],@mean)];
       monthlysumtemp = [a, accumarray(c,dailydata(:,ii+3),[],@sum)];
       monthlystdtemp = [a, accumarray(c,dailydata(:,ii+3),[],@std)];
       monthlyskewtemp = [a, accumarray(c,dailydata(:,ii+3),[],@skewness)];
    ym = monthlymeantemp(:,1:2);
    monthlymeandata(:,ii) = monthlymeantemp(:,3);
    monthlysumdata(:,ii) = monthlysumtemp(:,3);
    monthlystddata(:,ii) = monthlystdtemp(:,3);
    monthlyskewdata(:,ii) = monthlyskewtemp(:,3);
end

clear monthlytemp datestr dateend dateii ...
    a c d y m ii
end

