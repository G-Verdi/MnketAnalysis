function mnCHR_figure2(chanlabel, regressor, options)


%% Collect Data

% data from both conditions serve as input for drug differences in
% difference waves
for i_group = 1:length(options.subjects.group_labels)
    options.condition = char(options.subjects.group_labels{i_group});
    
    allChanData.(options.condition).data = [];
    for iCh = 1: numel(chanlabel)
        channel = char(chanlabel{iCh});

        group = load(fullfile(options.roots.erp, ...
            options.condition, regressor, 'GA', [channel '_ga.mat']));
  
        allChanData.(options.condition).data = ...
            [allChanData.(options.condition).data; group.ga.diff.data];
    end

    diffData.(options.condition).mean = mean(allChanData.(options.condition).data);
    diffData.(options.condition).std = std(allChanData.(options.condition).data);
    diffData.(options.condition).nsubjects = length(options.subjects.group{i_group});
    diffData.(options.condition).error = std(allChanData.(options.condition).data)/diffData.(options.condition).nsubjects;
    diffData.(options.condition).time = group.ga.diff.time;

end

%% -- Figure ---------------------------------------------------%

mnCHR_grandmean_plot_CC(diffData, chanlabel, options.subjects.group_labels, options)

end
