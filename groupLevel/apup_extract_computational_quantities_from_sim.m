function [apup_computational_quantities,quantities_phases] = apup_extract_computational_quantities_from_sim(est,options)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Predictions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1st level predictions, precisions
mu1hat               = est.traj.muhat([1:160],1);
mu3hat               = est.traj.muhat([1:160],3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PEs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
epsilon2   = abs(est.traj.sa([1:160],2).*est.traj.da([1:160],1));
epsilon3   = est.traj.sa([1:160],3).*est.traj.da([1:160],2);

mu1hatPhase = [mean(mu1hat(options.task.stable1Trials)) mean(mu1hat(options.task.stable2Trials)),...
    mean(mu1hat(options.task.volatileTrials))];
mu3hatPhase = [mean(mu3hat(options.task.stable1Trials)) mean(mu3hat(options.task.stable2Trials)),...
    mean(mu3hat(options.task.volatileTrials))];
epsilon2Phase = [mean(epsilon2(options.task.stable1Trials)) mean(epsilon2(options.task.stable2Trials)),...
    mean(epsilon2(options.task.volatileTrials))];
epsilon3Phase = [mean(epsilon3(options.task.stable1Trials)) mean(epsilon3(options.task.stable2Trials)),...
    mean(epsilon3(options.task.volatileTrials))];

apup_computational_quantities = [mu1hat, mu3hat epsilon2 epsilon3];
quantities_phases             = [mu1hatPhase mu3hatPhase epsilon2Phase epsilon3Phase];

end