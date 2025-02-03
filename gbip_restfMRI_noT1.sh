#!/usr/bin/env bash

# pre-defined parameters

participantID=$1

TR=$2

datadirectory=$3

analysisdirectory="${datadirectory}${participantID}"

TRstart=$4

TRend=$5

FDthresh=$6

FWHM=$7

# fMRI image analysis
echo "Start fMRI image analysis"

cd ${analysisdirectory}/func/

3dcalc -a rest.nii.gz[${TRstart}..${TRend}] -expr 'a' -prefix rest_a.nii.gz

3drefit -deoblique rest_a.nii.gz

3dresample -orient RPI -inset rest_a.nii.gz -prefix rest_ro.nii.gz

# slice timing
slicetimer -i rest_ro.nii.gz -o rest_st.nii.gz -r ${TR} --ocustom=${datadirectory}/../sliceorder.txt

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

# Calculating the FD and DVARS

# FD > $9
fsl_motion_outliers -i rest_st.nii.gz -o rest_fd_matrix.txt --fd --thresh=${FDthresh} -v > fd_thresh.txt

3dBandpass -quiet -prefix rest_resf.nii.gz 0.009 0.08 rest_dmdt.nii.gz

fslmaths rest_resf.nii.gz -kernel gauss ${FWHM}/2.3548 -fmean rest_resf_smoothed









