# dicom to nifti
subject_list=/Users/longxiangyu/Documents/ResearchData/CR/datalist.txt
subjects=$( cat ${subject_list} )
for id in $subjects
do
mkdir /Users/longxiangyu/Documents/ResearchData/CR/rest/${id}
mkdir /Users/longxiangyu/Documents/ResearchData/CR/rest/${id}/func
mkdir /Users/longxiangyu/Documents/ResearchData/CR/rest/${id}/anat

cd /Users/longxiangyu/Documents/Databak/CR/rest/${id}/study/Ax_FSPGR_BRAVO_08mm/
/Applications/mricron/dcm2nii *.dcm
mv 2* /Users/longxiangyu/Documents/ResearchData/CR/rest/${id}/anat/anat.nii.gz
rm -f /Users/longxiangyu/Documents/Databak/CR/rest/${id}/study/Ax_FSPGR_BRAVO_08mm/*.gz

cd /Users/longxiangyu/Documents/Databak/CR/rest/${id}/study/fMRI_RESTING_STATE_PRE/
/Applications/mricron/dcm2nii -4 -n *.dcm
mv 2* /Users/longxiangyu/Documents/ResearchData/CR/rest/${id}/func/rest.nii.gz
done

# use 36 regressors analysis
subject_list=/Users/longxiangyu/Documents/ResearchData/PreschoolPAE/data_list.txt
subjects=$( cat ${subject_list} )
for subject in $subjects
do
# /Users/longxiangyu/Documents/MATLAB/GBip/gbip_restfMRI_36regs.sh ${subject} 2 /Users/longxiangyu/Documents/ResearchData/PreschoolPAE/rest/ /Users/longxiangyu/Documents/ResearchData/Achps/nihpd_sym_04.5-08.5_nifti/nihpd_sym_04.5-08.5_brain.nii /Users/longxiangyu/Documents/ResearchData/Achps/nihpd_sym_04.5-08.5_nifti/nihpd_sym_04.5-08.5_csf.nii /Users/longxiangyu/Documents/ResearchData/Achps/nihpd_sym_04.5-08.5_nifti/nihpd_sym_04.5-08.5_wm.nii 0 239 0.3
/Users/longxiangyu/Documents/MATLAB/GBip/gbip_restfMRI_36regs_filter_smooth.sh ${subject} 4 /Users/longxiangyu/Documents/ResearchData/PreschoolPAE/rest/
done