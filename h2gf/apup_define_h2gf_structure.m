function [pars_controls] = apup_define_h2gf_structure(numSubjects)

pars_controls = struct();
%% 
% We set some parameters explicitly:
% 
% Number of samples stored.

pars_controls.niter = 100;
%% 
% Number of samples in the burn-in phase.

pars_controls.nburnin = 100;
%% 
% Number of samples used for diagnostics. During burn-in the parameters 
% of the algorithm are adjusted to increase efficiency. This happens after every 
% diagnostic cycle, whose length is defined here.

pars_controls.ndiag = 50;
%% 
% Set up the so called temperature schedule. This is used to compute the 
% model evidence. It is a matrix of dimension NxM, where N is the number of subjects 
% and M is the number of chains used to compute the model evidence. The temperature 
% schedule is selected using a 5th order power rule. 

pars_controls.T = ones(numSubjects, 1) * linspace(0.01, 1, 8).^5;
%% 
% How often a 'swap' step is performed.

pars_controls.mc3it = 0;
%% 
% Parameters not explicitly defined here take the default values set in 
% tapas_h2gf_inference.m.
% 
% Before proceeding, we declutter the workspace.

clear numSubjects

end