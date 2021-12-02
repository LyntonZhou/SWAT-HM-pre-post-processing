function [pfactor,rfactor] = prfactor(ub,lb,obs,ep)
% p-factor and r factor
count = 0;
obs_ub = obs * (1+ep);
obs_lb = obs * (1-ep);

for ii=1:numel(obs)
    if obs_lb(ii) > ub(ii)
        count = count;
        %ii
    elseif obs_ub(ii) < lb(ii)
        count = count;
        %ii
    else
        count = count+1;
    end
end
        
        
pfactor = count/numel(obs);
rfactor = sum(ub-lb)/numel(obs)/std(obs);

end

