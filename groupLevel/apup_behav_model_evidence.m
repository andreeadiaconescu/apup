function apup_behav_model_evidence(options,comparisonType)
%IN
% options
% Function saves model selection results

if nargin < 2
    comparisonType = 'all';
end

switch comparisonType
    case 'all'
        subjects = [options.controls ...
            options.patients];
    case 'controls'
        subjects = options.controls;
    case 'patients'
        subjects = options.patients;
end

[models_apup]                                       = loadModelEvidence(options,subjects);
[apup_model_posterior,apup_xp, apup_protected_xp]   = apup_behav_plot_model_selection(options,models_apup);

save(fullfile(options.resultroot ,[comparisonType '_model_selection_results.mat']), ...
    'apup_model_posterior','apup_xp', 'apup_protected_xp', '-mat');
end

