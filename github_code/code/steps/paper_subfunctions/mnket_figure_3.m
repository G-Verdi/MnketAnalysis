function [ data ] = mnket_figure_3( options, savePath )
%MNKET_FIGURE_3 Collects all images and data points needed to create figure 3 of paper: modelbased
%2ndlevel results for placebo condition
%   IN:     options     - the struct that holds all analysis options
%           savePath    - where to save the images and data

[~, paths] = mnket_subjects(options);

figPath = fullfile(savePath, 'figure_3');
mkdir(figPath);

% collect data for fig. 3A: epsilon2 in placebo
resultsDir = fullfile(paths.statfold, 'epsi2');
figDir = fullfile(figPath, 'epsi2');
mkdir(figDir);

% for epsilon2, we're showing 1 cluster (out of 1)
copyfile(fullfile(resultsDir, 'conF_sections', 'sections_F_plevel_FWE_p0.05_cluster1_k1216.png'), ...
    figDir);
copyfile(fullfile(resultsDir, 'conF_contours', 'sections_F_plevel_FWE_p0.05_cluster1_k1216.png'), ...
    figDir);
copyfile(fullfile(resultsDir, 'conF_scalpmaps', 'scalpmaps_spmF_0003_ft_cluster1_tw_109ms_to_164ms.png'), ...
    figDir);
%copyfile(fullfile(resultsDir, 'conF_scalpmaps', 'colmap_scalpmaps_spmF_0003_clevel_ft_cluster1_at_121ms.png'), ...
    %figDir);

con = getfield(load(fullfile(resultsDir, 'con_F_peakFWE.mat')), 'con');

data.epsi2.peak      = con.clusters.peak;
data.epsi2.timewin   = con.clusters.timewin;


% collect data for fig. 3B: epsilon3 in placebo
resultsDir = fullfile(paths.statfold, 'epsi3');
figDir = fullfile(figPath, 'epsi3');
mkdir(figDir);

% for epsilon3, we're showing clusters 2 and 3 (out of 3)
copyfile(fullfile(resultsDir, 'conF_sections', 'sections_F_plevel_FWE_p0.05_cluster1_k180.png'), ...
    figDir);
copyfile(fullfile(resultsDir, 'conF_contours', 'sections_F_plevel_FWE_p0.05_cluster1_k180.png'), ...
    figDir);
copyfile(fullfile(resultsDir, 'conF_scalpmaps', 'scalpmaps_spmF_0003_ft_cluster1_tw_180ms_to_184ms.png'), ...
    figDir);
copyfile(fullfile(resultsDir, 'conF_scalpmaps', 'scalpmaps_spmF_0003_ft_cluster3_tw_266ms_to_266ms.png'), ...
    figDir);
%copyfile(fullfile(resultsDir, 'conF_scalpmaps', 'colmap_scalpmaps_spmF_0003_clevel_ft_cluster3_at_180ms.png'), ...
    %figDir);

con = getfield(load(fullfile(resultsDir, 'con_F_peakFWE.mat')), 'con');

data.epsi3.peak1      = con.clusters(3).peak;
data.epsi3.timewin1   = con.clusters(3).timewin;

data.epsi3.peak2      = con.clusters(2).peak;
data.epsi3.timewin2   = con.clusters(2).timewin;

save(fullfile(figPath, 'figdata.mat'), 'data');

end

