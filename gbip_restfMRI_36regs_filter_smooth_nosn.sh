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

3dFourier -lowpass 0.08 -highpass 0.009 -retrend -prefix rest_resf.nii.gz rest_res.nii.gz

# smoothing

fslmaths rest_resf.nii.gz -kernel gauss ${FWHM}/2.3548 -fmean rest_resf_smoothed

# unzip
gunzip rest_resf_smoothed.nii.gz
