function gbip_findClusterVoxelID(maxVoxelID,filename,newfilename,rad)
% find all the voxel ID within a culster
% findClusterVoxelID(maxVoxelID,filename,newfilename,rad);
% maxVoxelID is the max activated voxel ID,Matlab coordinates.maxVoxelID = [x y z]
% rad: the spatial extend of cluster, 1 rad = 1 voxel, if don't need it,
% set rad = 0;
% findClusterVoxelID(maxVoxelID,filename,newfilename,rad) can creat a img file that
% only have the cluster in it.
% Based on the code of Dr. Meng Liang.

% read the file
% fid = fopen (filename, 'r');
% [DiffBrain, Count] = fread (fid, 61*73*61, 'short');
% fclose(fid);
% DiffBrain = reshape (DiffBrain, [61 73 61]);

DiffBraina = load_nii(filename);
DiffBrain = DiffBraina.img;
m = size(DiffBrain,1);
n = size(DiffBrain,2);
o = size(DiffBrain,3);

% definition of variables
SearchFlag=zeros(size(DiffBrain));                            % recording if the voxel has been searched
SearchVoxelNum=0;                                             % the number of the voxels which has been searched  
ClusterVoxNum=1;                                              % the number of the voxels within the cluster
SearchFlag(maxVoxelID(1),maxVoxelID(2),maxVoxelID(3))=1;      % initiating the SearchFlag using maxVoxelID
if size(maxVoxelID)==[3 1]                                     % initiating the ClusterVoxelID and CurrentVoxel using maxVoxelID
    ClusterVoxelID=maxVoxelID';                               % saving all the voxel ID within the cluster
    CurrentVoxel=maxVoxelID';                                 % saving the current voxel ID which is being searched
else
    ClusterVoxelID=maxVoxelID;
    CurrentVoxel=maxVoxelID;
end

while SearchVoxelNum<=ClusterVoxNum
    for dx=-1:1
        for dy=-1:1
            for dz=-1:1
                VoxelID=CurrentVoxel+[dx dy dz];
                if  VoxelID(1) <= m && VoxelID(2) <= n && VoxelID(3) <= o && ...
                    DiffBrain(VoxelID(1),VoxelID(2),VoxelID(3)) ~= 0 && ...
                        SearchFlag(VoxelID(1),VoxelID(2),VoxelID(3)) == 0
                    ClusterVoxelID=[ClusterVoxelID; VoxelID];
                    SearchFlag(VoxelID(1),VoxelID(2),VoxelID(3))=1;
                    ClusterVoxNum=ClusterVoxNum+1;
                end
            end
        end
    end
    SearchVoxelNum=SearchVoxelNum+1;
    if SearchVoxelNum<=ClusterVoxNum
        CurrentVoxel=ClusterVoxelID(SearchVoxelNum,:);
    end
end

if rad ~= 0
    widecube = zeros(size(DiffBrain));
    widecube((maxVoxelID(1)-rad) : (maxVoxelID(1)+rad),(maxVoxelID(2)-rad) : (maxVoxelID(2)+rad),(maxVoxelID(3)-rad) : (maxVoxelID(3)+rad)) = 1;
    temp1 = widecube + SearchFlag;
    out = find(temp1 == 1);
    for i = 1 : size(out,1)
        temp1(out(i)) = 0;
    end
    temp2 = temp1 ./ temp1;
    warning off MATLAB:divideByZero;
    DiffBraina.img = temp1;
    save_nii(DiffBraina,newfilename);
else
    DiffBraina.img = SearchFlag;
    save_nii(DiffBraina,newfilename);
end



