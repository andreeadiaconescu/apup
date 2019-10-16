function apup_simulate_from_empiricalDataPlot(options,variables_all)

%% Plot slopes
yLabelArray    = {'\mu{_3}','\sigma{_3}','kappa','\omega','\vartheta','m{_3}','\beta'};
colourArray    = {'b', 'k', 'm', 'r', 'c', 'g','k'};
xLimitArray    = {[0.5 3], [0.098 0.1], [0.8 1.6],[-12 -2], [0.2 0.45], [1 3.5],[2 15]};
yLimitArray    = {[0.5 3], [0.098 0.1], [0.8 1.6],[-12 -2], [0.2 0.45], [1 3.5],[2 15]};

parameterArray = [options.model.ar1 options.model.sgm];
nParameters    = size(parameterArray,2);
figure;
for iParameter = 1:nParameters
    subplot(4,2,iParameter);
    X = variables_all(:,iParameter);
    Y = variables_all(:,iParameter + nParameters);
    
    regressionMatrix       = [X ones(size(X))];
    B                      = regressionMatrix\Y; 
    [R,P]                  = corrcoef(X,Y);
    
    
    pValueArray(iParameter)        = P(1,2);
    slopeArray(iParameter)         = R(1,2);
    
    scatter(X, Y, [],'MarkerEdgeColor',[0 .5 .5],...
        'MarkerFaceColor',colourArray{iParameter},...
        'LineWidth',2);
    hold all;
    plot(X, B(1)*X+B(2), '-k');
    title({sprintf('correlation = %.3f, p =%.4f', slopeArray(iParameter), pValueArray(iParameter))});
    xlabel(sprintf('parameter: %s', yLabelArray{iParameter}));
    xlim(xLimitArray{iParameter});
    ylim(yLimitArray{iParameter});
    set(gca,'FontName','Calibri','FontSize',20);
end

titleString = sprintf('%s - Recoverability (Model: %s)', ...
    [options.model.winningPerceptual,options.model.winningResponse]);
% nicer figure name w/o white spaces and minus
figFileString = regexprep(regexprep(...
    regexprep([titleString '.png'], '( |-|:|\(|\))*', '_'), ...
    '(_)+', '_'), '_\.','\.');
saveas(gcf, fullfile(options.sim.figure, ...
    figFileString));

end