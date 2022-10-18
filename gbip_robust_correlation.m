function [finalr, hboot] = gbip_robust_correlation(dataa,datab,outlieropt,figopt)

% [finalr, hboot] = gbip_robust_correlation(dataa,datab,outlieropt,figopt)
% output r no matter significant or not
% need corr toolbox v2

dataa = double(dataa);
datab = double(datab);

if outlieropt == 0
    [r,~,~,hboot,~] = Pearson(dataa,datab,figopt);
    finalr = r;
else
    outliers = detect_outliers(dataa,datab,0,'MAD');
    uninum = length(find(outliers.univariate.MAD>0));
    binum = length(find(outliers.bivariate.MAD>0));
    
    if binum == 0
        numofout = uninum;
    else
        numofout = binum;
    end
    
    if uninum+binum == 0
        [r,~,~,hboot,~] = Pearson(dataa,datab,figopt);
        finalr = r;
    end
    
    if uninum >0 && binum == 0
        [r,~,~,hboot,~,~,~] = bendcorr(dataa,datab,figopt);
        finalr = r;
    end
    
    if binum > 0
        [r,~,~,~,hboot,~]=skipped_correlation(dataa,datab,figopt);
        finalr = r.Pearson;
    end
end