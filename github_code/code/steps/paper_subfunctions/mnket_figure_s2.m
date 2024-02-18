function [ data ] = mnket_figure_s2( options, savePath )
%MNKET_FIGURE_S2 Collects all images and data points needed to create supplementary figure S2 of 
%paper: modelbased 2ndlevel results for ketamine condition
%   IN:     options     - the struct that holds all analysis options
%           savePath    - where to save the images and data

options.condition = 'ketamine';
[~, paths] = mnket_subjects(options);

figPath = fullfile(savePath, 'figure_s2');
mkdir(figPath);

% collect data for fig. S2A: epsilon2 in ketamine
resultsDir = fullfile(paths.statfold, 'epsi2');
figDir = fullfile(figPath, 'epsi2');
mkdir(figDir);

% for epsilon2, we're showing 2 cluster (out of 2)
copyfile(fullfile(resultsDir, 'conF_sections', 'sections_F_plevel_FWE_p0.05_cluster1_k214.png'), ...
    figDir);
copyfile(fullfile(resultsDir, 'conF_sections', 'sections_F_plevel_FWE_p0.05_cluster2_k250.png'), ...
    figDir);
copyfile(fullfile(resultsDir, 'conF_contours', 'sections_F_plevel_FWE_p0.05_cluster1_k214.png'), ...
    figDir);
copyfile(fullfile(resultsDir, 'conF_contours', 'sections_F_plevel_FWE_p0.05_cluster2_k250.png'), ...
    figDir);
copyfile(fullfile(resultsDir, 'conF_scalpmaps', 'scalpmaps_spmF_0003_ft_cluster1_tw_141ms_to_141ms.png'), ...
    figDir);
copyfile(fullfile(resultsDir, 'conF_scalpmaps', 'scalpmaps_spmF_0003_ft_cluster2_tw_125ms_to_137ms.png'), ...
    figDir);
%copyfile(fullfile(resultsDir, 'conF_scalpmaps', 'colmap_scalpmaps_spmF_0003_clevel_ft_cluster1_at_141ms.png'), ...
    %figDir);

con = getfield(load(fullfile(resultsDir, 'con_F_peakFWE.mat')), 'con');

data.epsi2.peak1    = con.clusters(1).peak;
data.epsi2.timewin1 = con.clusters(1).timewin;
data.epsi2.peak2    = con.clusters(2).peak;
data.epsi2.timewin2 = con.clusters(2).timewin;


% collect data for fig. S2B: epsilon3 in ketamine
resultsDir = fullfile(paths.statfold, 'epsi3');
figDir = fullfile(figPath, 'epsi3');
mkdir(figDir);

% for epsilon3, we're showing clusters 1-4 (out of 4), on sections for clusters 4 and 2
copyfile(fullfile(resultsDir, 'conF_sections', 'sections_F_plevel_FWE_p0.05_cluster2_k3.png'), ...
    figDir);
copyfile(fullfile(resultsDir, 'conF_sections', 'sections_F_plevel_FWE_p0.05_cluster3_k1.png'), ...
    figDir);
copyfile(fullfile(resultsDir, 'conF_contours', 'sections_F_plevel_FWE_p0.05_cluster2_k3.png'), ...
    figDir);
copyfile(fullfile(resultsDir, 'conF_contours', 'sections_F_plevel_FWE_p0.05_cluster3_k1.png'), ...
    figDir);
copyfile(fullfile(resultsDir, 'conF_scalpmaps', 'scalpmaps_spmF_0003_ft_cluster1_tw_160ms_to_160ms.png'), ...
    figDir);
copyfile(fullfile(resultsDir, 'conF_scalpmaps', 'scalpmaps_spmF_0003_ft_cluster2_tw_398ms_to_398ms.png'), ...
    figDir);
copyfile(fullfile(resultsDir, 'conF_scalpmaps', 'scalpmaps_spmF_0003_ft_cluster3_tw_188ms_to_188ms.png'), ...
    figDir);
%copyfile(fullfile(resultsDir, 'conF_scalpmaps', 'scalpmaps_spmF_0003_clevel_ft_cluster4_at_207ms.png'), ...
    %figDir);
%copyfile(fullfile(resultsDir, 'conF_scalpmaps', 'colmap_scalpmaps_spmF_0003_clevel_ft_cluster1_at_398ms.png'), ...
    %figDir);

con = getfield(load(fullfile(resultsDir, 'con_F_peakFWE.mat')), 'con');

data.epsi3.peak1      = con.clusters(3).peak;
data.epsi3.timewin1   = con.clusters(3).timewin;

data.epsi3.peak2      = con.clusters(2).peak;
data.epsi3.timewin2   = con.clusters(2).timewin;

save(fullfile(figPath, 'figdata.mat'), 'data');

end

