function mnket_setup_analysis_folder(options)
%MNKET_SETUP_ANALYSIS_FOLDER Creates project directory tree and collects data for the MNKET project

if nargin < 1
    options = mn_set_analysis_options;
end

%-- create folder tree ----------------------------------------------------------------------------%
if ~exist(options.roots.results, 'dir')
    mkdir(options.roots.results);
end

cd(options.roots.results);
diary('analysis_setup.log');

for subfolder = {'config', 'subjects', 'tones', 'erp', 'stats_erp', 'stats_model'}
    if ~exist(fullfile(options.roots.results, char(subfolder)), 'dir')
        mkdir(fullfile(options.roots.results, char(subfolder)));
    end
end
disp(['Created analysis folder tree at ' options.roots.results]);

%-- raw exp data ----------------------------------------------------------------------------------%
% copy raw experimental data to analysis folder
expDataSource   = fullfile(options.rawdir, 'tonesequences');
expDataDest     = fullfile(options.roots.results, 'tones');
copyfile(expDataSource, expDataDest);
disp('Copied raw experimental data to analysis subfolder tones');

%-- raw eeg data ----------------------------------------------------------------------------------%
mnket_copy_raw_eeg_data_into_analysis_folder(options);
disp('Copied raw EEG data to analysis subfolder subjects');

%-- cap info --------------------------------------------------------------------------------------%
copyfile(fullfile(options.rawdir, 'capinfo', '*'), fullfile(options.roots.results, 'config'));
disp('Copied cap info to analysis subfolder config');

end

