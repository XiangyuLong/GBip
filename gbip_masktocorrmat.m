function corrmat = gbip_masktocorrmat(ADataDir,roimask,AMaskFilename)

% corrmat = mpi_masktocorrmat(ADataDir,roimask,AMaskFilename);
% REST requaired

[AllVolume,VoxelSize,theImgFileList, Header] = rest_to4d(ADataDir);

close hidden;

datainfo.vo = AllVolume;
datainfo.vs = VoxelSize;
datainfo.fl = theImgFileList;
datainfo.he = Header;

[maskd , ~] = rest_readfile(AMaskFilename);
[a , ~] = rest_readfile(roimask);
roiindex = a>0;
maskindex = maskd>0;

AllVolume = reshape(AllVolume,size(AllVolume,1)*size(AllVolume,2)*size(AllVolume,3),size(AllVolume,4));
roivolume = AllVolume(roiindex,:)';
maskvolume = AllVolume(maskindex,:)';
corrmat = corr(maskvolume,roivolume);