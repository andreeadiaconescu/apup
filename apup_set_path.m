function apup_set_path()
% adds project code path (where this file results) recursively, and adds
% SPM12 path

disp('Using SPM12, r7219');
disp('Using HGF, version 3.0');

restoredefaultpath; % clean up environment
pathCodeProject = fileparts(mfilename('fullpath'));
pathSpm = fullfile(pathCodeProject, 'Toolboxes', 'spm12');
addpath(genpath(pathCodeProject));
rmpath(genpath(pathSpm)); % adding w/o subfolders necessary
addpath(pathSpm);


