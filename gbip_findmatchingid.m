function [match_to_aim_id,allp] = gbip_findmatchingid(alldemos,aimgroup,poolgroup)

% find the matching group for the aim group
% [match_to_aim_id,allp] = gbip_findmatchingid(alldemos,aimgroup,poolgroup)
% alldemos is a N X M matrix, N = pariticipants, M = covariates, the first
% column should be sex=[1,2]
% aimgroup (patients) and poolgroup (the controls) are the indecies of each group in alldemos
% allp: p-values of the differences between aim group and matched group

match_to_aim_id = [];
pooldemos = alldemos(poolgroup,:);
for i = 1 : length(aimgroup)
    tempsex = alldemos(aimgroup(i),1);
    poolsexind = find(alldemos(poolgroup,1)==tempsex);
    demodiff = sum(abs(alldemos(aimgroup(i),2:end) - pooldemos(poolsexind,2:end)),2);
    [~,minind] = min(demodiff);
    match_to_aim_id(i,1) = poolgroup(poolsexind(minind));
    pooldemos(poolsexind(minind),:) = 999 + pooldemos(poolsexind(minind),:);
end
match_to_aim_id = unique(match_to_aim_id);
% test stats between the aim group and the matched group
allp=[];
for i = 1 : size(alldemos,2)
    [~,P,~,~] = ttest2(alldemos(aimgroup,i),alldemos(match_to_aim_id,i));
    allp(i,1) = P;
end


        







