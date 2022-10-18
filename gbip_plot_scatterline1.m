function [allr,allh,allci] = gbip_plot_scatterline1(a,b,e,f,g,xl,yl,fontsize)

% [allr,allh,allci] = gbip_scatterline1(a,b,e,f,g)
% e and f are colour name.
% g = 1: plot outliers;
% Robust Correlation Toolbox is required
% only plot Pearson R

a=double(a);
b=double(b);

[ra,~,~,outida,ha,CIa] = skipped_correlation_ach(a,b,0);

allr = ra.Pearson;
allh = ha.Pearson;
allci = CIa.Pearson;

newa = a;
newa(outida{1}(1:end))=[];
newb = b;
newb(outida{1}(1:end))=[];

scatter(newa,newb,100,e,'filled');
h = lsline;
L=[];
L(:,:,1) = [h.XData.' h.YData.'];
grid on;
hold on
plot(L(:,1,1),L(:,2,1),e,'LineWidth',6);
% outliers
if g == 1
    scatter(a(outida{1}),b(outida{1}),100,f,'filled');
end
hold off
fig = gca;set(fig,'FontSize',fontsize);
set(gcf,'color','w');
xlabel(xl);
ylabel(yl);