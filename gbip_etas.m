function etas = gbip_etas(braina,brainb)

% etas = gbip_etas(imagea,imageb);
% Based on Cohen et al., NeuroImage, 2008

braina(isnan(braina)) = 0;
brainb(isnan(brainb)) = 0;
braina = reshape(braina,1,numel(braina));
brainb = reshape(brainb,1,numel(brainb));
nonzn = length(braina);

mbrain = (braina+brainb)/2;
mbrainmean = sum(mbrain)/nonzn;

etaup = sum((braina - mbrain).*(braina - mbrain) + ...
    (brainb - mbrain).*(brainb - mbrain));
etadown = sum((braina - mbrainmean).*(braina - mbrainmean) ...
    + (brainb - mbrainmean).*(brainb - mbrainmean));

etas = 1 - etaup/etadown;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%