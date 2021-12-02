function [SubLoc] = findStations(LongLat,MonitoringPoint)

for ii=1:numel(LongLat(:,1))
    
    [len(ii,:),~]=distance(LongLat(ii,2),LongLat(ii,1),MonitoringPoint(:,6),MonitoringPoint(:,7));
    [~,idx] = min(len(ii,:));
    SubLoc(ii,1)=MonitoringPoint(idx,11);
    
end
end

