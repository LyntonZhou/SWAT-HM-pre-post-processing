function [ pbiasvalue ] = pbias( pp )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
obs=pp(:,1);
sim=pp(:,2);
pbiasvalue=sum(obs-sim)/sum(obs);
end

