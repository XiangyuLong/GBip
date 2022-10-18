#!/usr/bin/env bash

# pre-defined parameters

participantID=$1

TR=$2

datadirectory=$3

analysisdirectory="${datadirectory}${participantID}"

TRstart=$4

TRend=$5

FDthresh=$6

# T1 image analysis and segmentation
echo "Start T1 image analysis"

cd ${analysisdirectory}/anat/

3drefit -deoblique anat.nii.gz

3dresample -orient RPI -inset anat.nii.gz -prefix anat_RPI.nii.gz

3dSkullStrip -input anat_RPI.nii.gz -o_ply anat_surf.nii.gz

3dcalc -a anat_RPI.nii.gz -b anat_surf.nii.gz -expr 'a*step(b)' -prefix anat_brain.nii.gz

fast -t 1 -g -p -o segment anat_brain.nii.gz

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

## Registration between fMRI and T1 only
echo "Start Registration"

cd ${analysisdirectory}/func/

mkdir reg

cp ../anat/anat_brain.nii.gz ./reg/highres.nii.gz

cp example_func.nii.gz ./reg/

cd ./reg/

flirt -ref highres -in example_func -out example_func2highres -omat example_func2highres.mat -cost corratio -dof 6 -interp trilinear

convert_xfm -inverse -omat highres2example_func.mat example_func2highres.mat

slicer example_func2highres highres -s 2 -x 0.35 sla.png -x 0.45 slb.png -x 0.55 slc.png -x 0.65 sld.png -y 0.35 sle.png -y 0.45 slf.png -y 0.55 slg.png -y 0.65 slh.png -z 0.35 sli.png -z 0.45 slj.png -z 0.55 slk.png -z 0.65 sll.png
pngappend sla.png + slb.png + slc.png + sld.png + sle.png + slf.png + slg.png + slh.png + sli.png + slj.png + slk.png + sll.png example_func2highres1.png
slicer highres example_func2highres -s 2 -x 0.35 sla.png -x 0.45 slb.png -x 0.55 slc.png -x 0.65 sld.png -y 0.35 sle.png -y 0.45 slf.png -y 0.55 slg.png -y 0.65 slh.png -z 0.35 sli.png -z 0.45 slj.png -z 0.55 slk.png -z 0.65 sll.png
pngappend sla.png + slb.png + slc.png + sld.png + sle.png + slf.png + slg.png + slh.png + sli.png + slj.png + slk.png + sll.png example_func2highres2.png
pngappend example_func2highres1.png - example_func2highres2.png example_func2highres.png
rm example_func2highres2.png
rm example_func2highres1.png

## Creat white matter and csf mask

echo "Start Generating of the T1 masks"

mkdir ${analysisdirectory}/func/segment

cd ${analysisdirectory}/anat/

mv segment_prob_* ${analysisdirectory}/func/segment/

cd ${analysisdirectory}/func/

3dcopy rest_global_mask.nii.gz ./segment/global_mask.nii.gz

cd ${analysisdirectory}/func/segment/

flirt -in segment_prob_0 -ref ../reg/example_func -applyxfm -init ../reg/highres2example_func.mat -out csf2func

fslmaths csf2func -thr 0.4 -bin csf_bin

fslmaths csf_bin -mas global_mask csf_mask

flirt -in segment_prob_2 -ref ../reg/example_func -applyxfm -init ../reg/highres2example_func.mat -out wm2func

fslmaths wm2func -thr 0.66 -bin wm_bin

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
