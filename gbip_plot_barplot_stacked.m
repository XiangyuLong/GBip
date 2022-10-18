function gbip_plot_barplot_stacked(posdata,negdata,colorsid)

% gbip_barplot_stacked(tempdata)
% stacked positive and negative bar plots
% negative data are positive values 
% positive/nagative data: each row;
% colorsid: color for each positive/nagative data

colors = [0 0.4470 0.7410;0.8500 0.3250 0.0980;0.9290 0.6940 0.1250;...
    0.4940 0.1840 0.5560;0.4660 0.6740 0.1880;...
    0.3010, 0.7450, 0.9330;0.6350, 0.0780, 0.1840;0.75, 0, 0.75];

for i = 1 : size(posdata,1)
    tempdata = [posdata(i,:);nan(1,size(posdata,2))];
    b = bar([i,i+1],tempdata,'stacked');
    for j = 1 : size(posdata,2)
        b(j).FaceColor = colors(colorsid(i,j),:);
    end
    hold on,
end

negdata = -1 * negdata;

hold on,
for i = 1 : size(negdata,1)
    tempdata = [negdata(i,:);nan(1,size(negdata,2))];
    b = bar([i,i+1],tempdata,'stacked');
    for j = 1 : size(negdata,2)
        b(j).FaceColor = colors(colorsid(i,j),:);
    end
    hold on,
end
xlim([0 size(negdata,1)+1]);
xticks([1:1:size(negdata,1)]);
