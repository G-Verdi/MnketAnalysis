function [ data ] = mnket_figure_4( options, savePath )
%MNKET_FIGURE_4 Collects all images and data points needed to create figure 4 of paper: modelbased
%2ndlevel results for drug difference
%   IN:     options     - the struct that holds all analysis options
%           savePath    - where to save the images and data

[~, paths] = mn_subjects(options);

figPath = fullfile(savePath, 'figure_4');
mkdir(figPath);

% collect data for fig. 4A: drugdiff on epsilon2
resultsDir = fullfile(paths.statdifffold, 'pihat1');
figDir = fullfile(figPath, 'pihat1');
mkdir(figDir);

% for epsilon2, we're showing the section of the T map (SPM) centered on its peak, which is not
% significant (so no cluster overlaid, no scalpmap, no colormap)
fileName = fullfile(resultsDir, 'sections_T_ns');
if ~exist([fileName '.png'], 'file')
    spm_check_registration(fullfile(resultsDir, 'spmT_0001.nii'));
    spm_orthviews('goto_max', 'global', 1);
    peak = spm_orthviews('pos');
    peakPos = spm_orthviews('pos', 1);
    global st
    tMax = spm_sample_vol(st.vols{1}, peakPos(1), peakPos(2), peakPos(3), st.hld);
    fhImg = gcf;
    spm_figure('ColorMap', 'jet');
    
    spm_orthviews('Xhairs', 'on')
    print(fhImg, [fileName '_cross.png'], '-dpng', '-r600');
    
    spm_orthviews('Xhairs', 'off')
    print(fhImg, [fileName '.png'], '-dpng', '-r600');

    close(fhImg);
    clear st
    
    save(fullfile(resultsDir, 'peakTvalue.mat'), 'peak', 'tMax');
end
copyfile([fileName '.png'], figDir);
load(fullfile(resultsDir, 'peakTvalue.mat'));

data.pihat1.peak = peak;
data.pihat1.tmax = tMax;


% collect data for fig. 3B: epsilon3 in placebo
resultsDir = fullfile(paths.statdifffold, 'pihat2');
figDir = fullfile(figPath, 'pihat2');
mkdir(figDir);

% for epsilon3, we're showing 1 significant cluster (out of 1)
copyfile(fullfile(resultsDir, 'conT_sections', 'sections_T_plevel_FWE_p0.05_cluster1_k59.png'), ...
    figDir);
copyfile(fullfile(resultsDir, 'conT_contours', 'sections_T_plevel_FWE_p0.05_cluster1_k59.png'), ...
    figDir);
copyfile(fullfile(resultsDir, 'conT_scalpmaps', 'scalpmaps_spmT_0001_ft_cluster1_tw_160ms_to_160ms.png'), ...
    figDir);
%copyfile(fullfile(resultsDir, 'conT_scalpmaps', 'colmap_scalpmaps_spmT_0001_clevel_ft_cluster1_at_223ms.png'), ...
    %figDir);

con = getfield(load(fullfile(resultsDir, 'con_T_peakFWE.mat')), 'con');

data.pihat2.peak     = con.clusters.peak;
data.pihat2.timewin  = con.clusters.timewin;


% save all paper-relevant data for this figure
save(fullfile(figPath, 'figdata.mat'), 'data');

end

