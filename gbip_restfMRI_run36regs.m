% 36 regressors
clear;
datadir = '/Users/longxiangyu/Documents/ResearchData/Achps/';
allid = dir([datadir,'newps/*']);
allhm = zeros(length(allid),1);
tr=2;
for i = 4 : length(allid)
    datadirectory = [datadir,'newps/',allid(i).name,'/func/regressors/'];
    allhm(i) = ach_create36regs(datadirectory,tr);
end
size(find(allhm==1))
remove high head motion data, <4min
for i = 1 : length(allhm)
    if allhm(i) == 1
        unix(['mv ',datadir,'motiondata/',allid(i).name,' ',datadir,'lessthan4/']);
    end
end

% mean FD > 0.25, rms FD >0.5
clear;
datadir = '/Users/longxiangyu/Documents/ResearchData/Achps/';
allid = dir([datadir,'gooddata/*']);
hmid=[];
n=1;
for i = 4 : length(allid)
    load([datadir,'gooddata/',allid(i).name,'/func/rest_mcf_rel_mean.rms']);
    if rest_mcf_rel_mean > 0.5
        unix(['mv ',datadir,'gooddata/',allid(i).name,' ',datadir,'lessthan4_meanfd0p5/']);
    end
end