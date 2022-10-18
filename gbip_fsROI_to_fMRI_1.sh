#!/usr/bin/env bash

# pre-defined parameters

output_directory=$1
subjectID=$2
freesurfer_directory=$3
fMRI_directory=$4

# example: 
# /Users/longxiangyu/Documents/MATLAB/GBip/gbip_fsROI_to_fMRI_1.sh /Users/longxiangyu/Documents/ResearchData/Ndn/temp/ C0003 /Users/longxiangyu/Documents/ResearchData/Ndn/temp/ /Users/longxiangyu/Documents/ResearchData/Ndn/rest/

mkdir /${output_directory}/${subjectID}_fsROIs/

cd /${output_directory}/${subjectID}_fsROIs/

mri_convert /${freesurfer_directory}/${subjectID}/mri/brain.mgz brain.nii

mri_convert /${freesurfer_directory}/${subjectID}/mri/aseg.mgz aseg.nii

cp /${fMRI_directory}/${subjectID}/func/reg/standard.nii.gz standard.nii.gz

flirt -ref standard -in brain.nii -out fsbrain2standard -omat fsbrain2standard.mat -cost corratio -dof 6 -interp trilinear

