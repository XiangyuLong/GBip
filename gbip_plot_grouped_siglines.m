function gbip_plot_grouped_siglines(barhandle,barunit,index1,index2,allvalues,p)

% gbip_grouped_siglines(barhandle,barunit,index1,index2,valua1,valua2,p)
% plot the significance line with asterisk on the bar figure
% p can be a symbolic value
% adapted from bethel o (2020). Statistical significance line (https://www.mathworks.com/matlabcentral/fileexchange/68314-statistical-significance-line)
% MATLAB Central File Exchange. Retrieved January 7, 2020.

barnum = length(barhandle);
centers = [barunit+barhandle(index1).XOffset;barunit+barhandle(index2).XOffset];

if allvalues(index1) > allvalues(index2)
    lineheights = allvalues(index1)*1.05;
else
    lineheights = allvalues(index2)*1.05;
end

hold on
plot(centers,[lineheights,lineheights],'-k', 'LineWidth',2);

plot([centers(1),centers(1)],[lineheights,lineheights*0.99],'-k', 'LineWidth',2);
plot([centers(2),centers(2)],[lineheights,lineheights*0.99],'-k', 'LineWidth',2);

if p > 0.01
    plot(mean(centers), lineheights*1.02, '*k','MarkerSize',10)
elseif p < 0.05
    plot(mean(centers), lineheights*1.02, '*k','MarkerSize',10)
    plot(mean(centers)*1.05, lineheights*1.02, '*k','MarkerSize',10)
end
        