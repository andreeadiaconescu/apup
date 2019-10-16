function apup_second_level(options,comparisonType)
%Performs all group-level analysis steps for all subjects of the APUP study
%   IN:     id          subject identifier string, e.g. '151'
%           options     as set by apup_options();

fprintf('\n===\n\t The following pipeline Steps were selected. Please double-check:\n\n');
Analysis_Strategy = options.secondlevel;
disp(Analysis_Strategy);
fprintf('\n\n===\n\n');
pause(2);

if nargin < 2
    comparisonType = 'all';
end


doModelComparison              = Analysis_Strategy(1);
doCheckParameterCorrelations   = Analysis_Strategy(2);
doParameterExtraction          = Analysis_Strategy(3);
doSimulation                   = Analysis_Strategy(4);

% Deletes previous preproc/stats files of analysis specified in options
if doModelComparison
    apup_behav_model_evidence(options,comparisonType);
end
if doParameterExtraction
    apup_extract_parameters_create_table(options,'controls');
    apup_extract_parameters_create_table(options,'patients');
    apup_plot_computational_quantities(options,'controls');
    apup_plot_computational_quantities(options,'patients');
    if options.verbosity > 1
        apup_extract_calculate_MAPs(options,'mu30');
    end
    apup_phase_group_analyses(options);
    apup_extract_calculate_MAPs(options,'m3');
end
if doCheckParameterCorrelations
    apup_check_correlations_regressors(options,comparisonType);
end
if doSimulation
    apup_simulate_from_empiricalData(options);
end
