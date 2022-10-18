# pr-process the existed data without spatial normalization
subject_list=data_list_fmri.txt
subjects=$( cat ${subject_list} )
for id in $subjects
do
mkdir newdir/${id}
cd olddir/${id}/func/segment/
fslmaths csf2func -thr 0.4 -bin newdir/${id}/csf_bin
fslmaths newdir/${id}/csf_bin -mas olddir/${id}/global_mask newdir/${id}/csf_mask
fslmaths wm2func -thr 0.66 -bin newdir/${id}/wm_bin
fslmaths newdir/${id}/wm_bin -mas olddir/${id}/global_mask newdir/${id}/wm_mask
cd newdir/${id}/
cp olddir/${id}/regressors/global.1D newdir/${id}/global.1D
3dmaskave -mask csf_mask.nii.gz -quiet olddir/${id}/rest_dmdt.nii.gz > csf.1D
3dmaskave -mask wm_mask.nii.gz -quiet olddir/${id}/rest_dmdt.nii.gz > wm.1D
done

subject_list=data_list_fmri.txt
subjects=$( cat ${subject_list} )
for id in $subjects
do
cd newdir/${id}/
3dDetrend -polort 1 -vector 36regsandspikes.1D -prefix rest_s36r.nii.gz olddir/${id}/rest_dmdt.nii.gz
3dcalc -a rest_s36r.nii.gz -expr 'a+100' -prefix rest_res.nii.gz
3dFourier -lowpass 0.08 -highpass 0.009 -retrend -prefix rest_resf.nii.gz rest_res.nii.gz
fslmaths rest_resf.nii.gz -kernel gauss 4/2.3548 -fmean rest_resf_smoothed
done