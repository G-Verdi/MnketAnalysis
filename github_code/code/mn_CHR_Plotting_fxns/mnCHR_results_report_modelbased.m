function mnCHR_results_report_modelbased (options)
%MNCHR_RESULTS_REPORT_MODELBASED Performs all 2nd level analyses steps for
%modelbased single-trial EEG analysis in the MNKET study
%   IN:     --
%   OUT:    --

options.stats.mode = 'modelbased';   
options.stats.pValueMode = 'clusterFWE'; %clusterFWE, peakFWE


for i_group = 1:length(options.subjects.group_labels)
    options.condition = char(options.subjects.group_labels{i_group});
    mnCHR_report_spm_results(options, options.condition);
    

    contrast_idx = 3;
    regressor = 'sig2';
    mnCHR_plot_blobs(contrast_idx, regressor, options);
end

mnCHR_report_spm_results(options, 'groupdiff');

end
