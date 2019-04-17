function best_obj = gbip_clustering(etamatrix,clustnum,brmask,newname,clusag)

% best_obj = gbip_clustering(etamatrix,clustnum,brmask,newname,clusag)
% 'km','skm','hc'
% Spectral Clustering Toolbox is required

a = load_nii(brmask);
etamat = etamatrix.etamat;
roilist = etamatrix.ROIlist;

switch clusag
    case 'km'
        best_obj =  kmeans(etamat,clustnum,'Replicates',1000);
    case 'skm'
        init_spectral;
        KMEANS_MAX_ITER = 1000;
        best_obj = mcut_kmeans(etamat,clustnum);
    case 'hc'
        Z = linkage(1-etamat,'average');
        best_obj = cluster(Z,'maxclust',clustnum);
end

funcarea = zeros(size(a.img));
for i = 1 : size(etamat,1)
    funcarea(roilist(i,1),roilist(i,2),roilist(i,3)) = best_obj(i);
end
a.img = funcarea;
save_nii(a,newname);