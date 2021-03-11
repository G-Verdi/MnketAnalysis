function [] = mnket_report_spm_results( options, flag )
%MNKET_REPORT_SPM_RESULTS
%   IN:     options - the struct that holds all analysis options
%           flag    - string indicating either the condition ('placebo',
%           'ketamine') or 'drugdiff'
%   OUT:    --

% general analysis options
if nargin < 1
    options = mnket_set_analysis_options;
    flag = options.condition;
end
if ischar(options)
    flag = options;
    options = mnket_set_analysis_options;
end
% sanity check
if ismember(flag, options.conditions) && ~strcmp(flag, options.condition)
    disp(['Changing options.condition field to ' flag]);
    options.condition = flag;
end

% prepare SPM, as always
spm('Defaults', 'EEG');

% paths and files
[~, paths] = mnket_subjects(options);

% record what we're doing
diary(paths.logfile);
mnket_display_analysis_step_header(['results report: ' flag], ...
    'all', options.stats);

% names of the single-trial regressors
regressorNames = options.stats.regressors;

% scalpmap images of first regressor
switch flag
    case options.conditions
        spmRoot = fullfile(paths.statfold);
        pngFiles = fullfile(spmRoot, regressorNames{1}, 'scalpmaps_*.png');
        contrastTitle = 'Effect of ';
        contrastIdx = 3;
        nVoxMin = 1;
    case 'drugdiff'
        spmRoot = paths.statdifffold;
        pngFiles = fullfile(spmRoot, regressorNames{2}, 'scalpmaps_*.png');
        contrastTitle = 'Pla > Ket in ';
        contrastIdx = 1;
        nVoxMin = 1;
end

try
    % check for previous results report
    listDir = dir(pngFiles);
    list = {listDir(~[listDir.isdir]).name};
    if ~isempty(list)
        disp(['2nd level results for regressors in ' options.stats.design ...
        ' design in condition ' options.condition ...
        ' have been reported before.']);
        if options.stats.overwrite
            disp('Overwriting...');
            error('Continue to results report step');
        else
            disp('Nothing is being done.');
        end
    else
        error('Cannot find previous report');
    end
catch
    disp(['Reporting 2nd level results for regressors for ' ...
        options.condition ' condition in the ' ...
        options.stats.design  ' design...']);
    
    % p value thresholding
    switch options.stats.pValueMode
        case 'clusterFWE'
            u = 0.001;
            thresDesc = 'none';
        case 'peakFWE'
            u = 0.05;
            thresDesc = 'FWE';
    end

    % go through all regressors
    for iReg = 1: numel(regressorNames)

        xSPM = struct;
        xSPM.swd      = fullfile(spmRoot, regressorNames{iReg});
        xSPM.title    = [contrastTitle regressorNames{iReg}];
        xSPM.Ic       = contrastIdx;
        xSPM.n        = 1;
        xSPM.Im       = [];
        xSPM.pm       = [];
        xSPM.Ex       = [];
        xSPM.u        = u;
        xSPM.k        = 0;
        xSPM.thresDesc = thresDesc;

        %-- save results table as csv ------------------------------------%
        xSPM = mnket_write_table_results(xSPM, ...
            options.stats.pValueMode, false, nVoxMin);
        % save xSPM for later convenience
        save(fullfile(xSPM.swd, ...
            ['xSPM_' xSPM.STAT '_' options.stats.pValueMode '.mat']), ...
            'xSPM');
        
        %-- significant clusters: info & plotting ------------------------%
        locs = xSPM.XYZ;
        % only continue if there are surviving voxels
        if ~isempty(locs)
            % extract all plotting-relevant contrast info 
            con = tnueeg_extract_contrast_results(xSPM, ...
                [options.condition ':']);
            
            save(fullfile(con.swd, ...
                ['con_' con.stat '_' options.stats.pValueMode '.mat']), ...
                'con');

            % plot all sections overlays 
            cd(con.swd);
            sectionsFolder = ['con' con.stat '_sections'];
            contoursFolder = ['con' con.stat '_contours'];
            scalpmapsFolder = ['con' con.stat '_scalpmaps'];
            mkdir(sectionsFolder);
            mkdir(contoursFolder);
            mkdir(scalpmapsFolder);
            cd(sectionsFolder);
            
            % reduce blobs in xSPM to the significant ones
            sigIdx = [];
            for iSigClus = 1: con.nClusters.sig
                [~, iA] = intersect(xSPM.XYZ, con.clusters(iSigClus).allvox, 'rows');
                sigIdx = [sigIdx; iA];
            end
            xSPM.XYZ = xSPM.XYZ(:, sigIdx);
            xSPM.Z = xSPM.Z(sigIdx);
            tnueeg_overlay_sections_per_cluster(xSPM, con);
            cd('..');
            cd(contoursFolder);
            tnueeg_overlay_sections_per_cluster(xSPM, con);

            % plot all scalpmaps 
            cd('..');
            cd(scalpmapsFolder);
            %conf = mnket_configure_scalpmaps(con, options, options.stats.(flag).(regressorNames{iReg}).clbarlimits);
            conf = mnket_configure_scalpmaps(con, options, xSPM.STAT, abs(max(xSPM.Z)));
            tnueeg_scalpmaps_per_cluster(con, conf);
        end
    end
end
cd(options.workdir);

diary OFF
end
