function mn_2ndlevel_roving(options)





%% Main
tnueeg_display_analysis_step_header('secondlevel singletrial main', ...
    'mn', 'all', options.eeg.stats.secondlevel);

% results file of first regressor
spmFile = fullfile('/Volumes/T7/Cognemo/MMN/data/prj_roving/test_mnpsi/stats_erp/roving/drugdiff/mmn/twosample',...
    'groupdiff', 'twsample','roving', 'SPM.mat');


% Make sure we have a results directory
    scndlvlroot = fullfile('/Volumes/T7/Cognemo/MMN/data/prj_roving/test_mnpsi/stats_erp/roving/drugdiff/mmn/twosample', 'two sample ttest');
    if ~exist(scndlvlroot, 'dir')
        mkdir(scndlvlroot);
    end
    cd(scndlvlroot);

% collect smoothed beta images
 % smoothed images of averaged ERP data in one condition in each subject
 % serve as input to 2nd level statistics, but here, we only indicate 
 % The subject-specific directories of the images

 nSubjects = numel(options.erp.subjectIDs);
    imagePaths = cell(nSubjects, 1);
    for sub = 1: nSubjects
        subID = char(options.erp.subjectIDs{sub});
        details = mn_subjects(subID, options);
        imagePaths{sub, 1} = details.convroot;
       
    end

mn_roving_twosample_ttest(facdir, scans, factorName)
