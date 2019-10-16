function apup_invert_subject_h2gf(id, options)
% IN
%   id          subject id string, only number (e.g. '0002')
%   options     general analysis options%
%               options = SIBAK_options;


details = apup_subject_details(id, options);

% pairs of perceptual and response model
iCombPercResp = zeros(3,2);
iCombPercResp(1,1) = 1;
iCombPercResp(2,1) = 2;
iCombPercResp(3,1) = 3;
iCombPercResp(1:3,2) = 1;

nModels = size(iCombPercResp,1);

for iModel=1:nModels
    subjectData      = load(details.task.file);
    iPerceptualModel = iCombPercResp(iModel,1);
    iResponseModel = iCombPercResp(iModel,2);
    est_apup=tapas_fitModel(subjectData.est.y,subjectData.est.u,options.model.perceptualModels{iPerceptualModel},...
        options.model.responseModels{iResponseModel});
    save(fullfile(details.behav.pathResults,[details.dirSubject, options.model.perceptualModels{iPerceptualModel}, ...
        options.model.responseModels{iResponseModel},'.mat']), 'est_apup','-mat');
end
end

