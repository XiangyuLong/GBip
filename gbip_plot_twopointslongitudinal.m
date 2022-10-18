function gbip_plot_twopointslongitudinal(groupeddata1,groupeddata2,color,linewidth)

% gbip_plot_twopointslongitudinal(groupeddata,color,linewidth)
% the grouped data should be a N by 2 vector, each column is the data from 1 time point
% color: color of dots and lines for each group, should be something like {'r','b'}
% linewidth: the line width of the lines connecting the dots, should be a number
% example: gbip_plot_twopointslongitudinal(groupeddata1,groupeddata2,{'r','b'},2);

for i = 1 : size(groupeddata1,1)
    hold on,
    plot([1,2],groupeddata1(i,:),['-o',color{1}],'LineWidth',linewidth,'MarkerFaceColor',color{1});
    plot([1,2],groupeddata2(i,:),['-o',color{2}],'LineWidth',linewidth,'MarkerFaceColor',color{2});
end
xlim([0.5 2.5]);


