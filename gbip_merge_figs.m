function gbip_merge_figs(figname1,figname2,fontsize)

% gbip_merge_figs(figname1,figname2)
% figname has to be ".fig"
fig1 = open(figname1);
fig2 = open(figname2);
 
ax1 = get(fig1, 'Children');
ax2 = get(fig2, 'Children');
 
for i = 1 : numel(ax2) 
   ax2Children = get(ax2(i),'Children');
   copyobj(ax2Children, ax1(i));
end

close(fig2);

fig=gca;
set(gcf,'color','w');
set(fig,'FontSize',fontsize);