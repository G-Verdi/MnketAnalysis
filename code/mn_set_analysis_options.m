function options = mn_set_analysis_options
%MNKET_SET_ANALYSIS_OPTIONS Analysis options function for MNKET project
%   IN:     -
%   OUT:    options     - a struct with all analysis parameters for the
%                       different steps of the analysis.

%-- where to find the data -----------------------------------------------%
[~, uid] = unix('whoami'); 
switch uid(1: end-1)     
    case 'gabriellea'
        options.preprocdir = '/Volumes/T7/Cognemo/MMN/data/prj_roving'; 
        options.maindir = '/Volumes/T7/Cognemo/MMN/data';
    otherwise
        error(['Undefined user. Please specify a user in mn_set_analysis_options ' ...
            'and provide the path to the data']);
end

options.workdir = fullfile(options.preprocdir,'test_mnpsi'); % 'test_mnpsi' 
options.rawdir  = fullfile(options.maindir, 'raw');
options.codedir = '/Users/gabriellea/Documents/MMN_code/Mnket_files_misc/mnketAnalysis';
options.analysis = 'MNPSI';% 'MNKET','MNPSI','group_analysis' 
%% Specify default option functions --------------------------------------%
options.funs.details = @mn_subjects; % Specify paths
options.funs.subjects = @mn_set_subject_groups; % Specify subjects groups 
options.funs.eeg = @mn_prepare_eeg; % Specify eeg options
%% Evaluate option functions
 options= feval(options.funs.subjects, options); % Get subject list
 options= feval(options.funs.eeg, options);

%-- condition info -------------------------------------------------------% 
options.condition   = 'placebo'; % 'placebo', 'ketamine','psilocybin','drugdiff'
options.conditions  = {'placebo','psilocybin'};
%-- preparation ----------------------------------------------------------%
options.prepare.subjectIDs  = options.subjects.all; % data preparation (tone sequences)
options.prepare.overwrite   =1; % whether to overwrite any previous prep
                           
%-- modeling -------------------------------------------------------------%
options.model.subjectIDs    = options.subjects.all; % modeling with the HGF
options.model.overwrite     = 1; % whether to overwrite any previous model

%-- preprocessing --------------------------------------------------------%
options.preproc.subjectIDs      = options.subjects.all;
options.preproc.overwrite       = 1; % whether to overwrite any prev. prepr
options.preproc.keep            = 1;  % whether to keep intermediate data

% swap channel option: this is where we decide what to do about the data sets with apparently
% swapped electrodes C2 and F1 (see readme and swapchannels.pdf for details)
options.preproc.swapchannels    = 'reject'; % 'swap'(swap channels back), 'reject'(mark as bad), 
                                            % '' (do nothing about it)

options.preproc.rereferencing   = 'average';
options.preproc.keepotherchannels = 1;
options.preproc.lowpassfreq     = 30;
options.preproc.highpassfreq    = 0.5; 
options.preproc.downsamplefreq  = 256;

options.preproc.trialdef            = 'tone'; % 'MMN', 'tone' - choose 'tone' for modelbased analysis
options.preproc.epochwin            = [-100 400];
options.preproc.baselinecorrection  = 1;

options.preproc.eyeblinktreatment   = 'reject'; % 'reject', 'ssp'
options.preproc.mrifile             = 'template';
options.preproc.eyeblinkchannels    = {'VEOG'};
options.preproc.windowForEyeblinkdetection = 3; % first event of interest (and optionally last)
% NOTE: This sets the default index of the first even of interest in the EEG file, however, this 
% will be adjusted individually for subjects if their EEG file requires a different value. For all
% adjustments, see mnket_subjects.
options.preproc.eyeblinkthreshold   = 3; % for SD thresholding: in standard deviations, for amp in uV
% NOTE: This sets the default threshold for detecting eye blink events in the EOG, however, this 
% will be adjusted individually for subjects if their EOG requires a different threshold. For all
% adjustments, see mnket_subjects.
options.preproc.eyeconfoundcomps    = 1;
options.preproc.eyeblinkmode        = 'eventbased'; % uses EEG triggers for trial onsets
options.preproc.eyeblinkwindow      = 0.5; % in s around blink events
options.preproc.eyeblinktrialoffset = 0.1; % in s: EBs won't hurt <100ms after tone onset
options.preproc.eyeblinkEOGchannel  = 'VEOG'; % EOG channel (name/idx) to plot
options.preproc.eyebadchanthresh    = 0.4; % prop of bad trials due to EBs
options.preproc.eyecorrectionchans  = {'Fp1', 'Fz', 'AF8', 'T7', 'Oz'};

% in case we use the SSP eye blink correction, this section defines the amount of pre-cleaning
options.preproc.preclean.doFilter           = true;
options.preproc.preclean.lowPassFilterFreq  = 10;
options.preproc.preclean.doBadChannels      = true;
options.preproc.preclean.doRejection        = true;
options.preproc.preclean.badtrialthresh     = 500;
options.preproc.preclean.badchanthresh      = 0.5;
options.preproc.preclean.rejectPrefix       = 'cleaned_';

