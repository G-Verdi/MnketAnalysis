function mnket_results_report_erpbased
%MNKET_RESULTS_REPORT_MODELBASED Performs all 2nd level analyses steps for
%modelbased single-trial EEG analysis in the MNKET study
%   IN:     --
%   OUT:    --

options = mnket_set_analysis_options;

options.stats.mode = 'erpbased';
options.stats.design = 'prediction';    
options.stats.pValueMode = 'clusterFWE';

for optionsCell = {'placebo', 'ketamine'}
    options.condition = char(optionsCell);
    
    options.erp.type = 'lowhighMuhat2';
    mnket_report_erpbased_spm_results(options, options.condition);
    
    options.erp.type = 'lowhighMuhat3';
    mnket_report_erpbased_spm_results(options, options.condition);
    
    options.erp.type = 'lowhighPihat';
    mnket_report_erpbased_spm_results(options, options.condition);
    
end
options.erp.type = 'lowhighMuhat2';
mnket_report_erpbased_spm_results(options, 'drugdiff');

options.erp.type = 'lowhighMuhat3';
mnket_report_erpbased_spm_results(options, 'drugdiff');

options.erp.type = 'lowhighPihat';
mnket_report_erpbased_spm_results(options, 'drugdiff');

end