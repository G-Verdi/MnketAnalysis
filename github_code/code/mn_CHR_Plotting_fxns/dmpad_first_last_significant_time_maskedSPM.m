function [peakVoxel,minStatsValue, maxStatsValue, threshStatsValue] = dmpad_first_last_significant_time_maskedSPM(options,iRegressor, group,...
    significanceThreshold, methodCorrection)

if nargin < 3
    group = options.part;
end

if nargin < 4
    significanceThreshold = 0.001;
end

if nargin < 5
    methodCorrection = 'none';
end



% Script for extracting first and last significant time point (i.e., z
% value) for a significant activation blob in SPM for EEG. What you need
% is:
% - an estimated SPM.mat
% - a height threshold ('FWE', 'none', and p-value)
% - an extent threshold (k - minimum number of voxels per blob) - this needs to
% result in only one blob surviving (or, if more blobs survive, you need to
% know that this script extracts the first significant time point of the
% first blob and the last significant time point of the last blob).

%% Evaluated fields in xSPM (input)
%
% xSPM      - structure containing SPM, distribution & filtering details
% .swd      - SPM working directory - directory containing current SPM.mat
% .title    - title for comparison (string)
% .Ic       - indices of contrasts (in SPM.xCon)
% .n        - conjunction number <= number of contrasts
% .Im       - indices of masking contrasts (in xCon)
% .pm       - p-value for masking (uncorrected)
% .Ex       - flag for exclusive or inclusive masking
% .u        - height threshold
% .k        - extent threshold {voxels}
% .thresDesc - description of height threshold (string)
%% Possible other fields of xSPM:
%
% .Z        - minimum of Statistics {filtered on u and k}
% .n        - conjunction number <= number of contrasts
% .STAT     - distribution {Z, T, X, F or P}
% .df       - degrees of freedom [df{interest}, df{residual}]
% .STATstr  - description string
% .Ex       - flag for exclusive or inclusive masking
% .XYZ      - location of voxels {voxel coords}
% .XYZmm    - location of voxels {mm}
% .S        - search Volume {voxels}
% .R        - search Volume {resels}
% .FWHM     - smoothness {voxels}
% .M        - voxels -> mm matrix
% .iM       - mm -> voxels matrix
% .VOX      - voxel dimensions {mm} - column vector
% .DIM      - image dimensions {voxels} - column vector
% .Vspm     - Mapped statistic image(s)
% .Ps       - uncorrected P values in searched volume (for voxel FDR)
% .Pp       - uncorrected P values of peaks (for peak FDR)
% .Pc       - uncorrected P values of cluster extents (for cluster FDR)
% .uc       - 0.05 critical thresholds for FWEp, FDRp, FWEc, FDRc
% .thresDesc - description of height threshold (string)


% created by Lilian Weber & Andreea Diaconescu

switch group
    case 'Placebo'
        extentThreshArray=  [22.00 25.00 28.00 17.00 13.24 20.00];
    case 'Amisulpride'
        extentThreshArray=  [];
    case 'Levodopa'
        extentThreshArray=  [];
end
rootStats  = options.secondlevelPredictionsversusUpdates.Dir; 
compQArray = options.secondlevelPredictionsversusUpdates.secondlevelArray(1:end);
switch lower(options.representation.blobContrastType)
    case 't'
        iContrastArray   =  options.representation.TContrastArray;
    case 'f'
        iContrastArray   =  options.representation.FContrastArray;
end

% query SPM.mat in interactive mode (select via GUI) or use predefined xSPM struct
queryMode = 'xSPM'; % 'xSPM' or 'gui'

% get xSPM struct containing all significant voxels and their coordinates
nFiles = numel(compQArray);

switch queryMode
    case 'gui'
        [SPM, xSPM] = spm_getSPM;
    case 'xSPM'
        % set directory containing the SPM.mat
        spm_mat_root = [rootStats, '/', compQArray{iRegressor}];
        
        % setup xSPM input struct
        
        xSPM.swd = spm_mat_root;
        xSPM.title = compQArray(iRegressor);
        xSPM.Ic = iContrastArray(iRegressor);
        xSPM.n = 1;
        xSPM.Im = [];
        xSPM.pm = [];
        xSPM.Ex = [];
        xSPM.u = significanceThreshold; % in this case, u is the p value threshold - in the
        % output xSPM, u will be the stat threshold (e.g.,
        % T value)
        xSPM.k = 0; % extentThreshArray(iFile);
        xSPM.thresDesc = methodCorrection;
        [SPM, xSPM] = spm_getSPM(xSPM);
end
% find first and last significant voxels
sigVoxels     = xSPM.XYZmm;
sigTimePoints = sigVoxels(3, :);
[maxStatsValue, iStatsValue] = max(xSPM.Z);
minStatsValue = min(xSPM.Z);
threshStatsValue = xSPM.u;
lastVoxel     = max(sigTimePoints);
firstVoxel    = min(sigTimePoints);
peakVoxel     = sigTimePoints(iStatsValue);

% display
disp('first significant time point of activation:');
disp(firstVoxel);
disp('last significant time point of activation:');
disp(lastVoxel);
disp('peak time point of activation:');
disp(peakVoxel);
disp('max STATS:');
disp(maxStatsValue);
disp('min STATS:');
disp(minStatsValue);
disp('threshold of statistic for significance:');
disp(threshStatsValue);

% save this info
save([spm_mat_root '/sig_time_window.mat'], 'peakVoxel', 'firstVoxel', 'lastVoxel', ...
    'minStatsValue', 'maxStatsValue', 'threshStatsValue', 'xSPM');


