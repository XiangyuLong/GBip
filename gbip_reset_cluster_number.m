function newinputmap = gbip_reset_cluster_number(inputmapa,targetmapa,newname)

% newinputmap = gbip_reset_cluster_number(inputmapa,targetmapa,newname)
% need NIFTI toolbox
% inputs are nifti images
% newname has to be sth.nii

inputimg = load_nii(inputmapa);
targetimg = load_nii(targetmapa);
inputmap = inputimg.img;
targetmap = targetimg.img;

inputmap = inputmap(inputmap>0);
targetmap = targetmap(targetmap>0);
clusternum = 1:maxvoxel_3D(targetmap);
permcluster = perms(clusternum);
permdc = zeros(1,size(permcluster,1));

for i = 1 : size(permcluster,1)
    tempinputmap = zeros(size(inputmap));
    for j = 1 : size(permcluster,2)
        tempinputmap(inputmap==j) = permcluster(i,j);
    end
    mergemap = int16(targetmap) - int16(tempinputmap);
    permdc(i) = (length(targetmap>0) - length(find(mergemap~=0)))/length(targetmap>0);
end
[~, permindex] = max(permdc);

newinputmap = zeros(size(inputmap));
for j = 1 : size(permcluster,2)
    newinputmap(inputmap==j) = permcluster(permindex,j);
end

inputmap = inputimg.img;
inputmap(inputmap>0) = newinputmap;
inputimg.img = inputmap;
save_nii(inputimg,[inputmapa(1:end-4),newname]);
   
    
