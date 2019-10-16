function [models_apup] = loadModelEvidence(options,subjects)

perceptual_models = options.model.perceptualModels;
response_models   = options.model.responseModels;

% pairs of perceptual and response model
[iCombPercResp] = apup_get_model_space;

nModels = size(iCombPercResp,1);

nSubjects = numel(subjects);
models_apup = cell(nSubjects, nModels);

for iSubject = 1:nSubjects
    
    id = char(subjects(iSubject));
    details = apup_subject_details(id, options);
    
    % loop over perceptual and response models
    for iModel = 1:nModels
        
        tmp = load(fullfile(details.behav.pathResults,...
            [details.dirSubject,details.suffix,perceptual_models{iCombPercResp(iModel,1)}...
            response_models{iCombPercResp(iModel,2)},'.mat']));
    
        models_apup{iSubject,iModel} = tmp.est_apup.optim.LME;
    end
end
models_apup = cell2mat(models_apup);
end