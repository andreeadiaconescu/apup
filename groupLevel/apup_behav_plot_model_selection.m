function [model_posterior,xp, protected_xp] = apup_behav_plot_model_selection(options,models)
% Runs and plots model selection results
% IN
%   options     general analysis options%
%               options = SIBAK_options;

% OUT
% Model posterior probabilities & (Protected) exceedance probabilities

[iCombPercResp] = apup_get_model_space;
nModels         = size(iCombPercResp,1);
%% Model Selection
[~,model_posterior,xp,protected_xp,~]=spm_BMS(models);
H=model_posterior;
P = protected_xp;
N=numel(H);
colorsProb=bone(numel(H));
colorsExceedance = bone(numel(P));

% Plot results
figure;
for i=1:N
    h=bar(i,H(i));
    
    if i==1, hold on, end
    set(h,'FaceColor',colorsProb(i,:))
    
end
set(gca,'XTick',1:nModels)
set(gca,'XTickLabel',options.model.labels);
ylabel('p(r|y)');

figure;
for i=1:N
    
    j=bar(i,P(i));
    if i==1, hold on, end
    
    set(j,'FaceColor',colorsExceedance(i,:))
end
set(gca,'XTick',1:nModels)
set(gca,'XTickLabel',options.model.labels);
ylabel('Protected Exceedance Probabilities');
disp(['Best model: ', num2str(find(model_posterior==max(model_posterior)))]);
return
end



