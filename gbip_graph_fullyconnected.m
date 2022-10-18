function [fullcon,idlenode] = gbip_graph_fullyconnected(adjmat)

% fullcon = gbip_graph_fullyconnected(adjmat)
% fullcon = 1 then the graph is a fully connected graph

graphmat = zeros(size(adjmat));

if numel(num2str(max(max(adjmat)))) > 1
    graphmat(adjmat~=0) = 1;
else
    graphmat = adjmat;
end

G=sparse(graphmat);

[~,C] = graphconncomp(G);

fullcon = max(C);

if fullcon == 1
    idlenode = [];
else
    summat = sum(adjmat);
    idlenode = find(summat==0);
end
    