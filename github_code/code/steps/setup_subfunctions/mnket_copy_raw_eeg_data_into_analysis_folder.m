function mnket_copy_raw_eeg_data_into_analysis_folder( options )
%MNKET_COPY_RAW_EEG_DATA_INTO_ANALYSIS_FOLDER Copies raw EEG data from raw directory to current 
%analysis folder

conditions      = {'placebo', 'ketamine'};

% source: where are the raw data currently
rawdatasource   = fullfile(options.rawdir);
srcprefix       = 'TNU_MNKET_';
srcsubfolder    = 'eegdata';

% destination: where should I put them
rawdatadest     = fullfile(options.workdir, 'subjects');
destprefix      = 'MMN_';
destsubfolder   = 'eeg';

% loop over conditions and subjects
for condCell    = conditions
    cond        = char(condCell);

    for idCell  = options.subjects.all
        id      = char(idCell);

        subjsource      = fullfile(rawdatasource, ...
            [srcprefix id], srcsubfolder, [destprefix id '*' cond(1:3) '.*df']);
        subjdestination = fullfile(rawdatadest, cond, ...
            [destprefix id], destsubfolder);
        
        if ~exist(subjdestination, 'dir')
            mkdir(subjdestination);
        end
        
        copyfile(subjsource, subjdestination);
        disp(['Copied raw EEG data for subject ' id ' in condition ' cond]);
    end
end

end

