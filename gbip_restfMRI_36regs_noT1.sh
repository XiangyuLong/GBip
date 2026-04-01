#!/usr/bin/env bash

# pre-defined parameters

participantID=$1

TR=$2

datadirectory=$3

analysisdirectory="${datadirectory}${participantID}"

standard_brain=$4

CSF_tissueprior=$5

WM_tissueprior=$6

TRstart=$7

TRend=$8

FDthresh=$9

# fMRI image analysis
echo "Start fMRI image analysis"

cd ${analysisdirectory}/func/

3dcalc -a rest.nii.gz[${TRstart}..${TRend}] -expr 'a' -prefix rest_a.nii.gz

3drefit -deoblique rest_a.nii.gz

3dresample -orient RPI -inset rest_a.nii.gz -prefix rest_ro.nii.gz

# slice timing
slicetimer -i rest_ro.nii.gz -o rest_st.nii.gz -r ${TR} --odd

3dcalc -a rest_st.nii.gz[7] -expr 'a' -prefix example_func.nii.gz

# head motion correction
mcflirt -in rest_st.nii.gz -out rest_mcf -mats -plots -reffile example_func -rmsrel -rmsabs -spline_final

fsl_tsplot -i rest_mcf.par -t 'MCFLIRT estimated rotations (radians)' -u 1 --start=1 --finish=3 -a x,y,z -w 640 -h 144 -o rot.png
fsl_tsplot -i rest_mcf.par -t 'MCFLIRT estimated translations (mm)' -u 1 --start=4 --finish=6 -a x,y,z -w 640 -h 144 -o trans.png
fsl_tsplot -i rest_mcf_abs.rms,rest_mcf_rel.rms -t 'MCFLIRT estimated mean displacement (mm)' -u 1 -w 640 -h 144 -a absolute,relative -o disp.png

# Remove skull
3dAutomask -prefix rest_mask.nii.gz -dilate 1 rest_mcf.nii.gz

3dcalc -a rest_mcf.nii.gz -b rest_mask.nii.gz -expr 'a*b' -prefix rest_ss.nii.gz

# Grandmean scaling to 1000
fslmaths rest_ss.nii.gz -ing 1000 rest_gms.nii.gz -odt float

# Create Brain Mask
fslmaths rest_gms.nii.gz -Tmin -bin rest_global_mask.nii.gz -odt char

# Demeaning and Detrending
3dTstat -mean -prefix rest_gms_mean.nii.gz rest_gms.nii.gz

3dDetrend -polort 2 -prefix rest_dt.nii.gz rest_gms.nii.gz

3dcalc -a rest_dt.nii.gz -b rest_gms_mean.nii.gz -expr 'a-b' -prefix rest_dmdt.nii.gz

## Registration to MNI
echo "Start Registration"

cd ${analysisdirectory}/func/

mkdir reg

cp ${standard_brain} ./reg/standard.nii.gz

cp example_func.nii.gz ./reg/

cd ./reg/

flirt -ref standard -in example_func -out example_func2standard -omat example_func2standard.mat -cost corratio -dof 6 -interp trilinear

convert_xfm -inverse -omat standard2example_func.mat example_func2standard.mat

## Creat white matter and csf mask

echo "Start Generating of the T1 masks"

mkdir ${analysisdirectory}/func/segment

cd ${analysisdirectory}/func/

3dcopy rest_global_mask.nii.gz ./segment/global_mask.nii.gz

cd ${analysisdirectory}/func/segment/

flirt -in ${CSF_tissueprior} -ref ../reg/example_func -applyxfm -init ../reg/standard2example_func.mat -out csf2func

flirt -in ${WM_tissueprior} -ref ../reg/example_func -applyxfm -init ../reg/standard2example_func.mat -out wm2func

fslmaths csf2func -thr 0.4 -bin csf_bin

fslmaths wm2func -thr 0.66 -bin wm_bin

fslmaths csf_bin -mas global_mask csf_mask

fslmaths wm_bin -mas global_mask wm_mask

## Calculating the regressors
echo "Start Calculating the regressors"
cd ${analysisdirectory}/func/

mkdir regressors

3dmaskave -mask rest_global_mask.nii.gz -quiet rest_dmdt.nii.gz > ./regressors/global.1D

3dmaskave -mask ./segment/csf_mask.nii.gz -quiet rest_dmdt.nii.gz > ./regressors/csf.1D

3dmaskave -mask ./segment/wm_mask.nii.gz -quiet rest_dmdt.nii.gz > ./regressors/wm.1D

# Calculating the FD and DVARS
cp rest_mcf.par ./regressors/

cd ./regressors/

# FD > $9
fsl_motion_outliers -i ../rest_st.nii.gz -o rest_fd_matrix.txt --fd --thresh=${FDthresh} -v > fd_thresh.txt

# DVARS > default setting

# fsl_motion_outliers -i ../rest_st.nii.gz -o rest_dvars_matrix.txt --dvars -v> dvars_thresh.txt
