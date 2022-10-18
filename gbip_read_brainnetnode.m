function [sphere, label] = gbip_read_brainnetnode(filename)

% read the node file of BrainNet Viewer
% adapted from BrainNet Viewer toolbox

fid = fopen(filename);
data = textscan(fid,'%f %f %f %f %f %s','CommentStyle','#');
fclose(fid);
sphere = [cell2mat(data(1)) cell2mat(data(2)) cell2mat(data(3)) cell2mat(data(4)) cell2mat(data(5))];
label = data{6};