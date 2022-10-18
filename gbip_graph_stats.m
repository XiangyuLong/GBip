function graphstas = gbip_graph_stats(graphmetric,grp1id,grp2id,grpcov,pvalue)

% sigmean = gbip_graph_stats(graphmetric,grp1id,grp2id,grpcov)
% graphmetric: a n*90 matrix
% fdr_q set at 0.05
% pvalue is the node wise p value
% group1 > group2, nodes = 3; red color
% group1 < group2, nodes = 2; blue color
% GRETNA is required

tempp = zeros(size(graphmetric,2),1);
graphmetric(isnan(graphmetric))=0;
sigmean = zeros(size(graphmetric,2),1);

if isempty(grpcov) == 0
    for i = 1 : size(graphmetric,2)
        [permmean, P] = gretna_permutation_test(graphmetric(:,i), grp1id, grp2id, 10000, grpcov);
        tempp(i) = P;
        sigmean(i) = permmean.real;
    end
else
    for i = 1 : size(graphmetric,2)
        [permmean, P] = gretna_permutation_test(graphmetric(:,i), grp1id, grp2id, 10000);
        tempp(i) = P;
        sigmean(i) = permmean.real;
    end
end

sigmeana = sigmean;
sigmeana(tempp>=pvalue) = 0;

allnodes = ones(size(sigmeana));
allnodes(sigmeana>0) = 3;
allnodes(sigmeana<0) = 2;

graphstas.not = [allnodes,sigmeana,tempp];

[pID,~] = gretna_FDR(tempp,0.05);

if isempty(pID)
    graphstas.cor = [0,0];
else
    sigmeana = sigmean;
    sigmeana(tempp>pID) = 0;
    
    allnodes = ones(size(sigmeana));
    allnodes(sigmeana>0) = 3;
    allnodes(sigmeana<0) = 2;
    graphstas.cor = [allnodes,sigmeana];
end

if sum(allnodes) == length(allnodes)
    disp('No significant results before FDR correction.');
end