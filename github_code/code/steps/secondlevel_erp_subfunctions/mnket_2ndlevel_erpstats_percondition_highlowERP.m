function mnket_2ndlevel_erpstats_percondition_highlowERP(options)
%MNKET_2NDLEVEL_ERPSTATS_PERCONDITION Computes the second level contrast
%images for high and low ERP effects in one condition in the MNKET study.
%   IN:     options - the struct that holds all analysis options
%   OUT:    --

% general analysis options
if nargin < 1
    options = mnket_set_analysis_options;
end

% paths and files
[~, paths] = mnket_subjects(options);

% record what we're doing
diary(paths.logfile);
mnket_display_analysis_step_header('secondlevel erpstats main', ...
    'all', options.stats);

%%% ADDED BY COLLEEN %%%
% added switch options.erp.type
% made into loop to iterate through condition types
% switched options.erp.contrastName with cond (condtion name)
switch options.erp.type
    case 'lowhighEpsi2'
        conditionName = {'high', 'low'}
    case 'lowhighEpsi3'
        conditionName = {'high', 'low'}
    case 'lowhighMuhat2'
        conditionName = {'high', 'low'}
    case 'lowhighMuhat3'
        conditionName = {'high', 'low'}
    case 'lowhighPihat'
        conditionName = {'high', 'low'}
    case 'roving'
        conditionName = options.erp.contrastName;
    case 'mmnad'
        conditionName = options.erp.contrastName;
end

for condnum = 1:length(conditionName)
    cond = conditionName{condnum}
    
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
        scndlvlroot = fullfile(paths.erpstatfold, ...
            cond); %options.erp.contrastName
        if ~exist(scndlvlroot, 'dir')
            mkdir(scndlvlroot);
        end

        %%% ADDED BY COLLEEN %%%
        % create images for conversion.mode = 'ERPs'
        % previously images made for conversion.mode = 'modelbased' in
        % mnket_analyze_subject function
        for idCell = options.subjects.all
            id = char(idCell);

            options.conversion.mode = 'ERPs';
            mnket_conversion(id, options);

        end
        
        % smoothed images of averaged ERP data in one condition in each subject
        % serve as input to 2nd level statistics, but here, we only indicate 
        % the subject-specific directories of the images
        nSubjects = numel(options.erp.subjectIDs);
        imagePaths = cell(nSubjects, 1);
        for sub = 1: nSubjects
            subID = char(options.erp.subjectIDs{sub});
            details = mnket_subjects(subID, options);
            imagePaths{sub, 1} = details.convroot;
        end

        % compute the drug difference on the MMN on the second level
        tnueeg_2ndlevel_erpstats_groupmean(scndlvlroot, imagePaths, ...
            cond)
        disp(['Computed 2nd-level group statistics for difference ' ...
        'waves of ' options.erp.type ' ERPs in condition ' options.condition]);
    end
cd(options.workdir);
end
diary OFF
end



