function apup_analyze_subject(id, options)

doinvertSubject        = ismember('inversion', options.pipe.executeStepsPerSubject);
doplotTrajectory       = ismember('plotting', options.pipe.executeStepsPerSubject);

% Inverts the model for a given subject
if doinvertSubject
    apup_invert_subject(id, options);
end

% Plots trajectories of a given subject
if doplotTrajectory
    apup_plot_subject(id, options);
end


end
