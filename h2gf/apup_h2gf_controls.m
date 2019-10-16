function apup_h2gf_controls(options)
% IN
%   id          subject id string, only number (e.g. '0002')
%   options     general analysis options%
%               options = SIBAK_options;


mode = 'inversion';


hgf_controls = struct('c_prc', [], 'c_obs', []);
%%
% Next, we need to choose a perceptual model and the corresponding reparameteriztion
% function.

hgf_controls.c_prc.prc_fun = @tapas_hgf_binary_basic;
hgf_controls.c_prc.transp_prc_fun = @tapas_hgf_binary_basic_transp;
%%
% Then we do the same for the observation model.

hgf_controls.c_obs.obs_fun = @tapas_softmax_binary;
hgf_controls.c_obs.transp_obs_fun = @tapas_softmax_binary_transp;
% hgf_controls.c_obs.obs_fun = @tapas_unitsq_sgm;
% hgf_controls.c_obs.transp_obs_fun = @tapas_unitsq_sgm_transp;
%%
% Now we run the config function of the perceptual model and copy the priors
% and number of levels of the perceptual model into the hgf structure.

config = tapas_hgf_binary_config();
hgf_controls.c_prc.priormus = config.priormus;
hgf_controls.c_prc.priorsas = config.priorsas;
hgf_controls.c_prc.n_levels = config.n_levels;
clear config
%%
% We set the priors of the observational model directly.

hgf_controls.c_obs.priormus = 0.5;
hgf_controls.c_obs.priorsas = 1;

hgf_controls.empirical_priors = struct('eta', []);
hgf_controls.empirical_priors.eta = 1;

subjects     = options.controls;
nSubjects    = numel(options.controls);

%% Data
% Then we initialize structure arrays for the simulations and for the 'data'
% argument of tapas_h2gf_estimate().

est_apup_controls = struct('u', cell(nSubjects, 1),...
    'ign', [],...
    'c_sim', [],...
    'p_prc', [],...
    'c_prc', [],...
    'traj', [],...
    'p_obs', [],...
    'c_obs', [],...
    'y', cell(nSubjects, 1));

sim_apup_controls = struct('u', [],...
    'ign', [],...
    'c_sim', [],...
    'p_prc', cell(nSubjects, 1),...
    'c_prc', cell(nSubjects, 1),...
    'traj', [],...
    'p_obs', cell(nSubjects, 1),...
    'c_obs', cell(nSubjects, 1),...
    'y', cell(nSubjects, 1));
data = struct('y', cell(nSubjects, 1),...
    'u', [],...
    'ign', [],...
    'irr', cell(nSubjects, 1));

switch mode
    case 'inversion'
        for iSubject = 1:nSubjects
            id = char(subjects{iSubject});
            details = apup_subject_details(id, options);
            load(details.task.file);
            est_apup_controls(iSubject).y = est.y;
            est_apup_controls(iSubject).u = est.u;
            est_apup_controls(iSubject).irr = est.irr;
            data(iSubject).y = est_apup_controls(iSubject).y;
            data(iSubject).u = est_apup_controls(iSubject).u;
            data(iSubject).irr = est_apup_controls(iSubject).irr;
        end
    case 'simulation'
        om2 = [-4.3, -4.2,-4.1, -4.0, ...
            -3.9, -3.8, -3.7, -3.6, ...
            -3.5, -3.4,-3.3, -3.2,...
            -3.1];
        ze = [1.1, 1.2, 1.2, 1.3, 1.3, 1.4, ...
            1.4, 1.5, 1.6, 1.6, 1.7, 1.7, ...
            2.5];
        
        % We randomly permute the elements of $\zeta$ such that there is no systematic
        % association between high values of $\omega_2$ and high values of $\zeta$.
        
        ze = ze(randperm(length(ze)));
       
        for iSubject = 1
            id = char(subjects{iSubject});
            details = apup_subject_details(id, options);
            load(details.task.file);
            est_apup_controls(iSubject).u = est.u;
            data(iSubject).u = est_apup_controls(iSubject).u;
            input_u          = data(iSubject).u;
        end
        for i = 1:nSubjects
            sim = tapas_simModel(input_u,...
                'tapas_hgf_binary_basic', [NaN,...
                1,...
                1,...
                NaN,...
                1,...
                1,...
                NaN,...
                0,...
                0,...
                1,...
                1,...
                NaN,...
                om2(i),...
                -6],...
                'tapas_softmax_binary', ze(i));
            % Simulated responses
            sim_apup_controls(i).y = sim.y;
            sim_apup_controls(i).u = sim.u;
            data(i).y = sim_apup_controls(i).y;
            % Experimental inputs
            data(i).u = input_u;
        end
        
end
clear iSubject u

%% Sampler configuration
% The h2gf uses sampling for inference on parameter values. To configure the
% sampler, we first need to initialize the structure holding the parameters of
% the inference.

% Define structure
[pars_controls] = apup_define_h2gf_structure(nSubjects);

%% Estimation
% Before we can run the estimation, we still need to initialize a structure
% holding the results of the inference.

inference = struct();

%% Finally, we can run the estimation.

h2gf_est_controls = tapas_h2gf_estimate(data, hgf_controls, inference, pars_controls);


save(fullfile(details.behav.pathResults,'h2gf_controls.mat'), 'h2gf_est_controls','-mat');

%%
% We can now look at the belief trajectories of individual subjects. These
% are the trajectories implied by the median posterior parameter values.

tapas_hgf_binary_plotTraj(h2gf_est_controls.summary(1));
end

