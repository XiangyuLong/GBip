function [p v] = gbip_maxvoxel_3D(x)
% [p v] = maxvoxel_3D(x)
[p1 v1] = max(x);
[p2 v2] = max(p1);
[p3 v3] = max(p2);
a = v2(:,:,v3);
p = p3;
v = [v1(:,a,v3),a,v3];