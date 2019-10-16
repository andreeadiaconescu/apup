function apup_extract_calculate_MAPs(options,currentVAR)



% variables needed for plotting
nCon                  = length(options.controls);
nPatients             = length(options.patients);


% Dependent Variables
[variables_apup] = apup_extract_parameters_create_table(options,'all');

switch currentVAR
    case 'theta'
        curr_var                = cell2mat(variables_apup(:,4));
        label                   = '\vartheta';
    case 'drift'
        curr_var                = cell2mat(variables_apup(:,6));
        label                   = '\delta{_m}';
    case 'mu30'
        curr_var                = cell2mat(variables_apup(:,1));
        label                   = '\mu{_3}';
    case 'm3'
        curr_var                = cell2mat(variables_apup(:,7));
        label                   = 'm{_3}';
end


Groups            = [ones(nCon, 1); 2*ones(nPatients, 1)];

apup_stats_groups(curr_var,Groups);

selectedVariablePhases     = {curr_var([1:nCon]), curr_var([1+nCon:end])};
Groups_Conditions          = {ones(nCon, 1), 2*ones(nPatients, 1)};

apup_plot_scatter_MAPs(selectedVariablePhases,Groups_Conditions,currentVAR,label)
apup_violinplot(curr_var,Groups,label);