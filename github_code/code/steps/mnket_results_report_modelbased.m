function mnket_results_report_modelbased
%MNKET_RESULTS_REPORT_MODELBASED Performs all 2nd level analyses steps for
%modelbased single-trial EEG analysis in the MNKET study
%   IN:     --
%   OUT:    --

options = mn_set_analysis_options;

options.stats.mode = 'erpbased';
options.stats.design = 'prediction';    
options.stats.pValueMode = 'clusterFWE';

for optionsCell = {'placebo', 'psilocybin'}
    options.condition = char(optionsCell);

    mnket_report_spm_results(options, options.condition);
end

mnket_report_spm_results(options, 'drugdiff');

end

