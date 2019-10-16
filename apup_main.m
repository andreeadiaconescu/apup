function apup_main

%% Performs all analysis steps at the single-subject and group level
% Important: you need to have access to the raw data; the path should be specified
% in apup_options();

options = apup_options();

% First-level analysis
fprintf('\n===\n\t Running the first level analysis:\n\n');
loop_analyze_subject_local(options);

fprintf('\n===\n\t Running group-level analysis and printing tables:\n\n');
apup_second_level(options);

fprintf('\n===\n\t Done!\n\n');
end