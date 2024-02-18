function mn_groupxcond_results_report
%MNKET_RESULTS_REPORT_MODELBASED Performs all 2nd level analyses steps for
%modelbased single-trial EEG analysis in the MNKET study
%   IN:     --
%   OUT:    --

options = mn_set_analysis_options;

options.stats.mode = 'modelbased';
options.stats.design = 'precision';    
options.stats.pValueMode = 'clusterFWE';

for optionsCell = {'placebo','ketamine'}
    options.condition = char(optionsCell);

   mnket_report_spm_results(options,'groupdiff');
     
   
end

