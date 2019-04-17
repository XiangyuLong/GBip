function [F,p] = gbip_compareLM(mdl1,mdl2)

% [F,p] = ach_compareLM(mdl1,mdl2)
% adapted from: https://stackoverflow.com/questions/33904074/compare-two-linear-regression-models-in-matlab

numerator = (mdl2.SSE-mdl1.SSE)/(mdl1.NumCoefficients-mdl2.NumCoefficients);
denominator = mdl1.SSE/mdl1.DFE;
F = numerator/denominator;
p = 1-fcdf(F,mdl1.NumCoefficients-mdl2.NumCoefficients,mdl1.DFE);