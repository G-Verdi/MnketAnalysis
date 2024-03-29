function [ paper ] = mn_pull_paper_data( options )
%MN_PULL_PAPER_DATA Collects all data presented in the paper about the MNKET/MNPSI study.
%   IN:     options     - the struct that holds all analysis options
%   OUT:    ppr         - a struct with paper results

if nargin < 1 
    options = mn_set_analysis_options;
end

mkdir(fullfile(options.workdir, 'paperdata'));
mainpath = fullfile(options.workdir, 'paperdata', 'main');
suppath = fullfile(options.workdir, 'paperdata', 'supplementary');

%% Main results
mkdir(mainpath);

% Figure 3: Main effects of factorial ANOVA results.
% This figure needs the section overlays and scalpmaps for all significant 2nd level effects of the
% modelbased analysis under placebo shown. Additionally, it requires information on the start and 
% end of the significant time windows of those. Note that we only show two out of three clusters for 
% epsilon3.
paper.figure3 = mnket_figure_3(options, mainpath);

% Figure 4: Drug effects for ANOVA.
% This figure needs the section overlay and scalpmap for the significant cluster of increased effect
% of epsilon3 under placebo vs. ketamine (drugdiff). Additionally, it requires information on the 
% start and end of the significant time window of that cluster.
paper.figure4 = mnket_figure_4(options, mainpath);



















%% Supplementary data
mkdir(suppath);
