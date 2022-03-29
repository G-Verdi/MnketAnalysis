function mnket_results_report_modelbased
%MNKET_RESULTS_REPORT_MODELBASED Performs all 2nd level analyses steps for
%modelbased single-trial EEG analysis in the MNKET study
%   IN:     --
%   OUT:    --

options = mn_set_analysis_options;

options.stats.mode = 'erpbased';
options.stats.design = 'precision';    
options.stats.pValueMode = 'clusterFWE';

for optionsCell = {'placebo', 'ketamine'}
    options.condition = char(optionsCell);

    mnket_report_spm_results(options, options.condition);
    
    contrast_idx = 3;
    regressor = 'pihat2';
    mnCHR_plot_blobs(contrast_idx, regressor, options);
end

mnket_report_spm_results(options, 'drugdiff');
mnCHR_plot_blobs(contrast_idx, regressor, options);

end

