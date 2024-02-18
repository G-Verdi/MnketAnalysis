function mnCHR_figure1(minTime, maxTime, chanlabel, regressor, options)


%% Load one example subject data to access time coordinates

details =  feval(options.funs.details, 'C001', options);
D = spm_eeg_load(fullfile(details.dirs.erp, regressor, ['diff_' regressor '_erp_C001.mat']));

% time in ms for x-axis
timeAxisSEC = time(D);
timeAxis = int16(timeAxisSEC*1000); % make into integer for searching purposes

% find index of specified times
minI = find(timeAxis==minTime);
maxI = find(timeAxis==maxTime);

%% Collect Data

% data from both conditions serve as input for drug differences in
% difference waves
for i_group = 1:length(options.subjects.group_labels)
    options.condition = char(options.subjects.group_labels{i_group});

    allChanData = NaN(length(options.subjects.group{i_group}), length(minI:maxI));

    for i_Sub = 1:length(options.subjects.group{i_group})

        subData = [];

        for iCh = 1: numel(chanlabel)
            channel = char(chanlabel{iCh});
    
            group = load(fullfile(options.roots.erp, ...
                options.condition, regressor, 'GA', [channel '_ga.mat']));

            subData = [subData; group.ga.diff.data(i_Sub, :)];
    
        end

        allChanData(i_Sub, :) = mean(subData(:, minI:maxI));
    
    end

    allChanData = allChanData';

    diffData.(options.condition).data = allChanData;
    diffData.(options.condition).mean = mean(allChanData);
    diffData.(options.condition).std = std(allChanData);
    diffData.(options.condition).nsubjects = length(options.subjects.group{i_group});
    diffData.(options.condition).error = std(allChanData)/diffData.(options.condition).nsubjects;
    diffData.(options.condition).time = group.ga.diff.time;

end


%% -- Figure ---------------------------------------------------%
fh = figure; hold on;
grid on;

figTitlelowIQ = "Difference Amplitude between " + ...
                    minTime + "-" + maxTime + "ms";
ylabel('Field intensity (in uV)');
title(figTitlelowIQ)

x_ax1 = ones(1, length(diffData.(options.subjects.group_labels{1}).mean));
x_ax2 = 2*ones(1, length(diffData.(options.subjects.group_labels{2}).mean));

xticks([0 1 2 3])
xticklabels({'','Low Role','High Role', ''})
xlim([0 3])

scatter(x_ax1, diffData.(options.subjects.group_labels{1}).mean, 'filled')
scatter(1, mean(diffData.(options.subjects.group_labels{1}).mean), 'filled', 'r')

scatter(x_ax2, diffData.(options.subjects.group_labels{2}).mean, 'filled')
scatter(2, mean(diffData.(options.subjects.group_labels{2}).mean), 'filled', 'r')

plot([1 2], [mean(diffData.(options.subjects.group_labels{1}).mean) mean(diffData.(options.subjects.group_labels{2}).mean)], 'r', 'LineWidth',2)

%% Test if significant difference

[h, p] = ttest2(diffData.(options.subjects.group_labels{1}).mean, diffData.(options.subjects.group_labels{2}).mean);
if h == 0
    display(['No signiticant difference. p = ' num2str(p)])
end

if h == 1
    display(['Signiticant difference. p = ' num2str(p)]) 
end

end
