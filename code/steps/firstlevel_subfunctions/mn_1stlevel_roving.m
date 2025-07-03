function mn_1stlevel_roving(id, options)
%MNKET_1STLEVEL Computes the first level contrast images for roving 
%statistics for one subject from the MNKET study.
%   IN:     id      - subject identifier, e.g '0001'
%           options - the struct that holds all analysis options
%   OUT:    --
%% Main
idx_design = find(contains(options.eeg.stats.design, design));

tnueeg_display_analysis_step_header('secondlevel singletrial main', ...
    'mn', 'all', options.eeg.stats.secondlevel);

% names of the single-trial regressors
regressors = options.stats.regressors;

% results file of first regressor
statspath = options.eeg.stats.secondlevel.secondlevelDir.classical{idx_design};
spmFile = fullfile(statspath,...
    'groupdiff', 'pairedT',regressors{1}, 'SPM.mat');

try
    % check for previous statistics
    load(spmFile);
    disp(['Group difference statistics for regressors in '...
        options.eeg.stats.design{idx_design} ' design have been computed before.']);
    if options.eeg.stats.overwrite
        delete(spmFile);
        disp('Overwriting...');
    else
        disp('Nothing is being done.');
    end
catch
    disp(['Computing group difference statistics for regressors in the ' ...
        options.eeg.stats.design{idx_design}  ' design...']);
    
    % make sure we have a results directory

    scndlvlroot = fullfile(statspath, 'groupdiff', 'ANOVA');
    if ~exist(scndlvlroot, 'dir')
        mkdir(scndlvlroot);
    end
    cd(scndlvlroot);
    
    %----------------------------------------------------------------------
    % Collect 1st level beta images
    %----------------------------------------------------------------------
    % beta images of 1st level regression for each regressor in each
    % subject and each condition serve as input to 2nd level statistics, 
    % but here, we only indicate the subject-specific directories of the 
    % beta images
    
    % Cycle through groups
    idx = 1;
    IDs = cell(0);
    for g = 1:numel(options.subjects.group_labels)
        for c = 1:numel(options.subjects.condition_labels)
            temp = options.groupxcond.IDs{g,c};
            
            % Collect subject beta image paths
            for s = 1:numel(temp)
                if c == 1  

                    options.workdir = fullfile(options.preprocdir,'test_mnket');
                    details = mn_subjects(temp{s}, options);
                    % TODO: should be variable when source analysis is used and for ERP analysis
                    icell(idx).scans{s, 1} = fullfile(details.statroot);
                    if g==2
                        options.condition ='ketamine';
                        details = mn_subjects(temp{s}, options);
                        % TODO: should be variable when source analysis is used and for ERP analysis
                        icell(idx).scans{s, 1} = fullfile(details.statroot);
                    end
                    
                elseif c==2
                    options.workdir = fullfile(options.preprocdir,'test_mnpsi');
                    details = mn_subjects(temp{s}, options);
                    % TODO: should be variable when source analysis is used and for ERP analysis
                    icell(idx).scans{s, 1} = fullfile(details.statroot);
                    
                    if g==2
                        options.condition ='psilocybin';
                        details = mn_subjects(temp{s}, options);
                        % TODO: should be variable when source analysis is used and for ERP analysis
                        icell(idx).scans{s, 1} = fullfile(details.statroot);
                    end
                    
                   
                end
                
            end
            icell(idx).levels = [g, c];
            IDs = [IDs temp];
            clear temp
            idx = idx+1;
        end
    end
    
    
    %----------------------------------------------------------------------
    % Covariates
    %----------------------------------------------------------------------
    % read in covariate information
        covariates = perez_get_covariate_labels(IDs, options);
 
    %----------------------------------------------------------------------
    % Second level: Group differences
    %----------------------------------------------------------------------
    % compute the effect of the single-trial regressors on the second level
    % one way ANOVA

      mn_full_factorial_modelbased(icell, scndlvlroot,covariates, idx_design, options, 0);
    
     % tnueeg_2ndlevel_singletrial_groupdiff_paired(scndlvlroot, imagePaths, ...
         % regressorNames, conditions, options)
    disp(['Computed 2nd-level drug difference statistics for regressors ' ...
        'in the ' options.eeg.stats.design{idx_design} ' design.']);
end
%cd(options.codedir);

end




