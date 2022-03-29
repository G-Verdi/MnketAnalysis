function mnCHR_results_report_erpbased(options)
%MNCHR_RESULTS_REPORT_MODELBASED Performs all 2nd level analyses steps for
%modelbased single-trial EEG analysis in the MNKET study
%   IN:     --
%   OUT:    --

options.stats.mode = 'diffWaves';   
options.stats.pValueMode = 'clusterFWE';


for i_group = 1:length(options.subjects.group_labels)
    options.condition = char(options.subjects.group_labels{i_group});

    mnCHR_report_spm_results(options, options.condition);
end

mnCHR_report_spm_results(options, 'groupdiff');

end