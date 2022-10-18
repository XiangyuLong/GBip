function allstats = gbip_plot_scatterline2(xdata1,xdata2,ydata1,ydata2,colorid1,colorid2,shapeid1,shapeid2,xl,yl,fontsize,shapesize,linesize)

% allstats = gbip_scatterline2(xdata1,xdata2,ydata1,ydata2,colorid1,colorid2,shapeid1,shapeid2,xl,yl,fontsize,shapesize,linesize)

% xdata and ydata are two different datasets
% xl and yl are the labels for the x and y axis
% Robust Correlation Toolbox is required
% allstats:r,p,ci
% Pearson R

a=double(xdata1);
b=double(xdata2);
c=double(ydata1);
d=double(ydata2);

[ra,~,pa,~,cia] = Pearson(a,b,0);
[rb,~,pb,~,cib] = Pearson(c,d,0);

allstats(1,1) = ra;
allstats(2,1) = rb;

allstats(1,2) = pa;
allstats(2,2) = pb;

allstats(1,3:4) = cia;
allstats(2,3:4) = cib;

allstats(3,1) = compare_correlation_coefficients(ra,rb,length(xdata1),length(ydata1));

L=[];
scatter(a,b,shapesize,colorid1);
hh = lsline;
L(:,:,1) = [hh.XData.' hh.YData.'];

scatter(c,d,shapesize,colorid2);
hh = lsline;
L(:,:,2) = [hh.XData.' hh.YData.'];

scatter(a,b,shapesize,colorid1,shapeid1,'filled');
hold on,
grid on;
plot(L(:,1,1),L(:,2,1),'color',colorid1,'LineWidth',linesize);
hold on,
scatter(c,d,shapesize,colorid2,shapeid2,'filled');
plot(L(:,1,2),L(:,2,2),'color',colorid2,'LineWidth',linesize);
hold off,

xlabel(xl);
ylabel(yl);
fig=gca;
set(gcf,'color','w');
set(fig,'FontSize',fontsize);

% code for outliers
% newa = a;
% newa(outida{1}(1:end))=[];
% newb = b;
% newb(outida{1}(1:end))=[];
% 
% newc = c;
% newc(outidb{1}(1:end))=[];
% newd = d;
% newd(outidb{1}(1:end))=[];
% L=[];
% scatter(newa,newb,100,e,'fill');
% h = lsline;
% L(:,:,1) = [h.XData.' h.YData.'];
% 
% scatter(newc,newd,100,f,'fill');
% h = lsline;
% L(:,:,2) = [h.XData.' h.YData.'];
% 
% hold on
% scatter(newa,newb,100,e,'fill');
% grid on;
% plot(L(:,1,1),L(:,2,1),e,'LineWidth',6);
% scatter(newc,newd,100,f,'fill');
% plot(L(:,1,2),L(:,2,2),f,'LineWidth',6);
% % outliers
% scatter(a(outida{1}),b(outida{1}),100,e);
% scatter(c(outidb{1}),d(outidb{1}),100,f);
% hold off

