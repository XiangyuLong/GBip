function hm = gbip_restfMRI_Acompcor(datadirectory,tr)

% hm = gbip_restfMRI_Acompcor(datadirectory,tr)
% Getting anatomical compcor outputs with other signals as regressors
% The output of aCompcor is the first 5 principal components of CSF and WM masks each, so together there are 10 components
% Other regressors: 6 motions, temporal derivatives of 6 motions, global signal, spikes from FD analysis
% niftiread is needed.
% The datadirectory should be the full directory of the folder of fmri data, such as: "/subj-001/func/"
% if the time length < 4 minutes after scrubbing, hm = 1;

fmridata = niftiread([datadirectory,'rest_dmdt.nii.gz']);

NumberofVolumes = size(fmridata,4);

csfmask = niftiread([datadirectory,'/segment/csf_mask.nii.gz']);
wmmask = niftiread([datadirectory,'/segment/wm_mask.nii.gz']);

csfsignals = [];
wmsignals = [];
csfvoxels = csfmask>0;
wmvoxels = wmmask>0;

for i = 1 : size(fmridata,4)
    tempdata = fmridata(:,:,:,i);
    csfsignals(i,:) = tempdata(csfvoxels);   
end

for i = 1 : size(fmridata,4)
    tempdata = fmridata(:,:,:,i);
    wmsignals(i,:) = tempdata(wmvoxels);   
end

% PCA analysis
[~, score, ~] = pca(csfsignals);
csf_acompcor = score(:,1:5);

[~, score, ~] = pca(wmsignals);
wm_acompcor = score(:,1:5);

b = exist([datadirectory,'/regressors/rest_fd_matrix.txt']);
if b == 0
    rest_fd_matrix = [];
else
    rest_fd_matrix = load([datadirectory,'/regressors/rest_fd_matrix.txt']);
end

% 4 minutes check
nscrub = length(find(rest_fd_matrix==1)) * tr;

if nscrub == 0 || NumberofVolumes*tr - nscrub >= 240
    hm = 0;
else
    if NumberofVolumes*tr - nscrub < 240
        hm = 1;
    end
end
g = load([datadirectory,'/regressors/global.1D']);
g = g - mean(g);

rest_mcf = load([datadirectory,'/regressors/rest_mcf.par']);

rest_mcf_td = [zeros(1,size(rest_mcf,2));diff(rest_mcf)];

allcovs = [rest_mcf,rest_mcf_td,csf_acompcor,wm_acompcor,g,rest_fd_matrix];

save([datadirectory,'/regressors/compcor_regsandspikes.1D'], 'allcovs', '-ASCII', '-DOUBLE','-TABS');


    