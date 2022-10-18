function aalcheck = gbip_create_native_aal90(individualfolder,aalfolder,individualFA,FSLFAtemplate,filename)

% aalcheck = gbip_create_native_aal90(individualfolder,aalfolder,individualFA,FSLFAtemplate,filename)
% aalcheck should be 1;
% need AFNI, FSL, NIFTI toolbox.
mkdir(individualfolder);
cd(individualfolder);

unix(['flirt -ref ',individualFA,' -in ',FSLFAtemplate,' -out FSLFAtoIndiFA -omat FSLFAtoIndiFA.mat -cost corratio -dof 12 -interp trilinear']);

for i = 1 : 90
    aalid = ['0',num2str(i)];
    aalid = aalid(end-1:end);
    unix(['flirt -ref ',individualFA,' -in ',aalfolder,'/AAL_',aalid,'.nii -out aal_',aalid,'_a -applyxfm -init FSLFAtoIndiFA.mat -interp trilinear']);
    unix(['3dcalc -a aal_',aalid,'_a.nii.gz -expr "astep(a,0.7)" -prefix aal_',num2str(i),'_aa.nii']);
end

a = load_nii('aal_1_aa.nii');
b = zeros(size(a.img));
c = zeros(size(a.img));
for i = 1 : 90
    d = load_nii(['aal_',num2str(i),'_aa.nii']);
    b = b + d.img*i;
    c = c + d.img;
end
aalcheck = max(max(max(c)));

if aalcheck > 1
    b(c>1) = 0;
    a.img = b;
    save_nii(a,filename);
else
    a.img = b;
    save_nii(a,filename);
end