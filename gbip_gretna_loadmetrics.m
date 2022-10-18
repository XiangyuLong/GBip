% run('gbip_gretna_loadmetrics');
% load the metrics from Gretna ouput folders
% set metricsdir
% set ifmodule is 0 then no modularity metrics

load([metricsdir,'/SmallWorld/SmallWorld.mat']);
load([metricsdir,'/NodalEfficiency/NodalEfficiency.mat']);
load([metricsdir,'/BetweennessCentrality/BetweennessCentrality.mat']);
load([metricsdir,'/DegreeCentrality/DegreeCentrality.mat']);
load([metricsdir,'/NetworkEfficiency/NetworkEfficiency.mat']);
load([metricsdir,'/NodalClustCoeff/NodalClustCoeff.mat']);
load([metricsdir,'/NodalEfficiency/NodalEfficiency.mat']);
load([metricsdir,'/NodalLocalEfficiency/NodalLocalEfficiency.mat']);
load([metricsdir,'/NodalShortestPath/NodalShortestPath.mat']);

globalmetrics=[];
globalmetrics(:,1) = Cp;
globalmetrics(:,2) = Lp;
globalmetrics(:,3) = Eloc;
globalmetrics(:,4) = Eg;
globalmetrics(:,5) = mean(Bc,2);
globalmetrics(:,6) = mean(Dc,2);
globalmetrics(:,7) = Gamma;
globalmetrics(:,8) = Lambda;
globalmetrics(:,9) = Sigma;

nodalmetrics = [];
nodalmetrics{1} = NCp;
nodalmetrics{2} = NLp;
nodalmetrics{3} = NLe;
nodalmetrics{4} = Ne;
nodalmetrics{5} = Bc;
nodalmetrics{6} = Dc;

if ifmodule ~=0
    load([metricsdir,'/ParticipantCoefficient/ParticipantCoefficient.mat']);
    globalmetrics(:,10) = mean(CustomPc_normalized,2);
    nodalmetrics{7} = CustomPc_normalized;
    nodalmetrics{8} = load([metricsdir,'/ModularInteraction/ModularInteraction.mat']);
    nodalmetricsname={'Cp';'Lp';'Eloc';'Eg';'BC';'DC';'Gamma';'Lambda';'Sigma';'PC'};
else
    nodalmetricsname={'Cp';'Lp';'Eloc';'Eg';'BC';'DC';'Gamma';'Lambda';'Sigma'};
end


