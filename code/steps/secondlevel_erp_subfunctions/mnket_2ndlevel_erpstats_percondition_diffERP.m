function mnket_2ndlevel_erpstats_percondition_diffERP(options)
%MNKET_2NDLEVEL_ERPSTATS_PERCONDITION Computes the second level contrast
%images for ERP effects in one condition in the MNKET study.
%   IN:     options - the struct that holds all analysis options
%   OUT:    --

% general analysis options
if nargin < 1
    options = mn_set_analysis_options;
end

% paths and files
[~, paths] = mn_subjects(options);

% record what we're doing
diary(paths.logfile);
mnket_display_analysis_step_header('secondlevel erpstats main', ...
    'all', options.stats);

try
    % check for previous statistics
    load(paths.erpspmfile);
    disp(['Group stats for difference waves of ' options.erp.type ...
        ' ERPs have been computed before.']);
    if options.stats.overwrite
        delete(paths.erpspmfile);
        disp('Overwriting...');
        error('Continue to group stats ERP step');
    else
        disp('Nothing is being done.');
    end
catch
    disp(['Computing group stats for difference waves of ' ...
        options.erp.type  ' ERPs...']);
    
    % make sure we have a results directory
    scndlvlroot = fullfile(paths.erpfold, options.condition, ...
        options.erp.contrastName);
    if ~exist(scndlvlroot, 'dir')
        mkdir(scndlvlroot);
    end

    

    
    %%% ADDED BY COLLEEN %%%
    % create images for conversion.mode = 'diffWaves'
    % previously images made for conversion.mode = 'modelbased' in
    % mnket_analyze_subject function
    for idCell = options.subjects.all
        id = char(idCell);

        mnket_conversion(id, options);
    end
    
    % smoothed images of averaged ERP data in one condition in each subject
    % serve as input to 2nd level statistics, but here, we only indicate 
    % the subject-specific directories of the images
    nSubjects = numel(options.erp.subjectIDs);
    imagePaths = cell(nSubjects, 1);
    for sub = 1: nSubjects
        subID = char(options.erp.subjectIDs{sub});
        details = mn_subjects(subID, options);
        imagePaths{sub, 1} = details.convroot;
       
    end
    
    % compute the drug difference on the MMN on the second level
    tnueeg_2ndlevel_erpstats_groupmean(scndlvlroot, imagePaths, ...
        options.erp.contrastName)
    disp(['Computed 2nd-level group statistics for difference ' ...
    'waves of ' options.erp.type ' ERPs in condition ' options.condition]);
end
cd(options.workdir);

diary OFF
end



