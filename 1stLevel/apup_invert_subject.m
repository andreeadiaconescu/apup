function apup_invert_subject(id, options)
% IN
%   id          subject id string, only number (e.g. '0002')
%   options     general analysis options%
%               options = apup_options;


details = apup_subject_details(id, options);

% pairs of perceptual and response model
[iCombPercResp] = apup_get_model_space;

nModels = size(iCombPercResp,1);

for iModel=1:nModels
    subjectData      = load(details.task.file);
    iPerceptualModel = iCombPercResp(iModel,1);
    iResponseModel = iCombPercResp(iModel,2);
    
    responses = subjectData.est.y;
    inputs    = subjectData.est.u;
    
    est_apup=tapas_fitModel(responses,inputs,options.model.perceptualModels{iPerceptualModel},...
        options.model.responseModels{iResponseModel});
    save(fullfile(details.behav.pathResults,[details.dirSubject, details.suffix, options.model.perceptualModels{iPerceptualModel}, ...
        options.model.responseModels{iResponseModel},'.mat']), 'est_apup','-mat');
end
end