options.preproc.badchanthresh   = 0.2; % proportion of bad trials
options.preproc.badtrialthresh  = 80; % in microVolt

%-- erp ------------------------------------------------------------------%
options.erp.subjectIDs  = options.subjects.all;                        
options.erp.overwrite   = 1; % whether to overwrite any previous erp

options.erp.type        = 'roving';  % roving (sta=6, dev>=5), mmnad (sta=6, dev=1), 
                            % tone (nothing), memory (t6, t8, t10), 
                            % repetitions (t1, t2, ..., t11)
options.erp.electrode   = 'C1';
options.erp.averaging   = 's'; % s (standard), r (robust)
switch options.erp.averaging
    case 'r'
        options.erp.addfilter = 'f';
    case 's'
        options.erp.addfilter = '';
end
options.erp.percentPE = 20; % for ERP type lowhighPE: how many percent PEs

options.erp.contrastWeighting   = 1;
options.erp.contrastPrefix      = 'diff_';
options.erp.contrastName        = 'mmn';
% these channels are set after inspecting the main results of the modelbased statistics: we plot all
% channels' grand averages + 1.96 * standard error, which lie in the peak of significant clusters of
% 2nd level contrasts
options.erp.channels            = {'C4','C3', 'C1', 'C2','Cz', ...
                                    'FC1', 'FC2', 'FCz', ...
                                    'F1', 'F2', 'Fz', ...
                                    'P7', 'P8', 'P9', 'P10','Pz' ...
                                    'TP7'};

%-- conversion2images ----------------------------------------------------%
options.conversion.subjectIDs   = options.subjects.all;
options.conversion.overwrite    = 1; % whether to overwrite any prev. conv.
options.conversion.mode         = 'diffWaves'; %'ERPs', 'modelbased', 'mERPs', 'diffWaves'
options.conversion.space        = 'sensor';
options.conversion.convPrefix   = 'whole'; 
options.conversion.convTimeWindow = [100 400];
options.conversion.smooKernel   = [16 16 16];

%-- stats ----------------------------------------------------------------%
options.stats.subjectIDs    = options.subjects.all;
options.stats.overwrite     = 1; % whether to overwrite any previous stats
options.stats.mode          = 'diffWaves'; %'ERPs', 'modelbased', 'mERPs', 'diffWaves'
options.stats.design        = 'roving'; % 'epsilon', 'HGF', 'epsilonS', 'plustime', 'prediction', 'precision', 'roving'
switch options.stats.design
    case 'epsilon'
        options.stats.regressors = {'epsi2','epsi3'};
    case 'prediction'
        options.stats.regressors = {'muhat2', 'muhat3','pihat'};
    case 'precision'
        options.stats.regressors = {'pihat1','pihat2','pihat3'};
    case 'HGF'
        options.stats.regressors = {'delta1','sigma2','delta2', 'sigma3'};
    case'roving'
        options.stats.regressors = {'roving'};
  
        
end
options.stats.pValueMode    = 'clusterFWE';
options.stats.exampleID     = '4447';
% optionally, we can manually set the (optimal) color bar limits for scalpmap plotting here.
% currently, these are not used, but instead determined automatically.
%options.stats.placebo.epsi2.clbarlimits = [0 46];
%options.stats.placebo.epsi3.clbarlimits = [0 30];
%options.stats.ketamine.epsi2.clbarlimits = [0 46]; % best for ketamine: 38
%options.stats.ketamine.epsi3.clbarlimits = [0 30];
%options.stats.drugdiff.epsi3.clbarlimits = [-4.5 4.5];

%-- dcm ----------------------------------------------------------------%
options.dcm.subjectIDs = options.subjects;
options.dcm.overwrite  = 0; % whether to overwrite any previous statsDCM.options.analysis = 'ERP'; % analyze evoked responses
options.dcm.model      = 'ERP'; % ERP model
options.dcm.spatial    = 'ECD'; % spatial model
options.dcm.Tdcm(1)    = 1;     % start of peri-stimulus time to be modelled
options.dcm.Tdcm(2)    = 350;   % end of peri-stimulus time to be modelled
options.dcm.Nmodes     = 8;     % nr of modes for data selection
options.dcm.h          = 1;     % nr of DCT components
options.dcm.onset      = 60;    % selection of onset (prior mean)
options.dcm.D          = 1;     % downsampling
options.dcm.Nmax       = 300;   % maximal number of EM iterations
options.dcm.trials     = [2 3]; % index of ERPs within ERP/ERF file: trials with high and low PE, and not other
options.dcm.sources.name ...
                       = {'left A1', 'right A1', 'left STG', 'right STG', 'right IFG', 'left IFG'};
options.dcm.sources.mni=[[-42; -22; 7] [46; -14; 8] [-61; -32; 8] [59; -25; 8] [46; 20; 8] [-46; 20; 8]];
options.dcm.contrast.code...
                       =[-1; 1];
options.dcm.contrast.type...
                        ={'Difference effect'};
                                        
end

