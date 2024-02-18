function dmpad_plot_blobs_placebo(pathSave, options, dispOptions)
% Function for plotting and saving EEG blob images. What you need
% is:
% - a T- or F-nifti image
% - max F or Max t-value for the intensity map
% - an extent threshold (k - minimum number of voxels per blob) - this needs to
% result in only one blob surviving (or, if more blobs survive, you need to
% know that this script extracts the first significant time point of the
% first blob and the last significant time point of the last blob).

% created by Lars Kasper & Andreea Diaconescu

%% Set options
if nargin < 1
    pathSave = pwd;
end

if nargin < 2
    options = dmpad_set_analysis_options();
end

% TODO@Lars: make this a propval call, add propval and strip_values to repo
if nargin < 3
    %% #MOD# modify these parameters
    
    % display maximum intensity projection instead of slice section with peak pixel
    dispOptions.doMIP = true;
    
    dispOptions.displayedMap = 'unthresholded'; % 'thresholdSPM', 'unthresholded'
    dispOptions.displayMode = 'surfacePlot'; %'checkReg', 'surfacePlot'
    dispOptions.pCluster = 0.05; % cluster correction p value threshold
    
    % smoothes thresholded SPMs slightly for display reasons in CheckReg
    % because of 1 voxel FWHM smooth, neighboring voxel will have half
    % the value and shall be included in color map
    switch dispOptions.displayedMap
        case 'unthresholded'
            dispOptions.doSmooth = false;
        case 'thresholdSPM'
            dispOptions.doSmooth = true;
    end
    
    dispOptions.doSave = true;
end

%% Internal options
% for display reasons, values matching peak-level significance of
% PlaceboGroup
threshSignificantArray = [29.00 22.00 26.00 17.00 13.24 29.00]; 

% if true, threshSignificantArray is used
% if false, cluster-level FWE threshold as determined by SPM
useManualThresholds = false;

%% Define files and contrast parameters
rootStats   = options.secondlevelDir.classical;
compQArray  = options.secondlevelArray(2:end); % ignoring main effect constant
groupName   = options.part;

nFiles = numel(compQArray);
fileArray = cell(nFiles, 1);
clusterMaskArray = cell(nFiles, 1);
for iFile = 1:nFiles
    clusterMask =  sprintf('thresholdedF_%s_clusterP0p%03d.nii', compQArray{iFile}, 1000*dispOptions.pCluster);
    switch upper(options.representation.blobContrastType)
        case 'F'
            fileMap = sprintf('spmF_%04d.nii',  options.representation.FContrastArray(iFile));
        case 'T'
            fileMap = sprintf('spmT_%04d.nii',  options.representation.TContrastArray(iFile));
    end
    
    switch  dispOptions.displayedMap
        case 'thresholdSPM'
            fileMap = clusterMask; % use thresholded map for all displays
    end
    
    fileArray{iFile} = fullfile(rootStats, compQArray{iFile}, ...
        fileMap);
    clusterMaskArray{iFile} =  fullfile(rootStats, compQArray{iFile}, ...
        clusterMask);
end

colorArray = [
    255 255 0
    0 0 255
    0 255 0
    0 255 255
    255 0 0
    255 0 255
    ]; % this should be the unique color for this cluster, e.g. magenta, red, etc. find out with colorpicker


colorArray = colorArray/255;

switch lower(dispOptions.displayMode)
    case 'volumeviewer'
        nColorsTotal = 256;
    otherwise
        nColorsTotal = 64;
end

% save colormap to restore later
origMap = colormap;

switch options.secondlevelStatsThreshold
    case 'peak'
        significanceThreshold = 0.05; % in this case, u is the p value threshold - in the
        % output xSPM, u will be the stat threshold (e.g.,
        % T value)
        methodCorrection = 'FWE';
    case 'cluster'
        significanceThreshold = 0.001; % in this case, u is the p value threshold - in the
        % output xSPM, u will be the stat threshold (e.g.,
        % T value)
        methodCorrection = 'none'; % has to be 'none', since voxel thresholds used for coloring, cluster level correction enforced post hoc via masking
        contourMethodCorrection = 'FWE'; % for extra contour plot within cluster
        contourSignificanceThreshold = 0.05;
end


