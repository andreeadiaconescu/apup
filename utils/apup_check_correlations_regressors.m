function apup_check_correlations_regressors(options,comparisonType)
switch comparisonType
    case 'all'
        subjects = [options.controls ...
            options.patients];
    case 'controls'
        subjects = options.controls;
    case 'patients'
        subjects = options.patients;
end

% pairs of perceptual and response model
[iCombPercResp] = apup_get_model_space;

nSubjects = size(subjects,2);

for iSubject = 1:nSubjects
    id = char(subjects(iSubject));
    details = apup_subject_details(id, options);
    apup = load(fullfile(details.behav.pathResults,[details.dirSubject,...
        details.suffix,options.model.perceptualModels{iCombPercResp(6,1)}...
        options.model.responseModels{iCombPercResp(6,2)},'.mat']));
    
    corrMatrix    = apup.est_apup.optim.Corr;
    z_transformed = real(apup_fisherz(reshape(corrMatrix,size(corrMatrix,1)^2,1)));
    averageCorr{iSubject,1}=reshape(z_transformed,size(corrMatrix,1),...
        size(corrMatrix,2));
end
save(fullfile(options.resultroot, 'APUPsubjects_parameter_correlations.mat'), ...
    'averageCorr', '-mat');

averageZCorr = mean(cell2mat(permute(averageCorr,[2 3 1])),3);
averageGroupCorr = apup_ifisherz(reshape(averageZCorr,size(corrMatrix,1)^2,1));
finalCorr = reshape(averageGroupCorr,size(corrMatrix,1),...
    size(corrMatrix,2));
title('Correlation Matrix, averaged over subjects');
maximumCorr = max(max(finalCorr(~isinf(finalCorr))));
fprintf('\n\n----- Maximum correlation is %s -----\n\n', ...
    num2str(maximumCorr));
minimumCorr = min(min(finalCorr(~isinf(finalCorr))));
fprintf('\n\n----- Minimum correlation is %s -----\n\n', ...
    num2str(minimumCorr));
finalCorr(isnan(finalCorr))=1;
if options.verbosity > 1
    figure;imagesc(finalCorr);
    caxis([-1 1]);
    parametersModel = {'\mu_3','\sigma_3','m_3','\kappa','\omega_2','\vartheta','\beta'};
    set(gca,'XTick',1:numel(parametersModel))
    set(gca,'XTickLabel',parametersModel);
    set(gca,'YTick',1:numel(parametersModel))
    set(gca,'YTickLabel',parametersModel);
    colorbar(gca);
end
end