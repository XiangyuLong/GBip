function gbip_plot_siglines(index1,index2,allvalues,p)

% gbip_siglines(index1,index2,allvalues,p)
% plot the significance line with asterisk on the bar figure
% allvalues include the means 
% p can be a symbolic value

centers = [index1;index2];

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
    plot(mean(centers), lineheights*1.05, '*k','MarkerSize',10)
    plot(mean(centers)*1.05, lineheights*1.05, '*k','MarkerSize',10)
end
        
