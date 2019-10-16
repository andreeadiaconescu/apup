function [parameters_sibak] = loadSIBAKMAPs(options,subjects,comparisonType)
%IN
% analysis options
% OUT
% parameters of the winning model
options.subjectIDs = subjects;

if options.model.modelling_bias == true
    % pairs of perceptual and response model
    PerceptualModel_Parameters = options.model.rw;
    ResponseModel_Parameters = options.model.bias;
    
    perceptual_model = options.model.competingPerceptual;
    response_model   = options.model.competingResponse;
else
    % pairs of perceptual and response model
    PerceptualModel_Parameters = options.model.hgf;
    ResponseModel_Parameters = options.model.sgm;
    
    perceptual_model = options.model.winningPerceptual;
    response_model   = options.model.winningResponse;
    
end

nParameters = [PerceptualModel_Parameters';ResponseModel_Parameters'];
nSubjects = numel(options.subjectIDs);
parameters_sibak = cell(nSubjects, numel(nParameters));

if options.model.modelling_bias == true
    
    for iSubject = 1:nSubjects
        id = char(options.subjectIDs(iSubject));
        details = SIBAK_subject_details(id, options);
        tmp = load(fullfile(details.behav.pathResults,...
            [details.dirSubject, perceptual_model...
            response_model,'.mat']));
        parameters_sibak{iSubject,1} = tmp.est_sibak.p_prc.v_0;
        parameters_sibak{iSubject,2} = tmp.est_sibak.p_prc.al;
        parameters_sibak{iSubject,3} = tmp.est_sibak.p_obs.ze1;
        parameters_sibak{iSubject,4} = tmp.est_sibak.p_obs.ze2;
        parameters_sibak{iSubject,5} = tmp.est_sibak.p_obs.nu;
    end
    
    parameters_sibak = cell2mat(parameters_sibak);
    figure; scatter(parameters_sibak(:,2),parameters_sibak(:,3));
    xlabel(['\' options.model.rw{2}]);
    ylabel(['\' options.model.bias{1}]);
    [R,P]=corrcoef(parameters_sibak(:,1),parameters_sibak(:,2));
    disp(['Correlation between al and zeta? Pvalue: ' num2str(P(1,2))]);
    figure; scatter(parameters_sibak(:,3),parameters_sibak(:,5));
    xlabel(['\' options.model.bias{1}]);
    ylabel(['\' options.model.bias{3}]);
    [R,P]=corrcoef(parameters_sibak(:,3),parameters_sibak(:,5));
    disp(['Correlation between zeta and psi? Pvalue: ' num2str(P(1,2))]);
    save(fullfile(options.resultroot, [comparisonType '_MAP_estimates_competing_model.mat']), ...
        'parameters_sibak', '-mat');
    ofile=fullfile(options.resultroot, [comparisonType '_MAP_estimates_competing_model.xlsx']);
    xlswrite(ofile, [str2num(cell2mat(options.subjectIDs')) parameters_sibak]);
    
else
    
    for iSubject = 1:nSubjects
        id = char(options.subjectIDs(iSubject));
        details = SIBAK_subject_details(id, options);
        tmp = load(fullfile(details.behav.pathResults,...
            [details.dirSubject, perceptual_model...
            response_model,'.mat']));
        parameters_sibak{iSubject,1} = tmp.est_sibak.p_prc.mu_0(2);
        parameters_sibak{iSubject,2} = tmp.est_sibak.p_prc.mu_0(3);
        parameters_sibak{iSubject,3} = tmp.est_sibak.p_prc.ka(2);
        parameters_sibak{iSubject,4} = tmp.est_sibak.p_prc.om(2);
        parameters_sibak{iSubject,5} = tmp.est_sibak.p_prc.om(3);
        parameters_sibak{iSubject,6} = tmp.est_sibak.p_obs.ze1;
        parameters_sibak{iSubject,7} = tmp.est_sibak.p_obs.ze2;
        parameters_sibak{iSubject,8} = tmp.est_sibak.cScore;
        parameters_sibak{iSubject,9} = tmp.est_sibak.perf_acc;
        parameters_sibak{iSubject,10}= tmp.est_sibak.take_adv_helpful;
        parameters_sibak{iSubject,11}= tmp.est_sibak.go_against_adv_misleading;
        parameters_sibak{iSubject,12}= tmp.est_sibak.choice_with;
        parameters_sibak{iSubject,13}= tmp.est_sibak.choice_against;
        parameters_sibak{iSubject,14}= tmp.est_sibak.choice_with_chance;
        parameters_sibak{iSubject,15}= tmp.est_sibak.go_with_stable_helpful_advice;
        parameters_sibak{iSubject,16}= tmp.est_sibak.go_with_stable_helpful_advice1;
        parameters_sibak{iSubject,17}= tmp.est_sibak.go_with_stable_helpful_advice2;
        parameters_sibak{iSubject,18}= tmp.est_sibak.choice_against_stable_misleading_advice;
        parameters_sibak{iSubject,19}= tmp.est_sibak.go_with_volatile_advice;
        parameters_sibak{iSubject,20}= tmp.est_sibak.take_adv_overall;
        parameters_sibak{iSubject,21}= tmp.est_sibak.go_against_volatile_advice;
        if options.model.modelling_bias == true
            parameters_sibak{iSubject,22} = tmp.est_sibak.p_obs.nu;
        else
            parameters_sibak{iSubject,22} = [];
        end
    end

    parameters_sibak = cell2mat(parameters_sibak);
    figure; scatter(parameters_sibak(:,1),parameters_sibak(:,2));
    xlabel(['\' options.model.hgf{1}]);
    ylabel(['\' options.model.hgf{2}]);
    [R,P]=corrcoef(parameters_sibak(:,1),parameters_sibak(:,2));
    disp(['Correlation between mu2 and mu3? Pvalue: ' num2str(P(1,2))]);
    figure; scatter3(parameters_sibak(:,3),parameters_sibak(:,4),parameters_sibak(:,5),'filled');
    xlabel(['\' options.model.hgf{3}]);
    ylabel(['\' options.model.hgf{4}]);
    zlabel(['\' options.model.hgf{5}]);
    [R,P]=corrcoef(parameters_sibak(:,3),parameters_sibak(:,4));
    disp(['Correlation between kappa and omega? Pvalue: ' num2str(P(1,2))]);
    save(fullfile(options.resultroot, [comparisonType '_MAP_estimates_winning_model.mat']), ...
        'parameters_sibak', '-mat');
    ofile=fullfile(options.resultroot,[comparisonType '_MAP_estimates_winning_model.xlsx']);
    columnNames = [{'subjectIds'}, options.model.hgf, options.model.sgm, ...
        {'cScore', 'perf_acc', 'take_adv_helpful','go_against_adv_misleading','choice_with',...
        'choice_against','choice_with_chance','go_with_stable_helpful_advice','go_with_stable_helpful_advice1',...
        'go_with_stable_helpful_advice2','choice_against_stable_misleading_advice','go_with_volatile_advice',...
        'take_adv_overall','go_against_volatile_advice'}];
    t = array2table([options.subjectIDs' num2cell(parameters_sibak)], ...
        'VariableNames', columnNames);
    writetable(t, ofile);
end
end


