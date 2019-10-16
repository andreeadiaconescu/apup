function apup_phase_group_analyses(options)


allSubjects      = [options.controls ...
                    options.patients];

subjects = allSubjects;

% pairs of perceptual and response model
[iCombPercResp] = apup_get_model_space;

% variables needed for plotting
nSubjects                  = size(subjects,2);


for iSubject = 1:nSubjects
    id       = char(subjects(iSubject));
    details  = apup_subject_details(id, options);
    apup = load(fullfile(details.behav.pathResults,[details.dirSubject,...
        details.suffix,options.model.perceptualModels{iCombPercResp(6,1)}...
        options.model.responseModels{iCombPercResp(6,2)},'.mat']));     % Select the winning model only;
    [~,quantities_phases]    = apup_extract_computational_quantities(apup,options);
    apup_phases{iSubject}                           = quantities_phases;
end

apup_phase_group_analyses_stats_plot(options,apup_phases);

end

