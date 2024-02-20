% List of open inputs
nrun = 1; % enter the number of runs here
jobfile = {'/Users/gabriellea/Documents/MMN_code/Mnket_files_misc/mnketAnalysis/github_code/code/steps/group_analysis subfunctions/Batch Scripts/active_drug_test_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'EEG');
spm_jobman('run', jobs, inputs{:});
