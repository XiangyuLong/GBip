function gbip_bct_batch(CMdirectory,Outputfolder,NType,RandNum)
% Running Brain Connectivity Toolbox with batch script, Brain Connectivity Toolbox is required.
% Only for undirected matrix
% example:
% CMdirectory = '/System/Volumes/Data/Users/longxiangyu/Documents/ResearchData/Misc/Test/Mats/';
% Outputfolder = '/System/Volumes/Data/Users/longxiangyu/Documents/ResearchData/Misc/Test/Output/';
% gbip_bct_batch(CMdirectory,Outputfolder,1,100);
% Suggest settings: 
% NType = 1;% 1=Binary, 2=Weighted
% RandNum = 100;
% CMdirectory: the full directory path with only mat-file (CM) stored;
% Outputfolder: A folder with full directory path to store the outputs,
% will be created automatically during processing;
% You could modify CIndex below to change the AAL-assigned modules, at the moment 
% it's using Yeo's 7 networks and 1 deep gray matter network;
% 1: Visual network
% 2: Somatomotor network
% 3: Dorsal Attention network
% 4: Ventral Attention network
% 5: Limbic network
% 6: Fronto Parietal network
% 7: Default Mode network
% 8: Deep gray matter network
CIndex = [2 2 3 3 5 5 6 6 6 ...
        6 6 6 6 6 7 7 2 2 2 2 ...
        5 5 7 7 7 7 5 5 4 4 7 ...
        7 4 4 7 7 7 7 5 5 5 5 1 ...
        1 1 1 1 1 1 1 1 1 1 1 1 1 ...
        2 2 3 3 6 6 4 4 7 7 7 7 2 2 ...
        8 8 8 8 8 8 8 8 2 2 2 2 5 5 7 7 5 5 3 3];
ClustAlgor = 1;% Default for Clustering Coefficient algorithm
AUCInterval = 0;% With just 1 threshold

mkdir(Outputfolder);
cd(Outputfolder);
 % creat A files
allmats = dir([CMdirectory,'/*.mat']);
for i = 1 : length(allmats)
    load([CMdirectory,'/',allmats(i).name]);
    swtich NType
    case 1
        
    assort = assortativity_bin(CM,0);% 0, undirected graph
    bc = betweenness_bin(CM);
    cp = clustering_coef_bu(CM);
    dc = degrees_und(CM);
    dens = density_und(CM);
    eglob = efficiency_bin(CM,0);
    eloc = efficiency_bin(CM,1);
    richclub = rich_club_bu(CM);
    
    case 2
        
end

% Put outputs together in one mat-file for each metric
outputstring = {'SmallWorld','','','','','','','','',''};


for i = 1 : length(outputstring)
    allmat = dir([Outputfolder,'/',outputstring{i},'.mat']);

