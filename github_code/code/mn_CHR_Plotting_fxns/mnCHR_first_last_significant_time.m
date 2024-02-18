function [peakVoxel,minStatsValue, maxStatsValue, threshStatsValue] = ...
            mnCHR_first_last_significant_time(options,regName, significanceThreshold, methodCorrection)


disp(['Computing SPM stats']);

switch options.stats.mode
    case 'modelbased'
        spmRoot = fullfile(options.roots.model, options.condition, ...
                regName);
    case 'diffWaves'
        spmRoot = fullfile(options.roots.erp, options.condition, ...
                regName, 'SPM');
end

contrastTitle = 'Effect of ';
contrastIdx = 3;
nVoxMin = 1;

xSPM = struct;
xSPM.swd      = spmRoot;
xSPM.title    = [contrastTitle regName];
xSPM.Ic       = contrastIdx;
xSPM.n        = 1;
xSPM.Im       = [];
xSPM.pm       = [];
xSPM.Ex       = [];
xSPM.u        = significanceThreshold;
xSPM.k        = 0;
xSPM.thresDesc = methodCorrection;

xSPM = mnCHR_write_table_results(xSPM, ...
    options.stats.pValueMode, false, nVoxMin);

%-- find first and last significant voxels ----------------------------%
sigVoxels     = xSPM.XYZmm;
sigTimePoints = sigVoxels(3, :);
[maxStatsValue, iStatsValue] = max(xSPM.Z);
minStatsValue = min(xSPM.Z);
threshStatsValue = xSPM.u;
lastVoxel     = max(sigTimePoints);
firstVoxel    = min(sigTimePoints);
peakVoxel     = sigTimePoints(iStatsValue);


end