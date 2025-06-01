function mn_2ndlevel_twosample_ttest(options)

%% Main

if nargin < 1 
    options = mn_set_analysis_options;
end


% Prepare groups
%----------------------------
options.subjects.group_labels = {'mnket','mnpsi'};
%----------------------------
%----------------------------
% Prepare groups
%----------------------------
options.subjects.group_labels = {'mnket','mnpsi'};


%-------------------------%
% Prepare conditions
%-------------------------%
options.subjects.condition_labels = {'placebo','drug'};
%-------------------------%
%Prepare group by condition 
%-------------------------%
options.groupxcond_labels     = {'mnket_placebo','mnpsi_placebo';'mnket_drug','mnpsi_drug'};
options.groupxcond.IDs{1,1}   = {'4431', '4446', '4447', '4458', ...
             '4482', '4487', '4488', '4548', ...
             '4494', '4499', '4500', '4520', ...
             '4532', '4497', '4534', '4459', ...
             '4507', '4422', '4478'};
        options.groupxcond.IDs{1,2}   = {'3621',  ...
        '4415','4418','4419','4420','4421',...
        '4426','4332',...
        '4433','4460','4476',...
        '4502','4515','4518','4591','4592'};
        options.groupxcond.IDs{2,1}   = {'4431', '4446', '4447', '4458', ...
             '4482', '4487', '4488', '4548', ...
             '4494', '4499', '4500', '4520', ...
             '4532', '4497', '4534', '4459', ...
             '4507', '4422', '4478'};
        options.groupxcond.IDs{2,2}   = {'3621',  ...
        '4415','4418','4419','4420','4421',...
        '4426','4332',...
        '4433','4460','4476',...
        '4502','4515','4518','4591','4592'};



% Make sure we have a results directory
    facdir = fullfile('/Volumes/T7/Cognemo/MMN/data/prj_roving/test_mnket/stats_erp/roving/drugdiff/mmn/twosample', 'two sample ttest');
    if ~exist(facdir, 'dir')
        mkdir(facdir);
    end
    cd(facdir);

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
                    icell(idx).scans{s, 1} = [fullfile(details.convroot, 'smoothed_condition_mmn.nii') ',1'];
                    if g==2
                        options.condition ='ketamine';
                        details = mn_subjects(temp{s}, options);
                        % TODO: should be variable when source analysis is used and for ERP analysis
                        icell(idx).scans{s, 1} = [fullfile(details.convroot, 'smoothed_condition_mmn.nii') ',1'];
                    end
                    
                elseif c==2
                    options.workdir = fullfile(options.preprocdir,'test_mnpsi');
                    details = mn_subjects(temp{s}, options);
                    % TODO: should be variable when source analysis is used and for ERP analysis
                    icell(idx).scans{s, 1} = [fullfile(details.convroot, 'smoothed_condition_mmn.nii') ',1'];
                    
                    if g==2
                        options.condition ='psilocybin';
                        details = mn_subjects(temp{s}, options);
                        % TODO: should be variable when source analysis is used and for ERP analysis
                        icell(idx).scans{s, 1} = [fullfile(details.convroot, 'smoothed_condition_mmn.nii') ',1'];
                    end
                    
                   
                end
                
            end
            icell(idx).levels = [g, c];
            IDs = [IDs temp];
            clear temp
            idx = idx+1;
        end
    end
 


IDs =[options.groupxcond.IDs{1,2}, options.groupxcond.IDs{1,2}]; % %psilocybin study
%IDs = [options.groupxcond.IDs{1,1}, options.groupxcond.IDs{1,1}]; % ketamine study



for i = 1:length(icell)
    for j = 1:numel(icell(i).scans)
        path = icell(i).scans{j};

        % Ensure path is a char and ',1' is included
        if isstring(path) || ischar(path)
            path = char(path);  % ensure it's a char vector
        end

        % Add ,1 only if not already present
        if ~contains(path, ',1')
            path = [path ',1'];
        end

        icell(i).scans{j} = path;
    end
end


 %----------------------------------------------------------------------
% Covariates
%----------------------------------------------------------------------
% read in covariate information
 covariates = perez_get_covariate_labels(IDs, options);

%%
mn_roving_twosample_ttest(facdir, icell, covariates)
