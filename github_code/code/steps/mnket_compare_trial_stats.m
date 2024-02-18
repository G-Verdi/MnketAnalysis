function mnket_compare_trial_stats( options )
%MNKET_COMPARE_TRIAL_STATS Summarizes and compares the trial statistics for both drug conditions in
%the MNKET study.
%   IN:     optionally:
%           options         - the struct that contains all analysis options
%   OUT:    -

if nargin < 1

    options = mn_set_analysis_options;
end

options.condition = 'placebo';
[~, paths] = mn_subjects(options);
placebo = getfield(load(paths.trialstatstab), 'trialStatsTable');

options.condition = 'psilocybin';
[~, paths] = mn_subjects(options);

psilocybin= getfield(load(paths.trialstatstab), 'trialStatsTable');

% Summarize with all participants
for iStat = 1: numel(placebo.Properties.VariableNames)
    % collect the means
    summary1.(placebo.Properties.VariableNames{iStat}).mean(1) ...
        = mean(placebo.(placebo.Properties.VariableNames{iStat}));
    summary1.(placebo.Properties.VariableNames{iStat}).mean(2) ...
        = mean(psilocybin.(placebo.Properties.VariableNames{iStat}));
    % collect the standard deviations
    summary1.(placebo.Properties.VariableNames{iStat}).sd(1) ...
        = std(placebo.(placebo.Properties.VariableNames{iStat}));
    summary1.(placebo.Properties.VariableNames{iStat}).sd(2) ...
        = std(psilocybin.(placebo.Properties.VariableNames{iStat}));  
    % test for sig. differences between conditions
    [summary1.(placebo.Properties.VariableNames{iStat}).sig, ...
        summary1.(placebo.Properties.VariableNames{iStat}).pvalue, ...
        summary1.(placebo.Properties.VariableNames{iStat}).confidence, ...
        summary1.(placebo.Properties.VariableNames{iStat}).stats] ...
        = ttest(placebo.(placebo.Properties.VariableNames{iStat}), ...
            psilocybin.(placebo.Properties.VariableNames{iStat}));
    
end
save(paths.trialstats_summary_all, 'summary1');

% Summarize without participant 4497
placebo(14, :) = [];
psilocybin(14, :) = [];
for iStat = 1: numel(placebo.Properties.VariableNames)
    % collect the means
    summary2.(placebo.Properties.VariableNames{iStat}).mean(1) ...
        = mean(placebo.(placebo.Properties.VariableNames{iStat}));
    summary2.(placebo.Properties.VariableNames{iStat}).mean(2) ...
        = mean(psilocybin.(placebo.Properties.VariableNames{iStat}));
    % collect the standard deviations
    summary2.(placebo.Properties.VariableNames{iStat}).sd(1) ...
        = std(placebo.(placebo.Properties.VariableNames{iStat}));
    summary2.(placebo.Properties.VariableNames{iStat}).sd(2) ...
        = std(psilocybin.(placebo.Properties.VariableNames{iStat}));  
    % test for sig. differences between conditions
    [summary2.(placebo.Properties.VariableNames{iStat}).sig, ...
        summary2.(placebo.Properties.VariableNames{iStat}).pvalue, ...
        summary2.(placebo.Properties.VariableNames{iStat}).confidence, ...
        summary2.(placebo.Properties.VariableNames{iStat}).stats] ...
        = ttest(placebo.(placebo.Properties.VariableNames{iStat}), ...
            psilocybin.(placebo.Properties.VariableNames{iStat}));
end
save(paths.trialstats_summary_red, 'summary2');



end
