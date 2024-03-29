function mnCHR_grandmean_plot_CC(ga, chanName, condNames, options)
%MNKET_GRANDMEAN_PLOT Plots the grand averages of several conditions togehter with their SEM for the
%MNKET study.
%   IN:     ga          - variable with GA and SEM data for all conditions
%           chanName    - string with name of the channel
%           options     - the struct that holds all analysis options


cols = mnCHR_define_colors;

lineColors = [cols.blue; cols.lightred];
lineWidth = 2;

titleStr = [options.hgf.design ' difference waves at ' chanName];
saveName = fullfile(options.roots.figures, ['ga_' options.hgf.design '.fig']);

tnueeg_plot_grandmean_with_sem(ga, titleStr, condNames, saveName, lineColors, lineWidth);

end