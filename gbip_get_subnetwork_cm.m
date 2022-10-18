function outputcm = gbip_get_subnetwork_cm(inputcm,subnetwork_index)

% outputcm = gbip_get_subnetwork_cm(inputcm,subnetwork_index)
% inputcm: the 90 X 90 connectivity matrix 
% subnetwork_index: the subnetwork index from Yeo's network.
% Please modify Yeo's network index accordingly if needed.
% Yeo's networks indices:
% 1 Visual 
% 2 Somatomotor 
% 3 Dorsal Attention 
% 4 Ventral Attention 
% 5 Limbic 
% 6 Fronto Parietal 
% 7 Default Mode 
% 8 Deep grey matter

% yeonetworindex = [2	 2	3	3	5	5	6	6	6	6	6	6	6	6	7	...
%     7	2	2	2	2	5	5	7	7	7	7	5	5	4	4	7	7	4	4	7	7	...
%     7	7	5	5	5	5	1	1	1	1	1	1	1	1	1	1	1	1	...
%     1	1	2	2	3	3	6	6	4	4	7	...
%     7	7	7	2	2	8	8	8	8	8	8	8	...
%     8	2	2	2	2	5	5	7	7	5	5	3	3];

% subnetworkind = find(yeonetworindex==subnetwork_index);
outputcm = inputcm(subnetwork_index,subnetwork_index);

