function [Obs,SubLoc] = makeObs(workdir,LongLat,ObsStations,txt)

MonitoringPoint = xlsread([workdir '\MonitoringPoint.xls']);
SubLoc = findStations(LongLat,MonitoringPoint);
ym = [year(txt'),month(txt')];
Obs = [ym,ObsStations'];

end

