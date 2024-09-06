function [fullcon,idlenode] = gbip_graph_fullyconnected(adjmat)

% [fullcon,idlenode] = gbip_graph_fullyconnected(adjmat)
% If fullcon = 1 then the graph is a fully connected graph

graphmat = zeros(size(adjmat));

if numel(num2str(max(max(adjmat)))) > 1
    graphmat(adjmat~=0) = 1;
else
    graphmat = adjmat;
end

G=sparse(graphmat);

[~,C] = conncomp(G);

fullcon = max(C);

if fullcon == 1
    idlenode = [];
else
    summat = sum(adjmat);
    idlenode = find(summat==0);
end
   

function [S,C] = conncomp(G)
  % CONNCOMP Drop in replacement for graphconncomp.m from the bioinformatics
  % toobox. G is an n by n adjacency matrix, then this identifies the S
  % connected components C. This is also an order of magnitude faster.
  % By Alec Jacobson
  % [S,C] = conncomp(G)
  %
  % Inputs:
  %   G  n by n adjacency matrix
  % Outputs:
  %   S  scalar number of connected components
  %   C  
  [p,q,r] = dmperm(G+speye(size(G)));
  S = numel(r)-1;
  C = cumsum(full(sparse(1,r(1:end-1),1,1,size(G,1))));
  C(p) = C;
