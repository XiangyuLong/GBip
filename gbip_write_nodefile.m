function gbip_write_nodefile(excelname,varname,outputname)

% gbip_write_nodefile(excelname,varname,outputname)
% output BrainNet Viewer compatible node file

[~,~,raw] = xlsread(excelname);

if sum(varname(:,2)) == 0
    fprintf('No significant Result \n');
else
    for i = 1 : length(varname)
        raw{i,4} = varname(i,1);
        raw{i,5} = varname(i,2);
    end
    fileID = fopen(outputname,'w');
    formatSpec = '%f %f %f %d %f %s\n';
    for row = 1:length(varname)
        fprintf(fileID,formatSpec,raw{row,:});
    end
    fclose(fileID);
end