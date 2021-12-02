function [ KGE ] = kge( pp )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
nrows=size(pp,1);
obs=pp(:,1);
sim=pp(:,2);
aveobs = mean(obs);
avesim = mean(sim);
stdobs = std(obs);
stdsim = std(sim);
rho = corr (obs, sim);
KGE=1-((rho-1)^2+(avesim/aveobs-1)^2+(stdsim/stdobs-1)^2)^0.5;
end

