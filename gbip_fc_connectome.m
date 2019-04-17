function fccon = gbip_fc_connectome(ADataDir,roimask)

% fccon = ach_fc_connectome(ADataDir,roimask);
% need nifti toolbox

AllVolume = load_nii(ADataDir);
AllVolume = AllVolume.img;

roi = load_nii(roimask);
roi = roi.img;
roimean = zeros(max(max(max(roi))),size(AllVolume,4));

for i = 1 : max(max(max(roi)))
    temproi = zeros(size(roi));
    temproi(roi==i) = 1;
    for k = 1 : size(AllVolume,4)
        tempvol = AllVolume(:,:,:,k) .* temproi;
        roimean(i,k) = sum(sum(sum(tempvol)))/length(find(temproi==1));
    end
end

fccon = corr(roimean',roimean');
for i = 1 : size(fccon,1)
    fccon(i,i) = 0;
end

fccon = 0.5 * log((1+fccon)./(1-fccon));

