function finaldesign = mnket_correct_regressors_for_EEG_artefacts_special_case( details, options )
%MNKET_CORRECT_REGRESSORS_FOR_EEG_ARTEFACTS_SPECIAL_CASE Corrects modelbased regressors for EEG
%artefacts before applying the firstlevel statistics for one subject in the MNKET study. This
%function applies to the special case of subject 4534 for which the EEG recording started too late.
%Here, we don't have to worry about the first EEG trial. For details, see readme_special_case.txt.
%   IN:     details     - the struct that holds all subject-specific paths and filenames     
%   OUT:    finaldesign - the corrected design struct holding the vectors to be used in the 
%                       regression of the preprocessed EEG data

initialdesign   = getfield(load(details.design), 'design');
trialStats      = getfield(load(details.trialstats), 'trialStats');

design = initialdesign;
regressors = fieldnames(design);

switch options.preproc.eyeblinktreatment
    case 'reject'
        %-- Bad trials due to Eye blinks ----------------------------------------------------------%
        eyeblinktrials = trialStats.idxEyeartefacts.tone;
        % now we remove these entries from all regressors in our design
        for iReg = 1: numel(regressors)
            design.(regressors{iReg})(eyeblinktrials) = [];
        end     
        
        trialStats.removedTrials.eyeblinktrials = eyeblinktrials;
end

%-- Bad trials due to Artefacts -----------------------------------------------------------%
artefacttrials = trialStats.idxArtefacts;
% now we remove these entries from all regressors in our design
for iReg = 1: numel(regressors)
    design.(regressors{iReg})(artefacttrials) = [];
end

trialStats.removedTrials.artefacttrials = artefacttrials;
save(details.trialstats, 'trialStats');


%-- Compare numbers -------------------------------------------------------------------------------%
nInitial = length(initialdesign.(regressors{1}));
nFinal = length(design.(regressors{1}));
try
    nEyeblinks = length(eyeblinktrials);
catch
    nEyeblinks = 0;
end
nArtefacts = (nInitial - nEyeblinks) - nFinal;

if nFinal ~= trialStats.nTrialsFinal.all
    error('Final number of trials does not match the preprocessing output.');
end
switch options.preproc.eyeblinktreatment
    case 'reject'
        if nEyeblinks ~= trialStats.numEyeartefacts.all
            error('Number of eye blink artefacts does not match the preprocessing output.');
        end
end
if nArtefacts ~= trialStats.numArtefacts
    error('Number of additional artefacts does not match the preprocessing output.');
end

finaldesign = design;

end

