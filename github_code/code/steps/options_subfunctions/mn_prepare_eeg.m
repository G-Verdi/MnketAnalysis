function options = mn_prepare_eeg(options)
%----Specify eeg options for group by condition analysis----%
options.eeg.stats.overwrite = 1;
options.eeg.stats.mode = 'modelbased'; %'ERPs', 'modelbased', 'mERPs', 'diffWaves'
options.eeg.stats.design = {'prediction', 'epsilon','precision'};
options.eeg.stats.regressors  = {{'muhat2', 'muhat3','pihat'}; {'epsilon2','epsilon3'};{'pihat3','pihat1'}};
options.eeg.stats.secondlevel.secondlevelDir.classical = {'/Users/mypc/Dropbox/Cognemo/MMN/data/prj/group_analysis','/Users/mypc/Dropbox/Cognemo/MMN/data/prj/group_analysis','/Users/mypc/Dropbox/Cognemo/MMN/data/prj/group_analysis'}; 

