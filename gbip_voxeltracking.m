function [outimg, allmaxind] = gbip_voxeltracking(seedmask,inputdata,tracksteps,newname)

% [outimg allmaxind] = mpi_voxeltracking('seedmask.nii','./sub01',5,'voxeltrack');
% track steps problem.
[AllVolume,~,~,~] = rest_to4d(inputdata);
[a , b, c] = rest_readfile(seedmask);
outimg = zeros(size(a));
[seedx,seedy,seedz] = ind2sub(size(a),find(a>0));
allmaxind = [seedx,seedy,seedz];
i=1;

while size(allmaxind,1) <= tracksteps
    tempmaxind = maxneighborvoxel(allmaxind(i,1),allmaxind(i,2),allmaxind(i,3),AllVolume);
    AllVolume(allmaxind(i,1),allmaxind(i,2),allmaxind(i,3),:) = 0;
    if isempty(intersect(allmaxind,tempmaxind,'rows')) == 1
        allmaxind = [allmaxind;tempmaxind];
        i = i + 1;
    end
    disp(i);
end

for i = 1 : size(allmaxind,1)
    outimg(allmaxind(i,1),allmaxind(i,2),allmaxind(i,3)) = i;
end
rest_writefile(outimg,newname,size(a),b',c,'single');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tempmaxind = maxneighborvoxel(seedx,seedy,seedz,AllVolume)

seedts = squeeze(AllVolume(seedx,seedy,seedz,:));
block = squeeze(AllVolume(seedx-1:seedx+1,seedy-1:seedy+1,seedz-1:seedz+1,:));
temprblock = zeros(3,3);
for x = 1 : 3
    for y = 1 : 3
        for z = 1 : 3
            tempr = corrcoef(seedts,block(x,y,z,:));
            temprblock(x,y,z) = tempr(1,2);
        end
    end
end
temprblock(2,2,2) = 0;
[p v] = maxvoxel_3D(temprblock);
tempmaxind = [seedx-2+v(1),seedy-2+v(2),seedz-2+v(3)];
    
    
    