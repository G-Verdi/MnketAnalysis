function [ details, paths ] = mn_subjects( id, options )
%MNKET_SUBJECTS Function that sets all filenames and paths
%   IN:     EITHER (for quering both general and subject-specific paths:
%           id                  - the subject number as a string, e.g. '0001'
%           options (optional)  - the struct that holds all analysis options
%           OR (for only quering general paths & files):
%           options - the struct that holds all analysis options 
%   OUT:    details     - a struct that holds all filenames and paths for
%                       the subject with subject number id
%           paths       - a struct that holds all paths and config files
%                       that are not subject-specific

%-- check input -----------------------------------------------------------------------------------%
if isstruct(id)
    options = id;
    id = 'dummy';
elseif ischar(id) && nargin < 2
    options = mn_set_analysis_options;
end

%-- general paths and files -----------------------------------------------------------------------%
paths.confroot      = fullfile(options.workdir, 'config');
paths.tonesroot     = fullfile(options.workdir, 'tones');
paths.erproot       = fullfile(options.workdir, 'erp');
paths.statroot      = fullfile(options.workdir, 'stats_model');
paths.erpstatroot   = fullfile(options.workdir, 'stats_erp');
paths.dcmroot  =   fullfile(options.workdir, 'dcm', options.condition);
paths.grouproot =  fullfile(options.workdir, 'groupdiff');
paths.qualityroot = fullfile(options.workdir, 'quality');
% config files
paths.paradigm      = fullfile(paths.tonesroot, 'paradigm.mat');
paths.elec          = fullfile(paths.confroot, 'mnket_sensors.sfp');
paths.channeldef    = fullfile(paths.confroot, 'mnket_chandef.mat');
paths.montage       = fullfile(paths.confroot, 'mnket_avref_eog.mat');
paths.trialdef      = fullfile(paths.confroot, ['mnket_trialdef_' options.preproc.trialdef '.mat']);

% erp analysis folders
paths.erpfold       = fullfile(paths.erproot, options.erp.type, options.condition);
paths.erpdiffold    = fullfile(paths.erproot, options.erp.type, 'drugdiff');
paths.erpgafold     = fullfile(paths.erpfold, 'GA');
paths.erpspmfold    = fullfile(paths.erpfold, 'SPM');

% erp analysis files
for iCh = 1: numel(options.erp.channels)
    paths.erpgafiles{iCh} = fullfile(paths.erpgafold,['tnu_ga_' options.condition ...
        '_' options.erp.type '_' options.erp.channels{iCh} '.mat']);
    paths.diffgafiles{iCh} = fullfile(paths.erpdiffold, ['tnu_ga_diffwaves_' options.erp.type ...
        '_' options.erp.channels{iCh} '.mat']);                
end
paths.spmganame     = ['spm_GA_' options.condition '_' options.erp.type '.mat'];  
paths.spmgafile     = fullfile(paths.erpspmfold, paths.spmganame);    
paths.dcmfile   = fullfile(paths.dcmroot, ['dcm_' options.erp.type '.mat']);

% model stats folders
paths.statfold      = fullfile(paths.statroot, options.condition);
paths.statdifffold  = fullfile(paths.statroot, 'drugdiff');

% Groupxcond stats folders
%paths.groupfold = fullfile(paths.grouproot, options.condition);
paths.groupfold = fullfile(paths.grouproot);
% erp stats folders
paths.erpstatfold      = fullfile(paths.erpstatroot, options.erp.type, options.condition);
paths.erpstatdifffold  = fullfile(paths.erpstatroot, options.erp.type, 'drugdiff');

% erp stats files
paths.erpspmfile    = fullfile(paths.erpstatfold, 'SPM.mat');
                    
% logging 2nd level analyses and quality check
paths.logfile       = fullfile(options.workdir, 'secondlevel.log');
paths.qualityroot   = fullfile(options.workdir, 'quality');
paths.qualityfold   = fullfile(paths.qualityroot, options.preproc.eyeblinktreatment, ...
    options.condition);
paths.trialstatstab = fullfile(paths.qualityfold, [options.condition, '_' ...
    options.preproc.eyeblinktreatment, '_table_trial_stats.mat']);
paths.trialstatsfig = fullfile(paths.qualityfold, [options.condition, '_' ...
    options.preproc.eyeblinktreatment, '_overview_trial_stats']);

paths.dcmFigParam = fullfile(paths.dcmroot, ['dcm_BParameters' options.erp.type '.fig']);
paths.dcmPredictedSimulated...
                    = fullfile(paths.dcmroot, ['dcm_PredictedSimulated' options.erp.type '.fig']);
paths.dcmScalpMaps...
                    = fullfile(paths.dcmroot, ['dcm_ScalpMaps' options.erp.type '.fig']);

paths.trialstats_summary_all = fullfile(paths.qualityroot, options.preproc.eyeblinktreatment, ...
    'summary_trial_stats_across_drugs.mat');
% in case we exclude participant 4497: recomputed trial statistics
paths.trialstats_summary_red = fullfile(paths.qualityroot, options.preproc.eyeblinktreatment, ...
    'summary_trial_stats_across_drugs_without_4497.mat');


%-- subject-specific options, paths and files -----------------------------------------------------%
% swap channels F1 and C2: which datasets are affected
switch options.condition
    case 'placebo'
        switch id
            case {'4520', '4534'}
                details.swapchannels = true;
            otherwise
                details.swapchannels = false;
        end
    case 'ketamine'
        switch id
            case {'4422', '4488', '4520'}
                details.swapchannels = true;
            otherwise
                details.swapchannels = false;
        end

    case 'psilocybin'
        switch id
            case {''}
                details.swapchannels = true;
             otherwise
                details.swapchannels = false;
        end
end

        
% EB detection threshold
switch id
    case {'4497', '4447', '4478'}
        details.eyeblinkthreshold = 2;
    case {'4499', '4532'}
        details.eyeblinkthreshold = 5;   
    otherwise
        details.eyeblinkthreshold = options.preproc.eyeblinkthreshold;
end

% index of first event of interest for EB detection
switch options.condition
    case 'placebo'
        switch id
            case {'4447', '4459', '4487', '4494', '4497', '4500', '4532', '4548'}
                details.windowForEyeblinkdetection = 4;
            otherwise
                details.windowForEyeblinkdetection = 3;
        end
    case 'ketamine'
        switch id
            case {'4446', '4459', '4478', '4482', '4487', '4494', '4499', '4507'}
                details.windowForEyeblinkdetection = 4;
            otherwise
                details.windowForEyeblinkdetection = 3;
        end

    case 'psilocybin'
        switch id
            case {''}
                details.windowForEyeblinkdetection = 4;
            otherwise
                details.windowForEyeblinkdetection = 3;
        end

end

% bad channels before EB confound estimation (only needed for SSP eyeblink correction)
switch options.condition
    case 'placebo'
        switch id
            case '4507'
                details.preclean.badchannels = 39; % F2
            otherwise
                details.preclean.badchannels = [];
        end
    case 'ketamine'
        switch id
            case '4422'
                details.preclean.badchannels = [28 59]; % Iz, P6
            case '4494'
                details.preclean.badchannels = 9; % FC5
            otherwise
                details.preclean.badchannels = [];
        end
end
    
% raw file names
switch options.condition
    case 'placebo'
        rawsuffix = '_1_pla';
    case 'ketamine'
        rawsuffix = '_1_ket';
    case 'psilocybin'
        rawsuffix = '_2_psi';
end

% names
details.subjectname  = ['MMN_' id];

details.rawfilename  = [details.subjectname rawsuffix];
details.prepfilename = [details.subjectname '_prep'];
details.erpfilename  = [details.subjectname '_' options.erp.type '_erp'];
details.mergfilename = [details.subjectname '_' options.erp.type '_erp_merged'];

% directories
details.subjectroot = fullfile(options.workdir, 'subjects', options.condition, details.subjectname);

details.rawroot     = fullfile(details.subjectroot, 'eeg');  
details.tonesroot   = fullfile(details.subjectroot, 'tones');  
details.modelroot   = fullfile(details.subjectroot, 'model');
details.preproot    = fullfile(details.subjectroot, 'spm_prep', options.preproc.eyeblinktreatment);
details.statroot    = fullfile(details.subjectroot, 'spm_stats', options.preproc.eyeblinktreatment);
details.erproot     = fullfile(details.subjectroot, 'spm_erp', options.erp.type);
details.dcmroot     = fullfile(details.subjectroot, 'spm_dcm', options.erp.type);

switch options.conversion.mode
     case 'modelbased'
        details.convroot = fullfile(details.preproot, ...
            [options.conversion.convPrefix '_' details.prepfilename '_modelbased']);
    case 'diffWaves'
        details.convroot = fullfile(details.erproot, ...    
            [options.conversion.convPrefix '_diff_' details.erpfilename]);
    case 'ERPs'
        details.convroot = fullfile(details.erproot, ...
            [options.conversion.convPrefix '_' details.erpfilename]);
    case 'mERPs'
        details.convroot = fullfile(details.erproot, ...
            [options.conversion.convPrefix '_' details.mergfilename]);
end

% files
details.logfile     = fullfile(details.subjectroot, [details.subjectname '.log']);
details.tonestxt    = fullfile(paths.tonesroot, 'textfiles', options.condition, ['sub' id '.txt']);
details.tonesfile   = fullfile(details.tonesroot, 'tones.mat');
details.eegtones    = fullfile(details.tonesroot, 'eegtones.mat');
details.simfilepre  = fullfile(details.modelroot, 'sim.mat');
details.simfilepost = fullfile(details.modelroot, 'reg.mat');
details.design      = fullfile(details.modelroot, [options.stats.design '_design.mat']);
details.eegdesign   = fullfile(details.modelroot, ...
                    [options.stats.design '_design_eeg_' options.preproc.eyeblinktreatment '.mat']);

details.rawfile     = fullfile(details.rawroot, [details.rawfilename '.bdf']);
details.rawfile_edf = fullfile(details.rawroot, [details.rawfilename '.edf']);
details.prepfile    = fullfile(details.preproot, [details.prepfilename '.mat']);
details.prepfile_modelbased = fullfile(details.preproot, [details.prepfilename '_modelbased.mat']);
details.ebfile      = fullfile(details.preproot, ['fEBbfdfMspmeeg_' details.rawfilename '.mat']);

details.trialstats  = fullfile(details.preproot, [details.subjectname '_trialStats.mat']);
details.artefacts   = fullfile(details.preproot, [details.subjectname '_nArtefacts.mat']);
details.eyeblinks   = fullfile(details.preproot, [details.subjectname '_nEyeblinks.mat']);

details.redeffile   = fullfile(details.erproot, ['redef_' details.subjectname '.mat']);
details.avgfile     = fullfile(details.erproot, ['avg_' details.subjectname '.mat']);
details.erpfile     = fullfile(details.erproot, [details.erpfilename '.mat']);
details.difffile    = fullfile(details.erproot, ['diff_' details.erpfilename '.mat']);
details.mergfile    = fullfile(details.erproot, [details.mergfilename]);
details.dcmfile     = fullfile(details.dcmroot, ['dcm_' details.erpfilename '.mat']);
details.dcmFigParam = fullfile(details.dcmroot, ['dcm_BParameters' details.erpfilename '.fig']);
details.dcmFigParametersBar...
                    = fullfile(details.dcmroot, ['dcm_BParametersBarGraph' details.erpfilename '.fig']);
details.dcmPredictedSimulated...
                    = fullfile(details.dcmroot, ['dcm_PredictedSimulated' details.erpfilename '.fig']);
details.dcmScalpMaps...
                    = fullfile(details.dcmroot, ['dcm_ScalpMaps' details.erpfilename '.fig']);

% conditions
switch options.conversion.mode
    case 'modelbased'
        details.convCon{1} = 'tone';
    case 'diffWaves' 
        details.convCon{1} = 'mmn';
    case 'ERPs'
        details.convCon{1} = 'standard';
        details.convCon{2} = 'deviant';
    case 'mERPs'
        details.convCon{1} = 'deviantplacebo';
        details.convCon{2} = 'standardplacebo';
        details.convCon{3} = 'deviantketamine';
        details.convCon{4} = 'standardketamine';
        details.convCon{5} = 'deviantpsilocybin';
        details.convCon{6} = 'standardpsilocybin';
end

for i = 1: length(details.convCon)
    details.convfile{i} = fullfile(details.convroot, ['condition_' details.convCon{i} '.nii,']);
    details.smoofile{i} = fullfile(details.convroot, ['smoothed_condition_' details.convCon{i} '.nii,']);
end

details.spmfile = fullfile(details.statroot, 'SPM.mat');

details.eeg.firstLevel.sensor.pathStats = details.smoofile ;


% fiducials
details.fid.labels  = {'NAS'; 'LPA'; 'RPA'};
details.fid.data    = [1, 85, -41; -83, -20, -65; 83, -20, -65];

% figures
details.ebdetectfig     = fullfile(details.preproot, [details.subjectname '_eyeblinkDetection.fig']);
details.ebspatialfig    = fullfile(details.preproot, [details.subjectname '_eyeblinkConfounds.fig']);
% only needed for EB rejection:
details.eboverlapfig      = fullfile(details.preproot, [details.subjectname '_eyeblinkTrialOverlap.fig']);
% only needed for EB correction:
details.ebcorrectfig    = fullfile(details.preproot, [details.subjectname '_eyeblinkCorrection.fig']);
details.coregdatafig    = fullfile(details.preproot, [details.subjectname '_coregistration_data.fig']);
details.coregmeshfig    = fullfile(details.preproot, [details.subjectname '_coregistration_mesh.fig']);

details.regressorplots  = fullfile(details.modelroot, [details.subjectname '_' ...
    options.preproc.eyeblinktreatment '_regressor_check']);
details.lowhighPEfigs   = fullfile(details.modelroot, [details.subjectname '_' ...
    options.preproc.eyeblinktreatment '_lowhighPE_check']);
details.firstlevelmaskfig = fullfile(details.statroot, [details.subjectname '_firstlevelmask.fig']);

details.erpfigure         = fullfile(details.erproot, [details.subjectname '_ERP_' ...
    options.erp.electrode '.fig']);

end
