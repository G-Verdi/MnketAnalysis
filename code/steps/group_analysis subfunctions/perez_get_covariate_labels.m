function [covars] = perez_get_covariate_labels(IDs, options)
%--------------------------------------------------------------------------
% Returns specific covariates for subjects specified in IDs.
%--------------------------------------------------------------------------


%% Main
% Read data
[~, ~, raw] = xlsread("/Volumes/Expansion/Cognemo/MMN/MNPSI Project files/Q_data_summaryscores.xlsx");
all_IDs = cellfun(@(x) erase(x,'E1'), raw(:,1), 'UniformOutput', false);

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

     DE(idx) = raw(idx,1);
     EU(idx) = raw(idx,2);
     SP(idx) = raw(idx,3);
     BS(idx) = raw(idx,4);
     IN(idx) = raw(idx,5);
     CP(idx) = raw(idx,6);
     EI(idx) = raw(idx,7);
     CI(idx) = raw(idx,8);
     AV(idx) = raw(idx,9);
     ICC(idx) = raw(idx,10);
     AX(idx) = raw(idx,11);
     GASC(idx)= raw (idx,12);

end
     DE = DE.';
     EU = EU.';
     SP = SP.';
     BS = BS.';
     IN = IN.';
     CP = CP.';
     EI = EI.';
     CI = CI.';
     AV = AV.';
     ICC = ICC.';
     AX = AX.';
     GASC = GASC.';

%% Write ouput table

 covars = array2table([DE EU SP BS IN CP EI CI AV ICC AX GASC]);
 covars.Properties.VariableNames = {'DE' 'EU' 'SP' 'BS' 'IN' 'CP' 'EI' 'CI' 'AV' 'ICC' 'AX' 'GASC'};


