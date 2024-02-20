function [ reg ] = mnket_plot_prediction_errors(sim, design)

% load example subject's data:
% load('data/subjects/placebo/MMN_4422/model/reg.mat')
% load('data/subjects/placebo/MMN_4422/model/epsilon_design.mat')
npt = 50;

inp = sim.u;
%inpo = sim.u_orig;
nTrials = length(inp);

dev = get_deviant_positions(inp);
pre = get_preceding_standards(dev);
pre(1) = pre(1) + 1;
nDev = length(dev);
nPre = max(pre);

% regressors
reg.epsilon2 = design.epsilon2;
reg.epsilon2(1) = [];
reg.epsilon3 = design.epsilon3;
reg.epsilon3(1) = [];

% deviant trial regressors
deviant.epsilon2 = reg.epsilon2(dev);
deviant.epsilon3 = reg.epsilon3(dev);

% setup sim matrices for correlations
%{
mat(:, 1) = reg.bayesian;
mat(:, 2) = reg.epsilon3;
mat(:, 3) = reg.shannon;

devmat(:, 1) = deviant.bayesian;
devmat(:, 2) = deviant.epsilon3;
devmat(:, 3) = deviant.shannon;
%}

% effect of standards
measures = fieldnames(deviant);
for me = 1: numel(measures)
    for p = 1: max(pre)
        effect.(measures{me})(p) = mean(deviant.(measures{me})(pre == p));
    end
end

% collect results
reg.effect = effect;
reg.deviant = deviant;

%% plot

figure('Name', 'Deviant regressors');
title('Regressors on deviant trials');

subplot(2, 1, 1);
plot(1: numel(dev), reg.deviant.epsilon3, 'o', 'Color', [0 0 0.5], 'LineWidth', 2); 
title('Higher-level PE');

subplot(2, 1, 2);
plot(1: numel(dev), reg.deviant.epsilon2, '+', 'Color', [0 0.5 0], 'LineWidth', 2); 
title('Lower-level PE');


for me = 1: numel(measures)
    figure('Name', measures{me});
    
    subplot(3, 2, 1); plot(1: npt, inp(1:npt), '.k'); title('Tones (Beginning of session)');
    subplot(3, 2, 3); plot(1: npt, reg.(measures{me})(1:npt), '.r'); title([measures{me} ': Beginning of session']);
    
    subplot(3, 2, 2); plot(nTrials-npt+1:nTrials, inp((end-npt+1):end), '.k'); title('Tones (End of session)'); %xlim([0 npt]);
    subplot(3, 2, 4); plot(nTrials-npt+1:nTrials, reg.(measures{me})((end-npt+1):end), '.r'); title([measures{me} ': End of session']); %xlim([0 npt]);

    subplot(3, 2, 5); plot(1: numel(dev), reg.deviant.(measures{me}), '.b'); title([measures{me} ': Deviant trials']);
    subplot(3, 2, 6); plot(1: max(pre), effect.(measures{me}), '^g', 'MarkerSize', 5, 'MarkerFaceColor', 'g'); title([measures{me} ': Effect of preceding standards']); xlim([0 11]);
end

figure('Name', 'Prediction Errors');
    
subplot(2, 1, 1);
plot(1: numel(reg.epsilon3), reg.epsilon3, '+', 'Color', [0 0 0.5], 'LineWidth', 2); 
title('Higher-level PE');

subplot(2, 1, 2);
plot(1: numel(reg.epsilon3), reg.epsilon2, '+', 'Color', [0 0.5 0], 'LineWidth', 2); 
title('Lower-level PE');

% Correlations amongst regressors: all trials

figure('Name', 'Simulation: Prediction Errors');
    
subplot(3, 2, 1); plot(1: npt, inp(1:npt), '.k'); title('Tones (Beginning of session)');
subplot(3, 2, 2); plot(nTrials-npt+1:nTrials, inp((end-npt+1):end), '.k'); title('Tones (End of session)'); %xlim([0 npt]);

subplot(3, 2, 3); plot(1: npt, reg.epsilon3(1:npt), '.r'); title('Epsilon3: Beginning of session');
subplot(3, 2, 4); plot(nTrials-npt+1:nTrials, reg.epsilon3((end-npt+1):end), '.r'); title('Epsilon3: End of session'); %xlim([0 npt]);

subplot(3, 2, 5); plot(1: npt, reg.epsilon2(1:npt), '.r'); title('Epsilon2: Beginning of session');
subplot(3, 2, 6); plot(nTrials-npt+1:nTrials, reg.epsilon2((end-npt+1):end), '.r'); title('Epsilon2: End of session'); %xlim([0 npt]);


end

function [ devPos ] = get_deviant_positions( tones )
%GET_DEVIANT_POSITIONS Returns the trials on which a transition occured
%   Detailed explanation goes here

devPos = [];

for i = 2: length(tones)
    if tones(i) ~= tones(i-1)
        devPos = [devPos i];
    end
end

devPos = devPos';

end


function [ precStds ] = get_preceding_standards( devPos )
%GET_PRECEDING_STANDARDS Counts nr of preceding standards per deviant
%   Input: vector of deviant positions (within all trials), Output: vector
%   of length = nr of deviants, containing nr of preceding standards

precStds(1) = devPos(1) - 1;

for i = 2:length(devPos)
    precStds(i) = devPos(i) - devPos(i-1) - 1;
end

precStds = precStds';

end
