function [ Ens ] = nscoeff( pp )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
nrows=size(pp,1);
obs=pp(:,1);
sim=pp(:,2);
aveobs=mean(obs);
Ens=1-(sum((obs-sim).^2))/(sum((obs-aveobs).^2));
end