%% Plot, loop over files
nFiles = numel(fileArray);
for iFile  = 1:nFiles
    fileMap    = fileArray{iFile};
    fileName   = compQArray{iFile};
    startColor = colorArray(iFile, :); % this should be the unique color for this cluster, e.g. magenta, red, etc. find out with colorpicker
    
    
    [peakVoxel, minStatsValue, maxStatsValue, threshStatsValue] = ...
        dmpad_first_last_significant_time(options,iFile,groupName,significanceThreshold, methodCorrection);
    maxStat    = maxStatsValue;% the max value in your map
    
    if isempty(maxStat) % no surviving voxels)
        maxStat = 1;
    end
    
    % the significance threshold for your multiple comparison correction
    if useManualThresholds
        threshSignificantF = threshSignificantArray(iFile);
    else
        threshSignificantF = threshStatsValue;
    end
    
    switch options.secondlevelStatsThreshold
        case 'peak' % no extra contour needed
            threshContourF = threshSignificantF;
        case 'cluster'
            [~, ~, ~, threshContourF] = ...
                dmpad_first_last_significant_time(options,iFile,groupName, ...
                contourSignificanceThreshold, contourMethodCorrection);
    end
    
    % replace NaN by 0 for proper interpolation in display
    fileMap = remove_nans_from_nii(fileMap);
    fileMapUnsmoothed = fileMap; % needed for proper depiction of peak height in contours for MIP plot, since reduced by smoothing
    fileMapUnsmoothedArray = {{},{},{}}; % re-assigned for MIPs below
    
    if dispOptions.doSmooth
        % smooth here
        load(fullfile(options.coderoot, 'EEG', 'CustomSPMPreprocAnalysis', ...
            'batches', 'smoothThresholdedSpms.mat'), 'matlabbatch');
        matlabbatch{1}.spm.spatial.smooth.data{1} = fileMap;
        spm_jobman('run', matlabbatch);
        
        fileMap = spm_file(fileMap, 'prefix', 's');
        
        % for contours, unsmoothed MIP needed as well!
        % only plotted for cluster level threshold
        if dispOptions.doMIP
            fileMapUnsmoothedArray = compute_mips(fileMapUnsmoothed);
        end
        
        
    end
    
    if dispOptions.doMIP
        fileMapArray = compute_mips(fileMap);
        pfxMapArray = {'mipX_' 'mipY_', 'mipZ_'}; % for saving pngs
    else
        fileMapArray = {fileMap};
        pfxMapArray = {''};
    end
    
    nMaps = numel(fileMapArray);
    
    %% Plot all projections
    for iMap = 1:nMaps
        
        switch lower(dispOptions.displayMode)
            case 'volumeviewer'
                [fh, hv] = dmpad_plot_spm_with_volumeviewer(fileMapArray{iMap}, ...
                    threshSignificantF, maxStat, ...
                    startColor, nColorsTotal);
            case 'checkreg'
                switch lower(options.secondlevelStatsThreshold)
                    case 'cluster'
                        dmpad_plot_map_spm_checkreg_global_max(fileMapArray{iMap}, ...
                            dispOptions.doSmooth, threshSignificantF, maxStat, ...
                            startColor, nColorsTotal, threshContourF, ...
                            fileMapUnsmoothedArray{iMap});
                    case 'peak'
                        % plot as binary mask only, with one color!
                        dmpad_plot_map_spm_checkreg_global_max({}, ...
                            dispOptions.doSmooth, threshSignificantF, maxStat, ...
                            startColor, nColorsTotal, threshContourF, ...
                            fileMapUnsmoothedArray{iMap});
                end
                
                fh = gcf;
            case 'surfaceplot'
                
                myColorMap = dmpad_get_thresholded_colormap( ...
                    threshSignificantF, maxStat, startColor, nColorsTotal);
                
                switch lower(options.secondlevelStatsThreshold)
                    case 'cluster'
                        fh = dmpad_plot_spm_as_surface(fileMapArray{iMap}, myColorMap, ...
                            iMap, options.firstLevelAnalysisWindow, clusterMaskArray{iFile});
                    case 'peak'
                        % no extra 2nd surface for cluster-significant
                        % voxels needed -> peak level needs no cluster mask
                        fh = dmpad_plot_spm_as_surface(fileMapArray{iMap}, myColorMap, ...
                            iMap, options.firstLevelAnalysisWindow);
                end
                
                % adapt labels to reflect what is on current plot
                set(fh, 'Name', sprintf('%s - mipDim%d - %s (%s-FWE corrected)', ...
                    compQArray{iFile}, iMap, get(fh, 'Name'), ...
                    options.secondlevelStatsThreshold));
                
                % adapt title as well, is typically last child of axis
                hc = get(fh, 'Children');
                hc(end).Title.String =  regexprep(get(fh, 'Name'), '_', ' ');
        end
        
        
        %% saving figures
        if dispOptions.doSave
            switch lower(dispOptions.displayMode)
                case 'checkreg'
                    saveName = fullfile(pathSave, [groupName,'_', pfxMapArray{iMap} fileName]);
                    saveas(fh, saveName, 'png')
                case 'surfaceplot'
                    saveName = fullfile(pathSave, [dispOptions.displayMode '_' ...
                        groupName,'_', pfxMapArray{iMap} fileName]);
                    saveas(fh, saveName, 'png')
                case 'volumeviewer'
                    saveName = fullfile(pathSave, [dispOptions.displayMode '_' ...
                        groupName,'_', pfxMapArray{iMap} fileName]);
                    % save with transparency for overlays
                    %        figure;imshow(X.cdata)
                    volumeFrame = getframe(fh);
                    imwrite(volumeFrame.cdata, [saveName '.png'], ...
                        'Transparency', .5*[1 1 1]);
            end
            
            
            
            
        end
        
        
    end
end

% plot once more for volumeviewer to get background box for 3D perspective
switch lower(dispOptions.displayMode)
    case 'volumeviewer'
        % a mask of voxels in GLM
        fh = dmpad_plot_spm_with_volumeviewer(fileMapArray{iMap}, ...
            0.01, 100, [0 0 0], nColorsTotal);
        saveName = fullfile(pathSave, [dispOptions.displayMode '_' ...
            groupName,'_mask.png']);
        volumeFrame = getframe(fh);
        imwrite(volumeFrame.cdata, saveName, 'Transparency', .5*[1 1 1]);
        
        % a cube outlining extent of SPM F-map matrix
        fh = dmpad_plot_spm_with_volumeviewer(fileMapArray{iMap}, ...
            0, 1, [0 0 0], nColorsTotal);
        saveName = fullfile(pathSave, [dispOptions.displayMode '_' ...
            groupName,'_cube.png']);
        volumeFrame = getframe(fh);
        imwrite(volumeFrame.cdata, saveName, 'Transparency', .5*[1 1 1]);
        % volumeViewer close;
end

if dispOptions.doSave && strcmpi(dispOptions.displayMode, 'checkReg')
    colormap gray; % actual origMap is not the gray one SPM uses...
end