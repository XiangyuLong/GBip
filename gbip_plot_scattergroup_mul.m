function gbip_plot_scattergroup_mul(inputdata,xindex,singlecolor)

% gbip_scattergroup_mul(inputdata)

xdata1 = ones(size(inputdata));
scatter(xdata1*xindex, inputdata,500,[singlecolor,'.'], 'jitter','on', 'jitterAmount', 0.2);
hold on;
plot([xindex-0.25; xindex + 0.25], repmat(mean(inputdata, 1), 2, 1), 'k-','LineWidth',5);