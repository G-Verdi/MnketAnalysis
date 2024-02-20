function [ data ] = mnket_figure_s1( options, savePath )
%MNKET_FIGURE_S1 Generates Matlab versions of the figures illustrating the model simulations for the
% paper and extracts the data in the right format for subsequent gnuplot plotting.
%   IN:     options     - the struct that holds all analysis options
%           savePath    - where to save the figure data
%   OUT:    -

options.stats.design = 'epsilon';
figPath = fullfile(savePath, 'figure_s1');
mkdir(figPath);

% choose an example subject
options.condition = 'placebo';
details = mnket_subjects('4422', options);

% load the simulation data
subjDesign = getfield(load(details.design), 'design');
simResults = getfield(load(details.simfilepost), 'sim');

% do the plots
fh1 = mnket_plot_belief_trajectories(simResults);
savefig(fh1, fullfile(figPath, 'figure_s1_a.fig'));
fh2 = mnket_plot_prediction_errors_alltrials(simResults, subjDesign);
savefig(fh1, fullfile(figPath, 'figure_s1_b.fig'));
fh3 = mnket_plot_prediction_errors_detailed(simResults, subjDesign);
savefig(fh1, fullfile(figPath, 'figure_s1_c.fig'));

% extract the data for gnuplot
mnket_extract_gnuplot_data_simulation_figs(simResults, subjDesign, figPath);

data.exampleID  = '4422';
data.condition  = 'placebo';
data.sim        = simResults;
data.design     = subjDesign;

end