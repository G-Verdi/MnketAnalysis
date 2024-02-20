function [ paper ] = mnket_pull_paper_data( options )
%MNKET_PULL_PAPER_DATA Collects all data presented in the paper about the MNKET study.
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

% Figure 1: The perceptual model.
% This figure does not depend on any experimental data.

% Figure 2: Analysis pipeline.
% Same as for figure 1. 

% Figure 3: Modelbased results for placebo condition.
% This figure needs the section overlays and scalpmaps for all significant 2nd level effects of the
% modelbased analysis under placebo shown. Additionally, it requires information on the start and 
%end of the significant time windows of those. Note that we only show two out of three clusters for 
% epsilon3.
paper.figure3 = mnket_figure_3(options, mainpath);

% Figure 4: Difference Placebo - Ketamine in epsilon3.
% This figure needs the section overlay and scalpmap for the significant cluster of increased effect
% of epsilon3 under placebo vs. ketamine (drugdiff). Additionally, it requires information on the 
% start and end of the significant time window of that cluster.
paper.figure4 = mnket_figure_4(options, mainpath);

% Table 1: Modelbased results for placebo condition.
% This table needs the summary tables (.csv files) for both epsilon2 and epsilon3.
paper.table1 = mnket_table_1(options, mainpath);

% Table 2: Modelbased results for ketamine condition.
paper.table2 = mnket_table_2(options, mainpath);

% Table 3: Difference Placebo - Ketamine in epsilon3.
paper.table3 = mnket_table_3(options, mainpath);


%% Supplementary Results
mkdir(suppath);

% Figure S1: Simulation results.
paper.suppl.figureS1 = mnket_figure_s1(options, suppath);

% Figure S2: Modelbased results for ketamine condition.
% This figure needs the section overlays and scalpmaps for all significant 2nd level effects of the
% modelbased analysis under ketamine. Additionally, it requires information on the start and end of
% the significant time windows.
paper.suppl.figureS2 = mnket_figure_s2(options, suppath);

% Table S1: Parameter Priors.
paper.suppl.tableS1 = mnket_table_s1(suppath);

% Table S2: Parameter Statistics.
paper.suppl.tableS1 = mnket_table_s2(options, suppath);

%%%%%% For supplementary tables S3 and S4, please re-run the 2nd level analysis:
%%%%%% mnket_2ndlevel_modelbased;
%%%%%% mnket_results_report_modelbased;
%%%%%% without participant 4497 (change the options.subjects.all field accordingly) for table S3
%%%%%% without the swap-datasets ('4520', '4534', '4422', '4488') for table S4
%%%%%% and then use the same function as for table 3 of the main paper.

%% Other data reported in the paper
% Methods: Trial statistics (Section EXPERIMENTAL PROCEDURE AND DATA PREPROCESSING)
[~, paths] = mn_subjects(options);
trialStatsAll = getfield(load(paths.trialstats_summary_all), 'summary1');
paper.methods.nGoodTrials.Placebo = trialStatsAll.nGoodTrialsTone.mean(1);
paper.methods.nGoodTrials.ketamine = trialStatsAll.nGoodTrialsTone.mean(2);
paper.methods.nGoodTrials.sd_Placebo = trialStatsAll.nGoodTrialsTone.sd(1);
paper.methods.nGoodTrials.sd_ketamine = trialStatsAll.nGoodTrialsTone.sd(2);


% Supplementary methods: Bad channels (Section Preprocessing of EEG data)
options.condition = 'placebo';
[~, paths] = mn_subjects(options);
load(paths.trialstatstab);
paper.supplmethods.nBadChannels.Placebo = trialStatsTable.nBadChannels;

options.condition = 'ketamine';
[~, paths] = mn_subjects(options);
load(paths.trialstatstab);
paper.supplmethods.nBadChannels.ketamine = trialStatsTable.nBadChannels;



%% save everything
save(fullfile(options.workdir, 'paperdata', 'allPaperData.mat'), 'paper');

close all;


end

