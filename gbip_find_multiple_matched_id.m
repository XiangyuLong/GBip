function matchedoutput = gbip_find_multiple_matched_id(demoinfor, aimgroupid,inputgroupid)

% matchedoutput = gbip_find_multiple_matched_id(demoinfor, aimgroupid,inputgroupid)
% demoinfor should be participants x variables
% the output are matched to the group mean of the aimed group

tempa = mean(demoinfor(aimgroupid,:),1);
tempb = demoinfor(inputgroupid,:);

tempc = sum(abs(tempb - tempa),2);
[~,i] = sort(tempc);
matchedoutput = inputgroupid(i(1:length(aimgroupid)));

c = unique(matchedoutput);
if length(c) == length(matchedoutput)
    disp('Matching Sucessfully!');
else
    disp('Can not find the matched id!');
end
