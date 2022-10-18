function hm = gbip_restfMRI_create36regs(datadirectory,tr)

% hm = gbip_create36regs(datadirectory,tr);
% if the time length < 4 minutes after scrubbing, hm = 1;

cd(datadirectory);
% a = exist('rest_dvars_matrix.txt');
b = exist('rest_fd_matrix.txt');
% if a == 0 || b == 0
if b == 0
    rest_fd_matrix = [];
else
    load rest_fd_matrix.txt;
end
load csf.1D
NumberofVolumes = length(csf);
% else
    
%     amount = 0;
%    
%     fdmat = dlmread('rest_fd_matrix.txt');
%     dvarsmat = dlmread('rest_dvars_matrix.txt');
%     
%     NumberofVolumes = size(fdmat,1);
%     FD = zeros(NumberofVolumes, 1);
%     DVARS= zeros(NumberofVolumes, 1);
%     
%     % Creating matrix that only includes the combined values from fd and dvars
%     
%     FD = sum(fdmat, 2);
%     DVARS = sum(dvarsmat, 2);
%     
%     combined = (DVARS & FD);
%     amount = sum(combined);% only values in both fd and dvars
%     
%     Overlap_Matrix = zeros(length(combined), amount);
%     f1 = find( combined == 1 );
%     for j=1:length( f1 )
%         Overlap_Matrix( f1(j), j)=1;
%     end
% Creating matrix that includes all values from both fd and dvars
% saving matricies as a text file
% dlmwrite([datadirectory,'/spikemat.txt'],Overlap_Matrix,'delimiter',' ');

% 4 minutes check
nscrub = length(find(rest_fd_matrix==1)) * tr;

if nscrub == 0 || NumberofVolumes*tr - nscrub >= 240
    hm = 0;
else
    if NumberofVolumes*tr - nscrub < 240
        hm = 1;
    end
end

% create 36 regressors (Satterthwaite et al.,2013)

load csf.1D;
g = load('global.1D');
load wm.1D;
wm = wm - mean(wm);% avoid quadratic term self-correlation
csf = csf - mean(csf);
g = g - mean(g);
load rest_mcf.par;
cov=[rest_mcf,wm,csf,g];
tdcov = [zeros(1,size(cov,2));diff(cov)];
allcovs = [cov,tdcov,cov.^2,tdcov.^2,rest_fd_matrix];
save('36regsandspikes.1D','allcovs','-ASCII','-DOUBLE','-TABS');

