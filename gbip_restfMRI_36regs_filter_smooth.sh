#!/usr/bin/env bash

# pre-defined parameters

participantID=$1
FWHM=$2
datadirectory=$3
analysisdirectory="${datadirectory}${participantID}/"

# regression of the 36 regressors and spikes (Satterthwaite et al., 2013)

cd ${analysisdirectory}/func/

3dDetrend -polort 1 -vector ./regressors/36regsandspikes.1D -prefix rest_s36r.nii.gz rest_dmdt.nii.gz

3dcalc -a rest_s36r.nii.gz -expr 'a+100' -prefix rest_res.nii.gz

# band-pass filtering

3dBandpass -nodetrend -quiet -prefix rest_resf.nii.gz 0.009 0.08 rest_res.nii.gz

# transform to the standard space

flirt -ref ./reg/standard -in rest_resf -out rest_resf2standard36 -applyisoxfm 3 -init ./reg/example_func2standard.mat -interp trilinear

# smoothing

fslmaths rest_resf2standard36.nii.gz -kernel gauss ${FWHM}/2.3548 -fmean rest_resf2standard36_smoothed

# unzip
gunzip rest_resf2standard36_smoothed.nii.gz
gunzip rest_resf2standard36.nii.gz
