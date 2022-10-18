function matchcon = gbip_find_agesex_matched_id(agesexinfor, aimgroupid,inputgroupid)

% matchcon = gbip_find_agesex_matched_id(agesexinfor, aimgroupid,inputgroupid)
% agesexinfor is a n x 2 vectors, the first column is age, the second is sex
% matchcon(:,2) is the output matched id

matchcon = zeros(length(aimgroupid),2);
for i = 1 : length(aimgroupid)
    matchcon(i,1) = aimgroupid(i);
    tempid = find(agesexinfor(inputgroupid,2)==agesexinfor(aimgroupid(i),2));
    tempage = agesexinfor(inputgroupid(tempid),1) - agesexinfor(aimgroupid(i),1);
    [~, tempageid] = min(abs(tempage));
    matchcon(i,2) = inputgroupid(tempid(tempageid));
    agesexinfor(inputgroupid(tempid(tempageid)),:) = [999 999];
end

c = unique(matchcon(:,2));
if isempty(intersect(c,aimgroupid)) == 1
    disp('Matching Sucessfully!');
end