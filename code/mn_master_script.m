
% --- Analysis script for MnketAnalysis EEG dataset --- %
% Adapted from mnketAnalysis repo by Dr. Lilian A. Weber and Dr. Andreea O. Diaconescu
% Author: Gabrielle Allohverdi

% % set up Matlab environment
% mnket_setup_paths;

% set all analysis options and provide the path to the data
options = mn_set_analysis_options;

% create the folder structure needed for the full analysis, and fill with necessary raw data
mnket_setup_analysis_folder(options);

% run the full first-level analysis
% includes: data preparation, EEG preprocessing, ERPs, conversion to images, 1st level statistics
loop_mnket_subject_analysis(options); 

% summarize quality of preprocessing and trial statistics
loop_mnket_quality_check(options);

% run second level steps for model-based analysis and report the results
mnket_2ndlevel_modelbased;
mnket_results_report_modelbased;

% Collect all results reported in the paper into a separate folder
mnket_pull_paper_data(options);

% Run second level seps for erp-based analysis and report the results:
mnket_2ndlevel_erpbased;
mnket_results_report_erpbased;

% ANOVA/ANCOVA Factorial analysis
mn_2ndlevel_singletrial_groupxcond('precision', options);
mn_2ndlevel_singletrial_groupxcond_ANCOVA('precision', options)
%mn_2ndlevel_singletrial_groupxcond_DI('epsilon',options);

% DCM analysis (not needed for paper)
mn_dcm_gather_parameters(options);
mn_dcm_stats_report;

% Plot covariates against 1st level sensor betas
mn_plot_covar_vs_sensor_betas(peakCoord, 'pihat3', 'precision', covariate, options); % Peak coord should be in rounded voxel space

% Plot SPM contrast with new topomap style
contrast_idx = 22;
regressor = 'epsilon3';
mnCHR_plot_blobs(contrast_idx, regressor, options);



