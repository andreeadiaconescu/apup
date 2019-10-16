function details = apup_subject_details(id,options)

details = [];

details.dirSubject            = sprintf('S_%04d', str2num(id));
details.subjectdataroot       = fullfile(options.dataroot);
details.subjectresultsroot    = fullfile(options.resultroot, details.dirSubject);
details.behav.pathResults     = fullfile(details.subjectresultsroot, 'behav');

% Create subjects results directory for current preprocessing strategy
[~,~] = mkdir(details.subjectresultsroot);
[~,~] = mkdir(details.behav.pathResults);

% Tasks
if ismember(id, options.controls)
    details.suffix = 'C';
elseif ismember(id, options.patients)
    details.suffix ='P';   
end

% File names
details.task.file     = fullfile(details.subjectdataroot,[details.dirSubject, ...
    details.suffix, '_est_hgf_binary_ar1_allfree_raisedm3_config_tapas_softmax_binary_vol_config_phifixed','.mat']);

end