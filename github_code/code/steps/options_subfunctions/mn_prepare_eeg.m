function options = mn_prepare_eeg(options)
%----Specify eeg options for group by condition analysis----%
options.eeg.stats.overwrite = 1;
options.eeg.stats.mode = 'modelbased'; %'ERPs', 'modelbased', 'mERPs', 'diffWaves'
options.eeg.stats.design = {'prediction', 'epsilon'};
options.eeg.stats.regressors  = {{'muhat2', 'muhat3','pihat'}; {'epsilon2','epsilon3'}};
options.eeg.stats.secondlevel.secondlevelDir.classical = {'C:\Users\Gabrielle\Documents\Cognemo\MMN\data\prj\group_analysis','C:\Users\Gabrielle\Documents\Cognemo\MMN\data\prj\group_analysis'}; 

