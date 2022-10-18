function gbip_plot_boxchart()

% gbip_plot_boxchart()

G = [ones(size(pae_external{1}));2*ones(size(pae_external{2}));3*ones(size(pae_external{3}));4*ones(size(pae_external{4}))];
b=boxchart(G,[pae_external{1};pae_external{2};pae_external{3};pae_external{4}],'MarkerStyle','none');
b.BoxFaceColor = [1 0 0];
hold on,plot([mean(pae_external{1}),mean(pae_external{2}),mean(pae_external{3}),mean(pae_external{4})],'-or','Linewidth',5);
hold on,
G = [ones(size(con_external{1}));2*ones(size(con_external{2}));3*ones(size(con_external{3}));4*ones(size(con_external{4}))];
b=boxchart(G,[con_external{1};con_external{2};con_external{3};con_external{4}],'MarkerStyle','none');
b.BoxFaceColor = [0 0 1];
hold on,plot([mean(con_external{1}),mean(con_external{2}),mean(con_external{3}),mean(con_external{4})],'-ob','Linewidth',5);

% box chart plots
b=boxchart([temppaecbcl_b,temppaecbcl_2],'MarkerStyle','none');
b.BoxFaceColor = [1 0 0];
hold on,
b=boxchart([tempconcbcl_b,tempconcbcl_2],'MarkerStyle','none');
b.BoxFaceColor = [0 0 1];
hold on,plot([mean(temppaecbcl_b),mean(temppaecbcl_2)],'-or','Linewidth',5);
hold on,plot([mean(tempconcbcl_b),mean(tempconcbcl_2)],'-ob','Linewidth',5);
legend('PAE','Controls');legend boxoff;
set(gcf,'Color','w');
set(gca,'Fontsize',25);
box off;
ylim([45 65]);% change
xticklabels({'Baseline','2 years follow-up'});
ylabel('ADHD CBCL DSM5 Score');
