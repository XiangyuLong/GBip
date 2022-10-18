function gbip_plot_scattergroup(inputdata1,inputdata2,colors)

% gbip_scattergroup(inputdata1,inputdata2,colors)
% inputdata should be a set of data, scatter for mean bar plot
% colors should be something like {'r','b'}

xdata1 = ones(size(inputdata1));
scatter(xdata1, inputdata1,500,[colors{1},'.'], 'jitter','on', 'jitterAmount', 0.2);
hold on;
xdata2 = ones(size(inputdata2));
scatter(xdata2*2, inputdata2,500,[colors{2},'.'], 'jitter','on', 'jitterAmount', 0.2);
plot([1-0.25; 1 + 0.25], repmat(mean(inputdata1, 1), 2, 1), 'k-','LineWidth',5);
plot([2-0.25; 2 + 0.25], repmat(mean(inputdata2, 1), 2, 1), 'k-','LineWidth',5);