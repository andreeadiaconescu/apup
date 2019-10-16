function loop_analyze_subject_local(options)
% Loops over subjects in APUP study with a local loop and executes all analysis steps %%
%
% USAGE
%        [errorIds, errorSubjects, errorFile] = loop_analyze_subject_local(options);
%
% IN
%   options         (subject-independent) analysis pipeline options,
%                   retrieve via options = apup_options
%
errorSubjects = {};
errorIds = {};

options.subjectIDs = [options.controls ...
    options.patients];
for idCell = options.subjectIDs
    id = char(idCell);
    try
        apup_analyze_subject(id,options);
    catch err
        errorSubjects{end+1,1}.id = id;
        errorSubjects{end}.error = err;
        errorIds{end+1} = id;
    end
end
end
