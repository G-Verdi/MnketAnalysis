function D = mnket_preprocessing_bergscherg(id, options)
%MNKET_PREPROCESSING_BERGSCHERG Preprocesses one subject from the MNKET study using EB correction as
%suggested by Berg and Scherg. 
%   IN:     id          - subject identifier, e.g '0001'
%           optionally:
%           options     - the struct that holds all analysis options
%   OUT:    D           - preprocessed data set

% general analysis options
if nargin < 2
    options = mnket_set_analysis_options;
end

options.preproc.eyeblinktreatment = 'berg';

% paths and files
[details, paths] = mnket_subjects(id, options);

% record what we're doing
diary(details.logfile);
tnueeg_display_analysis_step_header('preprocessing_bergscherg', 'mnket', id, options.preproc);

% check destination folder
if ~exist(details.preproot, 'dir')
    mkdir(details.preproot);
end
cd(details.preproot);

try
    % check for previous preprocessing
    D = spm_eeg_load(details.prepfile);
    disp(['Subject ' id ' has been preprocessed before.']);
    if options.preproc.overwrite
        clear D;
        disp('Overwriting...');
        error('Continue to preprocessing script');
    else
        disp('Nothing is being done.');
    end
catch
    disp(['Preprocessing subject ' id ' ...']);
    
    %-- preparation -------------------------------------------------------------------------------%
    spm('defaults', 'eeg');
    spm_jobman('initcfg');

    % convert bdf 
    D = tnueeg_convert(details.rawfile);
    fprintf('\nConversion done.\n\n');
    
    % set channel types (EEG, EOG) 
    if ~exist(paths.channeldef, 'file')
        chandef = mnket_channel_definition(paths);
    else
        load(paths.channeldef);
    end
    D = tnueeg_set_channeltypes(D, chandef, options);
    fprintf('\nChanneltypes done.\n\n');

    % do montage (rereference to average reference, and create EOG channels)
    if ~exist(paths.montage, 'file')
        montage = mnket_montage(options);
        save(paths.montage, 'montage');
    else
        load(paths.montage);
    end
    D = tnueeg_do_montage(D, montage, options);
    fprintf('\nMontage done.\n\n');
    
    %-- filtering ---------------------------------------------------------------------------------%
    D = tnueeg_filter(D, 'high', options);
    D = tnueeg_downsample(D, options);
    D = tnueeg_filter(D, 'low', options); 
    fprintf('\nFilters & Downsampling done.\n\n');       
    
    %-- trigger event correction ------------------------------------------------------------------%
    % manage special case of MMN_4458 during ketamine by removing the first trigger event (for
    % details, see readme_special_case2_4458)
    switch id
        case '4458'
            switch options.condition
                case 'ketamine'
                    D = mnket_remove_incorrect_first_trial(D);
            end
    end
    
    %-- eye blink detection -----------------------------------------------------------------------%
    % subject-specific EB detection thresholds (are always applied to both sessions of the same 
    % participant to ensure compatibility).
    switch id
        case '4497'
            options.preproc.eyeblinkthreshold = 2;
        case '4499'
            options.preproc.eyeblinkthreshold = 5;
    end
    [Dm, trialStats.numEyeblinks] = tnueeg_eyeblink_detection_spm(D, options);
    savefig(details.ebdetectfig);
    fprintf('\nEye blink detection done.\n\n');
    
    %-- eye blink epoching and confounds ----------------------------------------------------------%
    Db = tnueeg_epoch_blinks(Dm, options);
    fprintf('\nEpoching to eye blinks done.\n\n');
    Db = tnueeg_get_spatial_confounds(Db, options);
    savefig(details.ebspatialfig);
    fprintf('\nSpatial confounds done.\n\n');
    
    %-- experimental epoching ---------------------------------------------------------------------%
    if ~exist(paths.trialdef, 'file')
        trialdef = mnket_trial_definition(options, paths);
    else
        load(paths.trialdef);
    end
    De = tnueeg_epoch_experimental(Dm, trialdef, options);
    fprintf('\nExperimental epoching done.\n\n');
    
    trialStats.nTrialsInitial = ntrials(De);
    
    %% ADD HEADMODEL HERE
    %-- eye blink correction ----------------------------------------------------------------------%
    De = tnueeg_add_spatial_confounds(De, Db, options);
    Dc = tnueeg_eyeblink_correction_bergscherg(De, options);
    fprintf('\nSimple eye blink correction done.\n\n');
    %%
    
    %-- reject remaining artefacts ----------------------------------------------------------------%
    [D, trialStats.numArtefacts, trialStats.idxArtefacts, trialStats.badChannels] = ...
        tnueeg_artefact_rejection_threshold(Dc, options);
    fprintf('\nArtefact rejection done.\n\n');
    
    %-- finish ------------------------------------------------------------------------------------%
    D = move(D, details.prepfilename);
    trialStats.nTrialsFinal = tnueeg_count_good_trials(D);
    save(details.trialstats, 'trialStats');

    disp('   ');
    disp(['Detected ' num2str(trialStats.numEyeblinks) ' eye blinks for subject ' id]);
    disp(['Rejected ' num2str(trialStats.numArtefacts) ' additional bad trials.']);
    disp(['Marked ' num2str(trialStats.badChannels.numBadChannels) ' channels as bad.']);
    disp([num2str(trialStats.nTrialsFinal.all) ' remaining good trials in D.']);
    fprintf('\nPreprocessing done: subject %s in condition %s.\n', id, options.condition);
    disp('   ');
    disp('*----------------------------------------------------*');
    disp('   ');
    
end

cd(options.workdir);
close all

diary OFF
end
