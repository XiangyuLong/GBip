function r_thr = gbip_rcutoff(p,dsize)

% r_thr = gbip_rcutoff(p,dsize);
% output is abs value of r threshold;
% p should be 0.00X .

rt = tinv(1-p/2,dsize-2);
r_thr = rt/(sqrt(dsize-2+rt*rt));
