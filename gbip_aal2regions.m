function brainareas = gbip_aal2regions(tempaal)

% brainareas = gbip_aal2regions(tempaal)
% the order of brainareas is frontal,temporal, parietal, occipital, insula, cingulate, deep
% grey matter from 1 to 7.

if tempaal <= 28 % frontal
    brainareas = 1;
end
if tempaal == 29 || tempaal == 30  % insula
    brainareas = 5;
end
if tempaal > 30 && tempaal <= 36 % cingulate
    brainareas = 6;
end
if tempaal > 36 && tempaal <= 42 % deep grey matter
    brainareas = 7;
end
if tempaal > 42 && tempaal <= 54 % occipital
    brainareas = 4;
end
if tempaal > 54 && tempaal <= 70 % pariatal
    brainareas = 3;
end
if tempaal > 70 && tempaal <= 78 % deep grey matter
    brainareas = 7;
end
if tempaal > 78 && tempaal <= 90 % temporal
    brainareas = 2;
end
if tempaal > 90 % other
    brainareas = 999;
end  