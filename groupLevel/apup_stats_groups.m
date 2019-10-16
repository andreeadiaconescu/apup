function apup_stats_groups(current_var,Groups)

[p,tbl,stats,terms] = anovan(current_var,Groups,...
    'model','interaction','varnames',{'Group'},'display','off');

ANOVAGroup = tbl; 
disp(ANOVAGroup);

SumSqG                     = ANOVAGroup{2,2};
SumSqErr                   = ANOVAGroup{3,2};
eta2p.group                = SumSqG/(SumSqG+SumSqErr);
disp(eta2p);
end