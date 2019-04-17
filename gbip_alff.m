function [ALFFBrain, Header] = gbip_alff(ADataDir,voxelsize, ASamplePeriod, HighCutoff, LowCutoff, AMaskFilename, AResultFilename)
% [ALFFBrain, Header] = gbip_alff(ADataDir,voxelsize, ASamplePeriod, HighCutoff, LowCutoff, AMaskFilename, AResultFilename)
% modified alff from REST toolbox for Alberta Children's Hospital

CUTNUMBER = 10;

theElapsedTime =cputime;

fprintf('\nComputing ALFF...');

AllVolume = load_nii(ADataDir);
AllVolume = AllVolume.img;

[nDim1 nDim2 nDim3 nDimTimePoints]=size(AllVolume);
BrainSize = [nDim1 nDim2 nDim3];
VoxelSize = [voxelsize,voxelsize,voxelsize];

fprintf('\n\t Load mask "%s".', AMaskFilename);
maskh=load_nii(AMaskFilename);
mask = maskh.img;
MaskData = logical(mask);

% Convert into 2D
AllVolume=reshape(AllVolume,[],nDimTimePoints)';

MaskDataOneDim=reshape(MaskData,1,[]);
AllVolume=AllVolume(:,find(MaskDataOneDim));

% Get the frequency index
sampleFreq 	 = 1/ASamplePeriod;
sampleLength = nDimTimePoints;
paddedLength = rest_nextpow2_one35(sampleLength); %2^nextpow2(sampleLength);
if (LowCutoff >= sampleFreq/2) % All high included
    idx_LowCutoff = paddedLength/2 + 1;
else % high cut off, such as freq > 0.01 Hz
    idx_LowCutoff = ceil(LowCutoff * paddedLength * ASamplePeriod + 1);
    % Change from round to ceil: idx_LowCutoff = round(LowCutoff *paddedLength *ASamplePeriod + 1);
end
if (HighCutoff>=sampleFreq/2)||(HighCutoff==0) % All low pass
    idx_HighCutoff = paddedLength/2 + 1;
else % Low pass, such as freq < 0.08 Hz
    idx_HighCutoff = fix(HighCutoff *paddedLength *ASamplePeriod + 1);
    % Change from round to fix: idx_HighCutoff	=round(HighCutoff *paddedLength *ASamplePeriod + 1);
end


% Detrend before fft as did in the previous alff.m
%AllVolume=detrend(AllVolume);
% Cut to be friendly with the RAM Memory
SegmentLength = ceil(size(AllVolume,2) / CUTNUMBER);
for iCut=1:CUTNUMBER
    if iCut~=CUTNUMBER
        Segment = (iCut-1)*SegmentLength+1 : iCut*SegmentLength;
    else
        Segment = (iCut-1)*SegmentLength+1 : size(AllVolume,2);
    end
    AllVolume(:,Segment) = detrend(AllVolume(:,Segment));
end


% Zero Padding
AllVolume = [AllVolume;zeros(paddedLength -sampleLength,size(AllVolume,2))]; %padded with zero

fprintf('\n\t Performing FFT ...');
%AllVolume = 2*abs(fft(AllVolume))/sampleLength;
% Cut to be friendly with the RAM Memory
SegmentLength = ceil(size(AllVolume,2) / CUTNUMBER);
for iCut=1:CUTNUMBER
    if iCut~=CUTNUMBER
        Segment = (iCut-1)*SegmentLength+1 : iCut*SegmentLength;
    else
        Segment = (iCut-1)*SegmentLength+1 : size(AllVolume,2);
    end
    AllVolume(:,Segment) = 2*abs(fft(AllVolume(:,Segment)))/sampleLength;
    fprintf('.');
end


ALFF_2D = mean(AllVolume(idx_LowCutoff:idx_HighCutoff,:));

% Get the 3D brain back
ALFFBrain = zeros(size(MaskDataOneDim));
ALFFBrain(1,find(MaskDataOneDim)) = ALFF_2D;
ALFFBrain = reshape(ALFFBrain,nDim1, nDim2, nDim3);

%Save ALFF image to disk
fprintf('\n\t Saving ALFF map.\tWait...');

maskh.img = ALFFBrain;
maskh.hdr.dime.bitpix = 16;
maskh.hdr.dime.datatype = 16;
save_nii(maskh,AResultFilename);

theElapsedTime = cputime - theElapsedTime;
fprintf('\n\t ALFF compution over, elapsed time: %g seconds.\n', theElapsedTime);

