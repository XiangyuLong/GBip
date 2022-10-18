function gbip_plot_meanstdbar_grouped(inputdata,colors,fontsize,linesize)

% gbip_meanstdbar_grouped(inputdata,colors,fontsize,linesize)
% the inputdata should be [mean1 mean2 std1 std2]
% each row of the inputdata is one pair of groups
% 

% Example data as before
model_series = inputdata(:,1:end/2);
model_error = inputdata(:,(end/2)+1:end);
b = bar(model_series, 'grouped');
groupnum = size(inputdata,2)/2;
for i = 1 : groupnum
    b(i).FaceColor = colors{i};
end

hold on
% Find the number of groups and the number of bars in each group
ngroups = size(model_series, 1);
nbars = size(model_series, 2);
% Calculate the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
% Set the position of each error bar in the centre of the main bar
% Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
for i = 1:nbars
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, model_series(:,i), model_error(:,i), 'k', 'linestyle', 'none','Linewidth',linesize);
end
hold off;
set(gca,'FontSize',fontsize);