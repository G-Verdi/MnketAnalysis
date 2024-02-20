% --- Analysis script for MMN ketamine EEG dataset --- %

% % set up Matlab environment
% mnket_setup_paths;

% set all analysis options and provide the path to the data
options = mnket_set_analysis_options;

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

% collect all results reported in the paper into a separate folder
mnket_pull_paper_data(options);

% not needed for paper:
mnket_2ndlevel_erpbased;
mnket_results_report_erpbased;

%DCM 
mnket_dcm_gather_parameters(options);
mnket_dcm_stats_report;






