function [ data ] = mnket_figure_3( options, savePath )
%MNKET_FIGURE_3 Collects all images and data points needed to create figure 3 of paper: modelbased
%2ndlevel results for placebo condition
%   IN:     options     - the struct that holds all analysis options
%           savePath    - where to save the images and data


[~, paths] = mn_subjects(options);

figPath = fullfile(savePath, 'figure_3');
mkdir(figPath);

% collect data for fig. 3A: epsilon2 in placebo
resultsDir = fullfile(paths.statfold, 'epsilon2');
figDir = fullfile(figPath, 'epsilon2');
mkdir(figDir);

% for epsilon2, we're showing 1 cluster (out of 1)
copyfile(fullfile(resultsDir, 'conF_sections', 'sections_F_plevel_FWE_p0.05_cluster1_k83.png'), ...
    figDir);
copyfile(fullfile(resultsDir, 'conF_contours', 'sections_F_plevel_FWE_p0.05_cluster1_k83.png'), ...
    figDir);
copyfile(fullfile(resultsDir, 'conF_scalpmaps', 'scalpmaps_spmF_0003_ft_cluster1_tw_152ms_to_152ms.png'), ...
    figDir);
%copyfile(fullfile(resultsDir, 'conF_scalpmaps', 'colmap_scalpmaps_spmF_0003_clevel_ft_cluster1_at_121ms.png'), ...
    %figDir);

con = getfield(load(fullfile(resultsDir, 'con_F_peakFWE.mat')), 'con');

data.pihat1.peak      = con.clusters.peak;
data.pihat1.timewin   = con.clusters.timewin;


% collect data for fig. 3B: epsilon3 in placebo
resultsDir = fullfile(paths.statfold, 'pihat2');
figDir = fullfile(figPath, 'pihat2');
mkdir(figDir);

% for epsilon3, we're showing clusters 2 and 3 (out of 3)
copyfile(fullfile(resultsDir, 'conF_sections', 'sections_F_plevel_FWE_p0.05_cluster1_k45.png'), ...
    figDir);
copyfile(fullfile(resultsDir, 'conF_contours', 'sections_F_plevel_FWE_p0.05_cluster1_k45.png'), ...
    figDir);
copyfile(fullfile(resultsDir, 'conF_scalpmaps', 'scalpmaps_spmF_0003_ft_cluster1_tw_176ms_to_176ms.png'), ...
    figDir);
% copyfile(fullfile(resultsDir, 'conF_scalpmaps', 'scalpmaps_spmF_0003_ft_cluster3_tw_164ms_to_164ms.png'), ...
%     figDir);
%copyfile(fullfile(resultsDir, 'conF_scalpmaps', 'colmap_scalpmaps_spmF_0003_clevel_ft_cluster3_at_180ms.png'), ...
    %figDir);

con = getfield(load(fullfile(resultsDir, 'con_F_peakFWE.mat')), 'con');


% data.pihat2.peak1      = con.clusters(3).peak;
% data.pihat2.timewin1   = con.clusters(3).timewin;

data.pihat2.peak2      = con.clusters(1).peak;
data.pihat2.timewin2   = con.clusters(1).timewin;


save(fullfile(figPath, 'figdata.mat'), 'data');

end

