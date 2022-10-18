function gbip_maskseed_fc(ADataDir,roimask,AMaskFilename,AResultFilename)

% gbip_maskseed_fc(ADataDir,roimask,AMaskFilename,AResultFilename);
% need nifti toolbox


AllVolume = load_nii(ADataDir);
AllVolume = AllVolume.img;

roi = load_nii(roimask);
roia = roi.img;
roiindex = roia>0;

maskh = load_nii(AMaskFilename);
mask = maskh.img;
mroiindex = mask>0;

AllVolume = reshape(AllVolume,size(AllVolume,1)*size(AllVolume,2)*size(AllVolume,3),size(AllVolume,4));
roivolume = mean(AllVolume(roiindex,:))';
maskvolume = AllVolume(mroiindex,:)';

Rmap = corr(roivolume,maskvolume);
Rmap = 0.5 * log((1 +Rmap)./(1- Rmap));
Rmap(isnan(Rmap)) = 0;
temprmap = zeros(size(mask));
temprmap(mroiindex) = Rmap;

maskh.hdr.dime.datatype = 16;
maskh.hdr.dime.bitpix = 16;
maskh.img = temprmap;
save_nii(maskh,AResultFilename);