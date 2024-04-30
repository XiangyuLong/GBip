function gbip_plot_matrix_with_numbers(inputmatrix, axislabels,textsize,imagetitle)

% gbip_plot_matrix_with_numbers(inputmatrix, axislabels)
% plot matrix with values on it

imagesc(inputmatrix);
for i = 1 : size(inputmatrix,1)
    hold on;
    line([0,size(inputmatrix,1)+0.5], [i+0.5,i+0.5], 'Color', 'k');
    line([i+0.5,i+0.5], [0,size(inputmatrix,1)+0.5], 'Color', 'k');
end
for i = 1 : size(inputmatrix,1)
    for j = 1 : size(inputmatrix,1)
        if inputmatrix(i,j) ~= 0
            text(i-0.2,j, num2str(inputmatrix(i,j)),'Fontsize',textsize,'FontName','times new roman');
        end
    end
end
set(gca,'TickLength',[0 0]);
set(gca,'XTickLabel',axislabels);
set(gca,'YTickLabel',axislabels);
set(gcf,'Color','w');
set(gca,'Fontsize',textsize,'FontName','times new roman');

title(imagetitle,'Fontsize',textsize*2,'FontName','times new roman');

colormap([1 1 1]);


