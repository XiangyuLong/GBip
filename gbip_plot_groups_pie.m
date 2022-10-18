function gbip_plot_groups_pie(grouping,fontsize)

% gbip_groups_pie(grouping)
% draw pie figure of the groups from clustering analysis

temp=[];
for i = 1 : max(grouping)
    temp(i) = length(find(grouping==i));
end

h=pie(temp);
set(gcf,'color','w');
set(findobj(h,'type','text'),'fontsize',fontsize);