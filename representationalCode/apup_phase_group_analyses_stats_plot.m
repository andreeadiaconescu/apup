function apup_phase_group_analyses_stats_plot(options,apup_phases)

nSubjects                  = size([options.controls ...
                    options.patients],2);

nPatients                  = length(options.patients);
nControls                  = length(options.controls);

currentState = 'mu3';
label        = '\mu_3';
selectedColumn = [4:6];

Variables        = cell2mat(reshape(apup_phases,nSubjects,1));
selectedVariablePhases     = {Variables([1:13],selectedColumn(1)), Variables([1:13],selectedColumn(2)),Variables([1:13],selectedColumn(3)),...
    Variables([14:end],selectedColumn(1)), Variables([14:end],selectedColumn(2)),Variables([14:end],selectedColumn(3))};

reshapeVariables = selectedVariablePhases;

% Independent Variables
Groups            = [ones(nControls, 1); 2*ones(nPatients, 1)];
Groups_Conditions = {ones(nControls, 1), 2*ones(nControls, 1), 3*ones(nControls, 1),...
                    4*ones(nPatients, 1),5*ones(nPatients, 1), 6*ones(nPatients, 1)};
% Within-subject Variables
withinSubjectsVariables    = Variables(:,selectedColumn);
betweenSubjectsVariables   = [Groups];

[tblMixedANOVA, rm]          = simple_mixed_anova(withinSubjectsVariables, betweenSubjectsVariables, ...
                                                     {'Phases'},{'Group'});
disp(tblMixedANOVA);

ANOVATable_stableVvolatile   = ranova(rm);
SumSqPh                      = tblMixedANOVA.SumSq(2,:);
SumSqPxG                     = tblMixedANOVA.SumSq(5,:);
SumSqErr                     = tblMixedANOVA.SumSq(6,:);
eta2p.group                  = SumSqPh/(SumSqPh+SumSqErr);
eta2p.phasexgroup            = SumSqPxG/(SumSqPxG+SumSqErr);

disp(ANOVATable_stableVvolatile);
disp(eta2p);
apup_plot_scatter_States(reshapeVariables,Groups_Conditions,currentState,label);

%% Diagnotics
DiffPhase1Phase2              = {(Variables([1:13],selectedColumn(1))-Variables([1:13],selectedColumn(2))), ...
    (Variables([14:end],selectedColumn(1))-Variables([14:end],selectedColumn(2)))};

meanVariablesDiffPhase1Phase2 = [mean(cell2mat(DiffPhase1Phase2(:,1))); mean(cell2mat(DiffPhase1Phase2(:,2)))];

errVariablesDiffPhase1Phase2  = [std(cell2mat(DiffPhase1Phase2(:,1)))/sqrt(13);...
    std(cell2mat(DiffPhase1Phase2(:,2)))/sqrt(13)];

DiffPhase1Phase3              = {(Variables([1:13],selectedColumn(1))-Variables([1:13],selectedColumn(3))), ...
    (Variables([14:end],selectedColumn(1))-Variables([14:end],selectedColumn(3)))};

meanVariablesDiffPhase1Phase3 = [mean(cell2mat(DiffPhase1Phase3(:,1))); mean(cell2mat(DiffPhase1Phase3(:,2)))];

errVariablesDiffPhase1Phase3  = [std(cell2mat(DiffPhase1Phase3(:,1)))/sqrt(13);...
    std(cell2mat(DiffPhase1Phase3(:,2)))/sqrt(13)];


apup_plot_errorbar_MAPs(meanVariablesDiffPhase1Phase2,errVariablesDiffPhase1Phase2,label);
apup_plot_errorbar_MAPs(meanVariablesDiffPhase1Phase3,errVariablesDiffPhase1Phase3,label);

end