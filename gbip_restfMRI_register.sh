#!/usr/bin/env bash

# pre-defined parameters

participantID=$1

datadirectory=$2

standard_brain=$3

CSF_tissueprior=$4

WM_tissueprior=$5

analysisdirectory="${datadirectory}${participantID}"

## Registration to MNI
echo "Start Registration"

cd ${analysisdirectory}/func/

cp ${standard_brain} ./reg/standard.nii.gz

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

flirt -ref standard -in highres -out highres2standard -omat highres2standard.mat -cost corratio -searchcost corratio -dof 12 -interp trilinear

convert_xfm -inverse -omat standard2highres.mat highres2standard.mat

slicer highres2standard standard -s 2 -x 0.35 sla.png -x 0.45 slb.png -x 0.55 slc.png -x 0.65 sld.png -y 0.35 sle.png -y 0.45 slf.png -y 0.55 slg.png -y 0.65 slh.png -z 0.35 sli.png -z 0.45 slj.png -z 0.55 slk.png -z 0.65 sll.png
pngappend sla.png + slb.png + slc.png + sld.png + sle.png + slf.png + slg.png + slh.png + sli.png + slj.png + slk.png + sll.png highres2standard1.png
slicer standard highres2standard -s 2 -x 0.35 sla.png -x 0.45 slb.png -x 0.55 slc.png -x 0.65 sld.png -y 0.35 sle.png -y 0.45 slf.png -y 0.55 slg.png -y 0.65 slh.png -z 0.35 sli.png -z 0.45 slj.png -z 0.55 slk.png -z 0.65 sll.png
pngappend sla.png + slb.png + slc.png + sld.png + sle.png + slf.png + slg.png + slh.png + sli.png + slj.png + slk.png + sll.png highres2standard2.png
pngappend highres2standard1.png - highres2standard2.png highres2standard.png
rm highres2standard2.png
rm highres2standard1.png

convert_xfm -omat example_func2standard.mat -concat highres2standard.mat example_func2highres.mat

flirt -ref standard -in example_func -out example_func2standard -applyxfm -init example_func2standard.mat -interp trilinear

convert_xfm -inverse -omat standard2example_func.mat example_func2standard.mat

slicer example_func2standard standard -s 2 -x 0.35 sla.png -x 0.45 slb.png -x 0.55 slc.png -x 0.65 sld.png -y 0.35 sle.png -y 0.45 slf.png -y 0.55 slg.png -y 0.65 slh.png -z 0.35 sli.png -z 0.45 slj.png -z 0.55 slk.png -z 0.65 sll.png
pngappend sla.png + slb.png + slc.png + sld.png + sle.png + slf.png + slg.png + slh.png + sli.png + slj.png + slk.png + sll.png example_func2standard1.png
slicer standard example_func2standard -s 2 -x 0.35 sla.png -x 0.45 slb.png -x 0.55 slc.png -x 0.65 sld.png -y 0.35 sle.png -y 0.45 slf.png -y 0.55 slg.png -y 0.65 slh.png -z 0.35 sli.png -z 0.45 slj.png -z 0.55 slk.png -z 0.65 sll.png
pngappend sla.png + slb.png + slc.png + sld.png + sle.png + slf.png + slg.png + slh.png + sli.png + slj.png + slk.png + sll.png example_func2standard2.png
pngappend example_func2standard1.png - example_func2standard2.png example_func2standard.png
rm example_func2standard2.png
rm example_func2standard1.png
rm sl*.png

## Creat white matter and csf mask

echo "Start Segmentaion of the T1 image"

cd ${analysisdirectory}/func/segment/

flirt -in segment_prob_0 -ref ../reg/example_func -applyxfm -init ../reg/highres2example_func.mat -out csf2func

flirt -in csf2func -ref ../reg/standard -applyxfm -init ../reg/example_func2standard.mat -out csf2standard

fslmaths csf2standard -mas ${CSF_tissueprior} csf_masked

flirt -in csf_masked -ref ../reg/example_func -applyxfm -init ../reg/standard2example_func.mat -out csf_native

fslmaths csf_native -thr 0.4 -bin csf_bin

fslmaths csf_bin -mas global_mask csf_mask

flirt -in segment_prob_2 -ref ../reg/example_func -applyxfm -init ../reg/highres2example_func.mat -out wm2func

flirt -in wm2func -ref ../reg/standard -applyxfm -init ../reg/example_func2standard.mat -out wm2standard

fslmaths wm2standard -mas ${WM_tissueprior} wm_masked

flirt -in wm_masked -ref ../reg/example_func -applyxfm -init ../reg/standard2example_func.mat -out wm_native

fslmaths wm_native -thr 0.66 -bin wm_bin

fslmaths wm_bin -mas global_mask wm_mask

## Calculating the regressors
echo "Start Calculating the regressors"
cd ${analysisdirectory}/func/

3dmaskave -mask ./segment/csf_mask.nii.gz -quiet rest_dmdt.nii.gz > ./regressors/csf.1D

3dmaskave -mask ./segment/wm_mask.nii.gz -quiet rest_dmdt.nii.gz > ./regressors/wm.1D