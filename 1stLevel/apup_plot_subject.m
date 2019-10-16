function apup_plot_subject(id, options)
details = apup_subject_details(id, options);

diagnostics = false;

% pairs of perceptual and response model
[iCombPercResp] = apup_get_model_space;
nModels = size(iCombPercResp,1);


for iModel=1:nModels
    
    iPerceptualModel = iCombPercResp(iModel,1);
    iResponseModel = iCombPercResp(iModel,2);
    load(fullfile(details.behav.pathResults,[details.dirSubject, details.suffix,...
        options.model.perceptualModels{iPerceptualModel}, ...
        options.model.responseModels{iResponseModel},'.mat']), 'est_apup','-mat');
    
    switch iPerceptualModel
        case 1
            tapas_rw_binary_plotTraj(est_apup)
        case {2,3,4}
            tapas_hgf_binary_v1_plotTraj(est_apup);
    end
    
    if diagnostics == true
        tapas_fit_plotCorr(est_apup);
    end
    
end
end