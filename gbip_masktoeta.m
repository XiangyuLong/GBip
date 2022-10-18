function etamatrix = gbip_masktoeta(ADataDir,roimask,wholebrainmask,corrcond)

% etamatrix = gbip_masktoeta(ADataDir,roimask,wholebrainmask,corrcond);
% REST and nifti toolbox are requaired

temp = load_nii(ADataDir);
AllVolume = temp.img;
a = load_nii(roimask);
a = a.img;

roiindex = a>0;
[ROIindex(:,1),ROIindex(:,2),ROIindex(:,3)] = ind2sub(size(a),find(a>0));

AllVolume = reshape(AllVolume,size(AllVolume,1)*size(AllVolume,2)*size(AllVolume,3),size(AllVolume,4));
roivolume = AllVolume(roiindex,:)';

if exist('wholebrainmask','var')
    mask = load_nii(wholebrainmask);
    mask = mask.img;
    mroiindex = mask>0;
    maskvolume = AllVolume(mroiindex,:)';
else
    maskvolume = roivolume;
end

allfcmap = corr(roivolume,maskvolume);
clear AllVolume roivolume maskvolume;

switch corrcond
    case 'positive'
        allfcmap(allfcmap<0) = 0;
    case 'negative'
        allfcmap(allfcmap>0) = 0;
    case 'all'
        allfcmap = allfcmap;
end

etamat = zeros(size(ROIindex,1),size(ROIindex,1));

for i = 1 : size(allfcmap,1)
    imagea = allfcmap(i,:);
    for j = i+1 : size(allfcmap,1)
        imageb= allfcmap(j,:);
        etamat(i,j) = gbip_etas(imagea,imageb);
        etamat(j,i) = etamat(i,j);
    end
    etamat(i,i) = 1;
end
etamat(isnan(etamat)) = 0;
etamat(isinf(etamat)) = 0;
etamatrix.ROIlist = ROIindex;
etamatrix.etamat = etamat;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
