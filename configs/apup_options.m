 function options = apup_options()

options = [];

%% User folders-----------------------------------------------------------%
[~, uid] = unix('whoami');
switch uid(1: end-1)
    case 'drea'
        configroot       = fullfile(fileparts(mfilename('fullpath')), '/Code/', 'Configs');
        simroot          = fullfile(fileparts(mfilename('fullpath')), 'Simulations');
        dataroot         = fullfile('/Users/drea/Documents/Collaborations/Psychosis_fMRI_Paper/Data');
end

options.dataroot                       = dataroot;
options.configroot                     = configroot;
options.resultroot                     = fullfile(fullfile('/Users/drea/Documents/Collaborations/Psychosis_fMRI_Paper/Inversion/'));
options.code                           = fullfile(fileparts(mfilename('fullpath')));
options.task.stable1Trials             = logical(vertcat(ones(45,1), zeros(70+45,1)));
options.task.stable2Trials             = logical(vertcat(zeros(45,1),ones(45,1),zeros(70,1)));
options.task.volatileTrials            = logical(vertcat(zeros(90,1), ones(70,1)));
options.model.pathPerceptual           = fullfile([options.code,'/HGF_RW_AR1']);
options.model.pathResponse             = fullfile([options.code,'/ResponseModels']);
options.verbosity                      = 1;
addpath(genpath(options.code));

% Analysis setting
options.secondlevel = [1 1 1 1];
options.pipe.executeStepsPerSubject = {
    'inversion'};

% Choices:
%     'inversion'
%     'plotting'};

%% Specific to the Model
options.model.labels           = {'M1','M2','M3','M4','M5','M6'};
options.model.perceptualModels = ...
    {'tapas_rw_binary_config','tapas_hgf_binary_v1_novol_config',...
    'tapas_hgf_binary_v1_config','tapas_hgf_binary_ar1_allfree_config',...
    };

options.model.responseModels   = ...
    {'tapas_softmax_binary_config','tapas_softmax_binary_vol_config'};

% Parameters
options.model.ar1      = {'mu3_0','sa3_0','kappa','om','th','m3'};
options.model.hgf      = {'sa3_0','kappa','om','th','be'};
options.model.rw       = {'mu2_0','alpha'};
options.model.hgf2l    = {'om'};
options.model.sgm      = {'beta'};

options.model.winningPerceptual... 
                       = 'tapas_hgf_binary_ar1_allfree';
options.model.winningResponse... 
                       = 'tapas_softmax_binary_vol'; 
options.sim.figure = fullfile(simroot);
%% Subject IDs ------------------------------------------------------------%
% Local function for drug group specific settings
options = subject_details(options);
%% Subjects with specific name rules
    function detailsOut = subject_details(detailsIn)
        
        detailsOut = detailsIn;
        detailsOut.controls=...
            {'2217','2225','2261','2349','2411','2912','3026',...
            '3077','3109','3146','3216','3262',...
            '3460'};
        detailsOut.patients=...
            {'2855','2947','2978',...
            '3031','3040','3232','3327','3357',...
            '3364','3504','3515','4122','3548'};
        % subject 3548: CHR diagnosis was not confirmed at clinical follow up
    end
end


