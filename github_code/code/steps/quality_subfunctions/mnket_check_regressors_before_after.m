function [ fhComp ] = mnket_check_regressors_before_after(beforeDesignFile, ...
    trialStatsFile, compFigure)
%TNUEEG_CHECK_REGRESSORS_BEFORE_AFTER Plots all regressors of a given design file before and after 
%pruning for bad EEG trials and saves the plots to the specified figure file names.
%   IN:     dataFile                - full file name (including path) to EEG data set with coreg
%           meshFigure, dataFigure  - full file names (including paths) for saving the resulting
%           plots
%   OUT:    -

beforeDesign= getfield(load(beforeDesignFile), 'design');
trialStats = getfield(load(trialStatsFile), 'trialStats');

regressors  = fieldnames(beforeDesign);

fhComp = figure;

for iReg = 1: numel(regressors)
    
    subplot(2, 1, iReg);
    plot(beforeDesign.(regressors{iReg}), '.k', 'MarkerSize', 3);
    hold on;
    switch options.preproc.eyeblinktreatment
        case 'reject'
            plot(trialStats.removedTrials.eyeblinktrials, ...
                beforeDesign.(regressors{iReg})(trialStats.removedTrials.eyeblinktrials), ...
                'ob', 'MarkerSize', 3);
    end
    plot(trialStats.removedTrials.artefacttrials, ...
        beforeDesign.(regressors{iReg})(trialStats.removedTrials.artefacttrials), ...
        'or', 'MarkerSize', 3);
    
    xlim([1 numel(beforeDesign.(regressors{iReg}))]);
    title([regressors{iReg} ' before pruning, with artefacts']);
    
    switch options.preproc.eyeblinktreatment
        case 'reject'
            legend('regressor', 'eyeblinks', 'artefacts');
        case 'ssp'
            legend('regressor', 'artefacts');
    end
end
    
 if nargin > 2 && ~isempty(compFigure)
    saveas(fhComp, [compFigure '_artefacts'], 'fig');
    close(fhComp);
 end   


end