function cohend = gbip_CohenD(data1,data2)

% cohend = gbip_CohenD(data1,data2)

dmean = mean(data1) - mean(data2);

stdpooled = sqrt((std(data1)^2 + std(data2)^2)/2);

cohend = abs(dmean/stdpooled);
