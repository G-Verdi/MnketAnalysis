function mnket_results_report_modelbased
%MNKET_RESULTS_REPORT_MODELBASED Performs all 2nd level analyses steps for
%modelbased single-trial EEG analysis in the MNKET study
%   IN:     --
%   OUT:    --

options = mn_set_analysis_options;

options.stats.mode = 'modelbased';
options.stats.design = 'epsilon';    
options.stats.pValueMode = 'clusterFWE';

for optionsCell = {'placebo', 'ketamine'}
    options.condition = char(optionsCell);

<<<<<<< HEAD
    mnket_report_spm_results(options,'groupdiff');
=======
    mnket_report_spm_results(options, options.condition);
>>>>>>> 2a43813668028e4b08931b96c29959ee0bf0c35d
   
end

mnket_report_spm_results(options, 'drugdiff');

end

