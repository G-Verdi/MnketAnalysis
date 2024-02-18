function mnket_results_report_erpbased
%MNKET_RESULTS_REPORT_MODELBASED Performs all 2nd level analyses steps for
%modelbased single-trial EEG analysis in the MNKET study
%   IN:     --
%   OUT:    --

options = mn_set_analysis_options;

options.stats.mode = 'erpbased';
options.stats.design = 'precision';    
options.stats.pValueMode = 'peakFWE';

for optionsCell = {'placebo', 'ketamine'}
    options.condition = char(optionsCell);
    
    options.erp.type = 'lowhighPihat2';
    mnket_report_erpbased_spm_results(options, options.condition);
    
    options.erp.type = 'lowhighPihat3';
    mnket_report_erpbased_spm_results(options, options.condition);

     options.erp.type = 'lowhighPihat1';
     mnket_report_erpbased_spm_results(options, options.condition);
    
end

options.erp.type = 'lowhighPihat2';
mnket_report_erpbased_spm_results(options, 'drugdiff');

options.erp.type = 'lowhighPihat3';
mnket_report_erpbased_spm_results(options, 'drugdiff');

options.erp.type = 'lowhighPihat1';
mnket_report_erpbased_spm_results(options, 'drugdiff');


end