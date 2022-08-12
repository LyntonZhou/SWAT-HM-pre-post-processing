function [ pbiasvalue ] = pbias( pp )
%Summary of this function goes here
%   Detailed explanation goes here
obs=pp(:,1);
sim=pp(:,2);
pbiasvalue=sum(sim-obs)/sum(obs);
end

