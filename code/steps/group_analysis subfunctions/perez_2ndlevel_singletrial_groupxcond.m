function perez_2ndlevel_singletrial_groupxcond(design, options)
%--------------------------------------------------------------------------
% Computes the second-level contrast images for differences in the effects 
% of single-trial (modelbased) regressors between groups (healthy controls,
% clinical high-risk, and recent-onset psychosis) in the Perez et al. 
% study.
%--------------------------------------------------------------------------


%% Main
idx_design = find(contains(options.eeg.stats.design, design));

tnueeg_display_analysis_step_header('secondlevel singletrial main', ...
    'perez', 'all', options.eeg.stats.secondlevel);

% names of the single-trial regressors
% regressors = options.eeg.stats.regressors;

% results file of first regressor
spmFile = fullfile(options.eeg.stats.secondlevel.secondlevelDir.classical{idx_design},...
    'groupdiff', 'pairedT', 'SPM.mat');

try
    % check for previous statistics
    load(spmFile);
    disp(['Group difference statistics for regressors in '...
        options.eeg.stats.design{idx_design} ' design have been computed before.']);
    if options.eeg.stats.overwrite
        delete(spmFile);
        disp('Overwriting...');
        error('Continue to drug difference stats step');
    else
        disp('Nothing is being done.');
    end
catch
    disp(['Computing group difference statistics for regressors in the ' ...
        options.eeg.stats.design{idx_design}  ' design...']);
    
    % make sure we have a results directory
    scndlvlroot = fullfile(options.eeg.stats.secondlevel.secondlevelDir.classical{idx_design}, 'groupdiff');
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
           
                    options.workdir = fullfile('C:\Users\Gabrielle\Dropbox\PC\Documents\Cognemo\MMN\data\prj\test_mnket');
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
                    options.workdir = fullfile('C:\Users\Gabrielle\Dropbox\PC\Documents\Cognemo\MMN\data\prj\test_mnpsi');
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
%     covariates = perez_get_covariate_labels(IDs, options);
%     % Z-transform age
%     covariates.age = (covariates.age-mean(covariates.age))/std(covariates.age);
         
    
    %----------------------------------------------------------------------
    % Second level: Group differences
    %----------------------------------------------------------------------
    % compute the effect of the single-trial regressors on the second level
    % one way ANOVA
     perez_full_factorial_modelbased(icell, scndlvlroot,idx_design, options, 0);
    
%     tnueeg_2ndlevel_singletrial_groupdiff_paired(scndlvlroot, imagePaths, ...
%         regressorNames, conditions, options)
    disp(['Computed 2nd-level drug difference statistics for regressors ' ...
        'in the ' options.eeg.stats.design{idx_design} ' design.']);
end
cd(options.codedir);

end



