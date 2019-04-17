#!/usr/bin/env bash

individualfolder=$1

individualFA=$2

FSLFAtemplate=$3

aalfolder=$4

filename=$5

# create individual space AAL90 regions
mkdir ${individualfolder}

cd ${individualfolder}

flirt -ref ${individualFA} -in ${FSLFAtemplate} -out FSLFAtoIndiFA -omat FSLFAtoIndiFA.mat -cost corratio -dof 12 -interp trilinear

for aalid in {1..90}
do
	flirt -ref ${individualFA} -in ${aalfolder}/aal_${aalid}.nii -out aal_${aalid}_a -applyxfm -init FSLFAtoIndiFA.mat -interp trilinear
	3dcalc -a aal_${aalid}_a.nii.gz -expr "astep(a,0.7)*${aalid}" -prefix aal_${aalid}_aa.nii
done

3dTcat -prefix allaal.nii aal*aa.nii

3dTstat -sum -prefix tempaal.nii allaal.nii 

3dcalc -a tempaal.nii -expr 'a*1' -datum short -prefix ${filename}.nii

# example:
# /Users/longxiangyu/Documents/MATLAB/GBip/gbip_create_native_aal90.sh /Users/longxiangyu/Documents/ResearchData/Ndn/temp/testaal/test01 /Users/longxiangyu/Documents/ResearchData/Ndn/temp/testaal/123fa.nii /Users/longxiangyu/Documents/Workingmiscs/miscmasks/FMRIB58_FA_1mm.nii.gz /Users/longxiangyu/Documents/Workingmiscs/miscmasks/mnifa_aals_bash test01