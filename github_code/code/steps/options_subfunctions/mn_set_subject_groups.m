function options = mn_set_subject_groups(options)
%% 
% Augments options with list of subjects and covariates that need to be 
% included in the analysis.
%-----Excluded subjects----------------------------------------------%
exclude = {'4430','4508','4438', ... % only placebo data is good
            '4448'}; % only psilocybin data is good
           
%%%% Specify subject groups %%%
switch options.analysis
     
    case 'MNKET'
        %----------------------------
        % Prepare all subjects
        %----------------------------
        subjects  = {'4431', '4446', '4447', '4458', ...
        '4482', '4487', '4488', '4548', ...
        '4494', '4499', '4500', '4520', ...
        '4532', '4497', '4534', '4459', ...
        '4507', '4422', '4478'};

        % Return subjects that should be included in analysis
        options.subjects.all = setdiff(subjects, exclude, 'stable');

        %----------------------------
        % Prepare groups
        %----------------------------
        options.subjects.group_labels = {'placebo','ketamine'};

        %%% placebo %%%
        groups{1} = {'4431', '4446', '4447', '4458', ...
             '4482', '4487', '4488', '4548', ...
             '4494', '4499', '4500', '4520', ...
             '4532', '4497', '4534', '4459', ...
             '4507', '4422', '4478'};
         
         %%% ketamine %%%
        groups{2} = {'4431', '4446', '4447', '4458', ...
             '4482', '4487', '4488', '4548', ...
             '4494', '4499', '4500', '4520', ...
             '4532', '4497', '4534', '4459', ...
             '4507', '4422', '4478'};
    
        % Output groups
        for i = 1:length(groups)
            if isempty(exclude)
                options.subjects.group{i} = groups{i};
            else
                options.subjects.group{i} = setdiff(groups{i}, exclude, 'stable');
            end
        end 
     
    case 'MNPSI'
        %----------------------------
        % Prepare all subjects
        %----------------------------
        subjects  = {'3621',  ...
        '4415','4418','4419','4420','4421',...
        '4426','4430','4332',...
        '4433','4438','4448','4460','4476',...
        '4502','4508','4515','4518','4591','4592'};

        % Return subjects that should be included in analysis
        options.subjects.all = setdiff(subjects, exclude, 'stable');

        %----------------------------
        % Prepare groups
        %----------------------------
        options.subjects.group_labels = {'placebo','psilocybin'};
        
        %%% placebo %%%
        groups{1} = {'3621',  ...
        '4415','4418','4419','4420','4421',...
        '4426','4430','4332',...
        '4433','4438','4448','4460','4476',...
        '4502','4508','4515','4518','4591','4592'};

        %%% psilocybin %%%
        groups{2} = {'3621',  ...
        '4415','4418','4419','4420','4421',...
        '4426','4430','4332',...
        '4433','4438','4448','4460','4476',...
        '4502','4508','4515','4518','4591','4592'};
    
        % Output groups
        for i = 1:length(groups)
            if isempty(exclude)
                options.subjects.group{i} = groups{i};
            else
                options.subjects.group{i} = setdiff(groups{i}, exclude, 'stable');
            end
        end
        
    case 'group_analysis'
        %----------------------------
        % Prepare all subjects
        %----------------------------
        subjects  = {'4431', '4446', '4447', '4458', ...
             '4482', '4487', '4488', '4548', ...
             '4494', '4499', '4500', '4520', ...
             '4532', '4497', '4534', '4459', ...
             '4507', '4422', '4478', '3621',  ...
        '4415','4418','4419','4420','4421',...
        '4426','4430','4332',...
        '4433','4438','4448','4460','4476',...
        '4502','4508','4515','4518','4591','4592'};

        % Return subjects that should be included in analysis
        options.subjects.all = setdiff(subjects, exclude, 'stable');

        %----------------------------
        % Prepare groups
        %----------------------------
        options.subjects.group_labels = {'mnket','mnpsi'};
           
        %%% mnket %%%
        groups{1} = {'4431', '4446', '4447', '4458', ...
             '4482', '4487', '4488', '4548', ...
             '4494', '4499', '4500', '4520', ...
             '4532', '4497', '4534', '4459', ...
             '4507', '4422', '4478'};
         
         %%% mnpsi%%%
        groups{2} = {'3621',  ...
        '4415','4418','4419','4420','4421',...
        '4426','4430','4332',...
        '4433','4438','4448','4460','4476',...
        '4502','4508','4515','4518','4591','4592'};


        % Output groups
        for i = 1:length(groups)
            if isempty(exclude)
                options.subjects.group{i} = groups{i};
            else
                options.subjects.group{i} = setdiff(groups{i}, exclude, 'stable');
            end
        end
        
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

             
                                     
    case 'compi'
        %----------------------------
        % Prepare all subjects
        %----------------------------
        subjects  = {'0143','0101', '0102', '0103', '0104', ...
                     '0105', '0106', '0107', '0108', ...
                     '0109', '0110', '0111','0112','0113', ...
                     '0114', '0115', '0116', '0117', ...
                     '0118', '0119', '0120','0121','0122','0123',...
                     '0124','0125','0126','0127','0128','0129','0130','0131','0132',...
                     '0133','0134','0135','0136','0137','0138','0139','0140'...
                     '0141','0142'};

        % Return subjects that should be included in analysis
        options.subjects.all = setdiff(subjects, exclude, 'stable');

        %----------------------------
        % Prepare groups
        %----------------------------
        options.subjects.group_labels = {'control'};
        
        %%% Controls %%%
        groups{1} = {'0143','0101', '0102', '0103', '0104', ...
                     '0105', '0106', '0107', '0108', ...
                     '0109', '0110', '0111','0112','0113', ...
                     '0114', '0115', '0116', '0117', ...
                     '0118', '0119', '0120','0121','0122','0123',...
                     '0124','0125','0126','0127','0128','0129','0130','0131','0132',...
                     '0133','0134','0135','0136','0137','0138','0139','0140'...
                     '0141','0142'};
    
        % Output groups
        for i = 1:length(groups)
            if isempty(exclude)
                options.subjects.group{i} = groups{i};
            else
                options.subjects.group{i} = setdiff(groups{i}, exclude, 'stable');
            end
        end 
    
end
