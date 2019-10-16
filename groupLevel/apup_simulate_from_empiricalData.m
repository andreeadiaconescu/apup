function [variables_all] = apup_simulate_from_empiricalData(options,comparisonType)
%IN
% analysis options
% OUT
% parameters of the winning model and all recovered parameters from
% simulating responses from the parameters of the winning model

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

if options.verbosity > 1
    doDiagnostics = true;
else
    doDiagnostics = false;
end

% pairs of perceptual and response model
[iCombPercResp] = apup_get_model_space;

% parameters and subjects
Parameters                 = options.model.ar1;
nParameters = numel(Parameters');
nSubjects = numel(subjects);
variables_apup = cell(nSubjects, numel(nParameters));
simulated_apup = cell(nSubjects, numel(nParameters));

% % Load seed for reproducible results
rng('shuffle');
% state = rng;
File = fullfile(options.sim.figure, 'RNGState.mat');
%save(File, 'state');
Data  = load(File);
state = Data.state;
rng(state);

for iSubject = 1:nSubjects
    id = char(subjects(iSubject));
    details = apup_subject_details(id, options);
    subjectData      = load(details.task.file);
    
    responses = subjectData.est.y;
    inputs    = subjectData.est.u;
    
    est_apup=tapas_fitModel(responses,inputs,options.model.perceptualModels{iCombPercResp(6,1)},...
        options.model.responseModels{iCombPercResp(6,2)});
    sim = tapas_simModel(est_apup.u,...
        options.model.winningPerceptual,...
        est_apup.p_prc.p,options.model.winningResponse,est_apup.p_obs.p);
    y_responses = sim.y;
    input_u     = sim.u;
    sim_apup = tapas_fitModel(y_responses,input_u,options.model.perceptualModels{iCombPercResp(6,1)},...
        options.model.responseModels{iCombPercResp(6,2)});
    variables_apup{iSubject,1} = est_apup.p_prc.mu_0(3);
    variables_apup{iSubject,2} = est_apup.p_prc.sa_0(3);
    variables_apup{iSubject,3} = est_apup.p_prc.ka(2);
    variables_apup{iSubject,4} = est_apup.p_prc.om(2);
    variables_apup{iSubject,5} = est_apup.p_prc.th;
    variables_apup{iSubject,6} = est_apup.p_prc.m(3);
    variables_apup{iSubject,7} = est_apup.p_obs.be;
    
    simulated_apup{iSubject,1} = sim_apup.p_prc.mu_0(3);
    simulated_apup{iSubject,2} = sim_apup.p_prc.sa_0(3);
    simulated_apup{iSubject,3} = sim_apup.p_prc.ka(2);
    simulated_apup{iSubject,4} = sim_apup.p_prc.om(2);
    simulated_apup{iSubject,5} = sim_apup.p_prc.th;
    simulated_apup{iSubject,6} = sim_apup.p_prc.m(3);
    simulated_apup{iSubject,7} = sim_apup.p_obs.be;
    
    [~,quantities_phases]      = apup_extract_computational_quantities_from_sim(sim_apup,options);
    sim_apup_phases{iSubject}  = quantities_phases;
    
    if doDiagnostics
        % Plot Trajectories
        apup_plot = sim_apup;
        colors    = jet(nSubjects);
        apup_hgf_plot_rainbowsim(iSubject,apup_plot,colors);
    end
    
end

variables_all = [cell2mat(variables_apup) cell2mat(simulated_apup)];

%% Save it
save(fullfile(options.resultroot, [comparisonType '_apup_empirical_simulations.mat']), ...
    'variables_apup', '-mat');
ofile=fullfile(options.resultroot,[comparisonType '_apup_empirical_simulations.xlsx']);

columnNames = [{'subjectIds'}, options.model.ar1, options.model.sgm, {'sim_mu3_0','sim_sa3_0','sim_kappa',...
    'sim_omega', 'sim_theta','sim_m3','sim_beta'}];
t = array2table([subjects' num2cell(variables_all)], ...
    'VariableNames', columnNames);
writetable(t, ofile);

%% Plot it
apup_simulate_from_empiricalDataPlot(options,variables_all);

%% Calculate Phase Interactions
if doDiagnostics
    apup_phase_group_analyses_stats_plot(options,sim_apup_phases)
end

end



