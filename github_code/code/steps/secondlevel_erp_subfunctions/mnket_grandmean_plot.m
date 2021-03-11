function mnket_grandmean_plot(ga, chanName, options, flag)
%MNKET_GRANDMEAN_PLOT Plots the grand averages of several conditions togehter with their SEM for the
%MNKET study.
%   IN:     ga          - variable with GA and SEM data for all conditions
%           chanName    - string with name of the channel
%           options     - the struct that holds all analysis options

if nargin < 4
    flag = '';
end

if nargin < 3
    options = mnket_set_analysis_options;
end

[~, paths] = mnket_subjects(options);

cols = mnket_define_colors;

switch flag
    case 'drugdiff'
        
        % Gather plotting info
        switch options.erp.type
            case {'mmnad', 'roving', 'lowhighEpsi2', 'lowhighEpsi3','lowhighMuhat1','lowhighMuhat3','lowhighSahat1'}
                titleStr = [options.erp.type ' difference waves at ' chanName];
            case 'tone'
                titleStr = [options.erp.type ' ERPs at ' chanName];
        end

        condNames = {'placebo', 'ketamine'};
        lineColors = [cols.darkgray; cols.medgray];
        lineWidth = 2;
        saveName = fullfile(paths.erpdiffold, ['ga_sem_' options.erp.type '_' chanName '.fig']);

    otherwise

        % Gather plotting info
        titleStr = [options.erp.type ' ERPs at ' chanName ' in ' options.condition];

        switch options.erp.type
            case {'mmnad', 'roving'}
                condNames = {'standard', 'deviant'};
                lineColors = [cols.medgray; cols.lightred];
                lineWidth = 2;
            case {'lowhighEpsi2', 'lowhighEpsi3','diffWaves'}
                condNames = {'low', 'high'};
                lineColors = [cols.medgray; cols.lightred; cols.lightgreen];
                lineWidth = 3;  
            case {'lowhighMuhat1','lowhighMuhat3','lowhighSahat','diffWaves'}
                condNames = {'low', 'high'};
                lineColors = [cols.medgray; cols.lightred; cols.lightgreen];
                lineWidth = 3;  
            case 'tone'
                condNames = {'tone'};
                lineColors = [cols.darkgray];
                lineWidth = 2;
        end

        saveName = fullfile(paths.erpfold, ['ga_sem_' options.erp.type '_' chanName '.fig']);
end

% Call tnueeg plot function
tnueeg_plot_grandmean_with_sem(ga, titleStr, condNames, saveName, lineColors, lineWidth);

