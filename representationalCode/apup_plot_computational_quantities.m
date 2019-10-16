function apup_plot_computational_quantities(options,comparisonType)


if nargin < 2
    comparisonType = 'all';
end

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

% variables needed for plotting
nSubjects                  = size(subjects,2);
nTrials                    = 160;
tWindow                    = 1:nTrials;
colourBlobArray = {'r','g','b','c'};
yLabelArray     = {'\mu_1', '\mu_3','\epsilon_2','\epsilon_3'};
yLimitArray     = {[0 1], [0 3.2], [-0.2 3], [-1 10]};

apup_computational_quantities = {nSubjects};

for iSubject = 1:nSubjects
    id       = char(subjects(iSubject));
    details  = apup_subject_details(id, options);
    apup = load(fullfile(details.behav.pathResults,[details.dirSubject,...
        details.suffix,options.model.perceptualModels{iCombPercResp(6,1)}...
        options.model.responseModels{iCombPercResp(6,2)},'.mat']));     % Select the winning model only;
    [computational_quantities,~]    = apup_extract_computational_quantities(apup,options);
    apup_computational_quantities{iSubject}         = computational_quantities;
end
apup_computational3d          = reshape(apup_computational_quantities,nSubjects,1);
apup_computational3d          = cell2mat(apup_computational3d);
reshaped_apup_computational3d = reshape(apup_computational3d,nTrials,nSubjects,numel(yLabelArray));
meanComputationalQuantity      = squeeze(mean(reshaped_apup_computational3d, 2));
stdComputationalQuantity       = squeeze(std(reshaped_apup_computational3d,[],2));
errorBar                       = stdComputationalQuantity./sqrt(size(apup_computational_quantities,1));
figure;
%% Plot each computational quantity here
for c = 1:numel(yLabelArray)
    hp = subplot(4,1,c);
    tnueeg_line_with_shaded_errorbar(tWindow, meanComputationalQuantity(:,c), errorBar(:,c), colourBlobArray(:,c),1);
    set(get(hp,'YLabel'),'String',yLabelArray{c},'FontSize',20);
    set(hp,'LineWidth',2,'FontSize',36, 'FontName','Constantia');
    ylim(hp,yLimitArray{c});
end

