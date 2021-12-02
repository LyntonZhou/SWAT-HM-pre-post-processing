function [ monthlymeandata,monthlystddata,monthlyskewdata] = DailyToMonthly2(data,ysmd)
% DailyToMonthly

%% Monthly
dailydata = [ysmd,data];
[a,~,c] = unique(dailydata(:,[1,3]),'rows');
% [a,~,c] = unique(dailydata(:,2),'rows');
for ii = 1:12
    switch ii
        case {1,2,3,4,5,6,7,8,9,10,11,12}
            monthlymeantemp = [a, accumarray(c,dailydata(:,ii+4),[],@sum)];
        case {13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36}
            monthlymeantemp = [a, accumarray(c,dailydata(:,ii+4),[],@mean)];
    end
    
    monthlystdtemp = [a, accumarray(c,dailydata(:,ii+4),[],@std)];
    monthlyskewtemp = [a, accumarray(c,dailydata(:,ii+4),[],@skewness)];
    
    monthlymeandata(:,ii) = monthlymeantemp(:,3);
    monthlystddata(:,ii) = monthlystdtemp(:,3);
    monthlyskewdata(:,ii) = monthlyskewtemp(:,3);
end

clear monthlytemp datestr dateend dateii ...
    a c d y m ii
end

