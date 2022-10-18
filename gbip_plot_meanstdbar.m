function gbip_plot_meanstdbar(inputdata,colors,fontsize,linesize)

% gbip_meanstdbar(inputdata,colors,fontsize,linesize)
% each row includes mean and std for each data
% colors is a set of colour strings

indexnum = size(inputdata,1);

for i = 1 : indexnum
    hold on;
    bar(i,inputdata(i,1),0.5,colors{i});
    er = errorbar(i,inputdata(i,1),inputdata(i,2),'Linewidth',linesize);
    er.Color = [0 0 0];
end
hold off;
set(gca,'FontSize',fontsize);