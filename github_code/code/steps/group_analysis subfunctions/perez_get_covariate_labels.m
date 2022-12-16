function [covars] = perez_get_covariate_labels(IDs, options)
%--------------------------------------------------------------------------
% Returns specific covariates for subjects specified in IDs.
%--------------------------------------------------------------------------


%% Main
% Read data
[~, ~, raw] = xlsread("C:\Users\Gabrielle\Desktop\Q_data_summaryscores.xlsx");
all_IDs = cellfun(@(x) erase(x,'s'), raw(:,1), 'UniformOutput', false);
IDs = cellfun(@(x) x(1:4), IDs, 'UniformOutput', false);


%% Replace empty values
raw(strcmp(raw,' ')) = {NaN};
raw(:,1)=[]; % remove first coloumn
raw= cell2mat(raw);

%% Init
% OB = NaN(length(IDs),1);
% VR = NaN(length(IDs),1);

% Cycle through subjects
for idx = 1:length(IDs)
    
    % Find subject in data table
    %row = find(strcmp(all_IDs, IDs{idx}));
    
    % Get covariates
     OB(idx) = raw(idx,1);
     VR(idx) = raw(idx,2);
     DED(idx) = raw(idx,3);
%     EI(idx) = raw(idx,1);
end

 OB = OB.';
 VR = VR.';
 DED = DED.';
%  EI  = EI.';
%% Write ouput table
 covars = array2table([OB VR DED]);
 covars.Properties.VariableNames = {'OB', 'VR', 'DED'};

% covars = array2table([EI]);
% covars.Properties.VariableNames = {'EI'};
