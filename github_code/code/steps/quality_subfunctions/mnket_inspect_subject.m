function mnket_inspect_subject( id, options )
%MNKET_INSPECT_SUBJECT Function for taking a closer look at the preprocessing of a single subject
%from the MNKET study. 
%   IN:     id          - subject identifier string, e.g. '0001'
%           options     - the struct that holds all analysis options
%   OUT:    -

if nargin < 1
    options = mnket_set_analysis_options;
end

options.preproc.eyeblinktreatment = 'reject';
details_reject = mnket_subjects(id, options);
trialStats_reject = getfield(load(details_reject.trialstats), 'trialStats');

options.preproc.eyeblinktreatment = 'ssp';
details_ssp = mnket_subjects(id, options);
trialStats_ssp = getfield(load(details_ssp.trialstats), 'trialStats');

cd(details_ssp.preproot);
channels = {'Fz', 'Cz', 'Pz', 'Oz'};

% Effect of high pass filtering; inspect raw channel data
Fbefore = dir('Mspmeeg_*.mat');
Fafter = dir('fMspmeeg_*.mat');
Dbefore = spm_eeg_load(Fbefore.name);
Dafter = spm_eeg_load(Fafter.name);
fhhpf = tnueeg_diagnostics_effects_on_continuous_D(Dbefore, Dafter, channels, 'filtering');

% Effect of low pass filtering; inspect raw channel data
Fbefore = dir('dfMspmeeg_*.mat');
Fafter = dir('fdfMspmeeg_*.mat');
Dbefore = spm_eeg_load(Fbefore.name);
Dafter = spm_eeg_load(Fafter.name);
fhlpf = tnueeg_diagnostics_effects_on_continuous_D(Dbefore, Dafter, channels, 'filtering');

% Trials with eyeblinks (rejected in 'reject', corrected in 'ssp')
trials = trialStats_reject.idxEyeartefacts.tone;
channels = {'Fz', 'VEOG'};
cd(details_ssp.preproot);
F = dir('ebfdfMspmeeg_*.mat');
D = spm_eeg_load(F.name);
fhebt = tnueeg_diagnostics_plot_single_trials(D, channels, trials);

% Effect of EB correction
trials = trials(1:40);
channels = {'Fz', 'Oz', 'HEOG'};
cd(details_ssp.preproot);
Fbefore = dir('ebfdfMspmeeg_*.mat');
Fafter = dir('cebfdfMspmeeg_*.mat');
Dbefore = spm_eeg_load(Fbefore.name);
Dafter = spm_eeg_load(Fafter.name);
fhebc = tnueeg_diagnostics_effect_of_EB_corr(Dbefore, Dafter, channels, trials);

% Bad trials (still artefactual after eyeblink rejection/correction)
channels = {'Fz', 'VEOG', 'HEOG'};

cd(details_ssp.preproot);
D = spm_eeg_load(details_ssp.prepfile);
trials = trialStats_ssp.idxArtefacts;
fhabt_ssp = tnueeg_diagnostics_plot_single_trials(D, channels, trials);
tnueeg_diagnostics_plot_badTrials_badChannels(D, options, 'badt');
tnueeg_diagnostics_plot_badTrials_badChannels(D, options, 'badc');

cd(details_reject.preproot);
D = spm_eeg_load(details_reject.prepfile);
trials = trialStats_reject.idxArtefacts;
fhabt_ssp = tnueeg_diagnostics_plot_single_trials(D, channels, trials);
tnueeg_diagnostics_plot_badTrials_badChannels(D, options, 'badt');
tnueeg_diagnostics_plot_badTrials_badChannels(D, options, 'badc');


end

