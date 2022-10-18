function conmat = gbip_readnetcc(filename)

% convert AFNI netcc file to mat file
% conmat = gbip_readnetcc(filename)
% adapted from AFNI group

fid=fopen(filename);
s = textscan(fid, '%s', 'delimiter', '\n');
idx = find(strcmp(s{1}, '# FZ'), 1, 'first');
mat = s{1}((idx+1):end);

conmat = zeros(length(mat),length(mat));
for i = 1 : length(mat)
    a=mat{i};
    B=a';
    C=strsplit(B(:)','Y');
    V=cellfun(@str2num,C,'UniformOutput', false);
    conmat(i,:) = V{:};
end