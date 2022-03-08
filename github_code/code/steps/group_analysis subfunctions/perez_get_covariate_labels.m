function [covars] = perez_get_covariate_labels(IDs, options)
%--------------------------------------------------------------------------
% Returns specific covariates for subjects specified in IDs.
%--------------------------------------------------------------------------


%% Main
% Read data
[~, ~, raw] = xlsread(options.files.groups);
all_IDs = cellfun(@(x) erase(x,'E1'), raw(:,1), 'UniformOutput', false);
IDs = cellfun(@(x) x(1:4), IDs, 'UniformOutput', false);


%% Replace empty values
raw(strcmp(raw,' ')) = {NaN};


%% Init
sex = NaN(length(IDs),1);
age = NaN(length(IDs),1);

% Cycle through subjects
for idx = 1:length(IDs)
    
    % Find subject in data table
    row = find(strcmp(all_IDs, IDs{idx}));
    
    % Get covariates
    sex(idx) = raw{row,strcmp(raw(1,:), 'gender')};
    age(idx)    = raw{row,strcmp(raw(1,:), 'age')};
end


%% Write ouput table
covars = array2table([sex age]);
covars.Properties.VariableNames = {'sex', 'age'};

