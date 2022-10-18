#!/usr/bin/env bash

# pre-defined parameters

output_directory=$1
subjectID=$2
labelid=$3

# example: 
# /Users/longxiangyu/Documents/MATLAB/GBip/gbip_fsROI_to_fMRI_2.sh /Users/longxiangyu/Documents/ResearchData/Ndn/temp/ C0003 18

# 18 is Left-Amygdala
# label id link: https://surfer.nmr.mgh.harvard.edu/fswiki/FsTutorial/AnatomicalROI/FreeSurferColorLUT

cd /${output_directory}/${subjectID}_fsROIs/

3dcalc -a aseg.nii -expr "within(a,${labelid}-0.5,${labelid}+0.5)" -prefix aseg_${labelid}.nii

flirt -ref standard -in aseg_${labelid}.nii -out temp_${labelid} -applyisoxfm 3 -init fsbrain2standard.mat -interp trilinear

3dcalc -a temp_${labelid}.nii.gz -expr 'astep(a,0.8)' -prefix ${subjectID}_ROI_${labelid}.nii

