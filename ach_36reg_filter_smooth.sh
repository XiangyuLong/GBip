#!/usr/bin/env bash

# pre-defined parameters

participantID=$1

# fwhm_gs=$2

# n_vols=240

# TR=2

analysisdirectory=/Users/longxiangyu/Documents/ResearchData/Achps/rest_t1/${participantID}/

# regression of the 36 regressors and spikes (Satterthwaite et al., 2013)

cd ${analysisdirectory}/func/

3dDetrend -polort 1 -vector ./regressors/all36regsandspikes.1D -prefix rest_s36r.nii.gz rest_dmdt.nii.gz

3dcalc -a rest_s36r.nii.gz -expr 'a+100' -prefix rest_res.nii.gz

# band-pass filtering

3dFourier -lowpass 0.08 -highpass 0.009 -retrend -prefix rest_resf.nii.gz rest_res.nii.gz

# transform to the standard space

flirt -ref ./reg/standard -in rest_resf -out rest_resf2standard -applyisoxfm 3 -init ./reg/example_func2standard.mat -interp trilinear

# unzip
gunzip rest_resf2standard.nii.gz

# smoothing

fslmaths rest_resf2standard.nii -kernel gauss 4/2.3548 -fmean res_fwhm4

gunzip res_fwhm4.nii.gz

rm -f rest_s36r.nii.gz rest_res.nii.gz rest_resf.nii.gz