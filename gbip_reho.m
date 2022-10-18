function gbip_reho(ADataDir, voxelsize, AMaskFilename, AResultFilename)
% gbip_reho(ADataDir, voxelsize, AMaskFilename, AResultFilename)
% modified reho from REST toolbox for Alberta Children's Hospital

CUTNUMBER = 10;

theElapsedTime =cputime;

% Examine the Nvoxel
% --------------------------------------------------------------------------
AllVolume = load_nii(ADataDir);
AllVolume = AllVolume.img;
[nDim1 nDim2 nDim3 nDimTimePoints]=size(AllVolume);
M=nDim1;N=nDim2;O=nDim3;
isize = [nDim1 nDim2 nDim3]; 
vsize = [voxelsize,voxelsize,voxelsize];
maskh=load_nii(AMaskFilename);
mask = maskh.img;

%Algorithm re-written by YAN Chao-Gan, 090422. Speed up the calculation of ReHo.
%rank the 3d+time functional images voxel by voxel
% -------------------------------------------------------------------------
AllVolume=reshape(AllVolume,[],nDimTimePoints)';

% Calcualte the rank

fprintf('\n\t Rank calculating...');

%YAN Chao-Gan, 120328. No longer change to uint16 type.
Ranks_AllVolume = repmat(zeros(1,size(AllVolume,2)), [size(AllVolume,1), 1]);
%Ranks_AllVolume = repmat(uint16(zeros(1,size(AllVolume,2))), [size(AllVolume,1), 1]);

SegmentLength = ceil(size(AllVolume,2) / CUTNUMBER);
for iCut=1:CUTNUMBER
    if iCut~=CUTNUMBER
        Segment = (iCut-1)*SegmentLength+1 : iCut*SegmentLength;
    else
        Segment = (iCut-1)*SegmentLength+1 : size(AllVolume,2);
    end
    
    AllVolume_Piece = AllVolume(:,Segment);
    nVoxels_Piece = size(AllVolume_Piece,2);
    
    [AllVolume_Piece,SortIndex] = sort(AllVolume_Piece,1);
    db=diff(AllVolume_Piece,1,1);
    db = db == 0;
    sumdb=sum(db,1);
    
    %YAN Chao-Gan, 120328. No longer change to uint16 type.
    SortedRanks = repmat([1:nDimTimePoints]',[1,nVoxels_Piece]);
    %SortedRanks = repmat(uint16([1:nDimTimePoints]'),[1,nVoxels_Piece]);
    % For those have the same values at the current time point and previous time point (ties)
    if any(sumdb(:))
        TieAdjustIndex=find(sumdb);
        for i=1:length(TieAdjustIndex)
            ranks=SortedRanks(:,TieAdjustIndex(i));
            ties=db(:,TieAdjustIndex(i));
            tieloc = [find(ties); nDimTimePoints+2];
            maxTies = numel(tieloc);
            tiecount = 1;
            while (tiecount < maxTies)
                tiestart = tieloc(tiecount);
                ntied = 2;
                while(tieloc(tiecount+1) == tieloc(tiecount)+1)
                    tiecount = tiecount+1;
                    ntied = ntied+1;
                end
                % Compute mean of tied ranks
                ranks(tiestart:tiestart+ntied-1) = ...
                    sum(ranks(tiestart:tiestart+ntied-1)) / ntied;
                tiecount = tiecount + 1;
            end
            SortedRanks(:,TieAdjustIndex(i))=ranks;
        end
    end
    clear db sumdb;
    SortIndexBase = repmat([0:nVoxels_Piece-1].*nDimTimePoints,[nDimTimePoints,1]);
    SortIndex=SortIndex+SortIndexBase;
    clear SortIndexBase;
    Ranks_Piece = zeros(nDimTimePoints,nVoxels_Piece);
    Ranks_Piece(SortIndex)=SortedRanks;
    clear SortIndex SortedRanks;
    
    %YAN Chao-Gan, 120328. No longer change to uint16 type.
    %Ranks_Piece=uint16(Ranks_Piece); % Change to uint16 to get the same results of previous version.

    Ranks_AllVolume(:,Segment) = Ranks_Piece;
    fprintf('.');
end

Ranks_AllVolume = reshape(Ranks_AllVolume,[nDimTimePoints,nDim1 nDim2 nDim3]);


% calulate the kcc for the data set
% ------------------------------------------------------------------------
fprintf('\n\t Calculate the kcc on voxel by voxel for the data set.');
K = zeros(M,N,O); 

for i = 2:M-1
    for j = 2:N-1
        for k = 2:O-1
            block = Ranks_AllVolume(:,i-1:i+1,j-1:j+1,k-1:k+1);
            mask_block = mask(i-1:i+1,j-1:j+1,k-1:k+1);
            if mask_block(2,2,2)~=0
                %YAN Chao-Gan 090717, We also calculate the ReHo value of the voxels near the border of the brain mask, users should be cautious when dicussing the results near the border. %if all(mask_block(:))
                R_block=reshape(block,[],27); %Revised by YAN Chao-Gan, 090420. Speed up the calculation.
                mask_R_block = R_block(:,reshape(mask_block,1,27) > 0);
                K(i,j,k) = f_kendall(mask_R_block);
            end %end if
        end%end k
    end% end j
    fprintf('.');
end%end i
fprintf('\t The reho of the data set was finished.\n');
maskh.img = K;
maskh.hdr.dime.bitpix = 16;
maskh.hdr.dime.datatype = 16;
save_nii(maskh,AResultFilename); %Revised by YAN Chao-Gan, 090321. Result data will be stored in 'single' format. %'double');

theElapsedTime =cputime - theElapsedTime;
fprintf('\n\tRegional Homogeneity computation over, elapsed time: %g seconds\n', theElapsedTime);


% calculate kcc for a time series
%---------------------------------------------------------------------------
function B = f_kendall(A)
nk = size(A); n = nk(1); k = nk(2);
SR = sum(A,2); SRBAR = mean(SR);
S = sum(SR.^2) - n*SRBAR^2;
B = 12*S/k^2/(n^3-n);
