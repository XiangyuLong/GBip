function [abcdsheet,nonansheet] = gbip_read_ABCD_txt(inputtxt)
% read text files of the ABCD study and output as a spreadsheet
% nonansheet removes the column which has >80% empty value and the row
% which has at least one empty value

temp = fopen(inputtxt);
C = textscan(temp,'%q');
linenum = size(C{1},1);

ctindex = [];
for i = 1 : 1000
    if isempty(C{1}{i}) == 0 && strcmp(C{1}{i},'collection_title') == 1
        ctindex = [ctindex,i];
    end
end
lineunit = ctindex(1);

abcdsheet = {};
n = 1;

for i = 1 : lineunit: linenum
    k = 1;
    for j = i : i+lineunit-1
        abcdsheet{n,k} = C{1}{j};
        k = k + 1;
    end
    n = n + 1;
end

nonansheet = abcdsheet;
% nonansheet = mrirstv02; % for testing

% remove empty column
emptymat = cellfun(@isempty,nonansheet);
temp = sum(emptymat,1);
emptycolumn = temp>0.8*size(emptymat,1);
nonansheet(:,emptycolumn) = [];    
% remove empty row
emptymat = cellfun(@isempty,nonansheet);
temp = sum(emptymat,2);
emptyrow = temp>0;
nonansheet(emptyrow,:) = []; 

        
        
        
    