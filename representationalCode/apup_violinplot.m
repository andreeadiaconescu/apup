function apup_violinplot(Variables,Groups,label)

GroupingVariables = {'Controls','ARMS'};

figure; violinplot(Variables, Groups);

set(gca,'XTickLabel',GroupingVariables);
set(gca,'FontName','Times New Roman','FontSize',40);
ylabel(label);
end

