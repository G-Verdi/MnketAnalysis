function [ reg ] = plot_regressors_allDesign(sim, design)

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
reg.bayesian = design.bayesian;
reg.bayesian(1) = [];
reg.epsilon3 = design.epsilon3;
reg.epsilon3(1) = [];
reg.shannon = design.shannon;
reg.shannon(1) = [];

% deviant trial regressors
deviant.bayesian = reg.bayesian(dev);
deviant.epsilon3 = reg.epsilon3(dev);
deviant.shannon = reg.shannon(dev);

% setup sim matrices for correlations
mat(:, 1) = reg.bayesian;
mat(:, 2) = reg.epsilon3;
mat(:, 3) = reg.shannon;

devmat(:, 1) = deviant.bayesian;
devmat(:, 2) = deviant.epsilon3;
devmat(:, 3) = deviant.shannon;

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

subplot(3, 1, 1);
plot(1: numel(dev), reg.deviant.bayesian, 'o', 'Color', [0 0 0.5], 'LineWidth', 2); 
title('Bayesian surprise');

subplot(3, 1, 2);
plot(1: numel(dev), reg.deviant.epsilon3, '+', 'Color', [0 0.5 0], 'LineWidth', 2); 
title('Volatility PE');

subplot(3, 1, 3);
plot(1: numel(dev), reg.deviant.shannon, '^', 'Color', [0.5 0 0], 'LineWidth', 2); 
title('Shannon surprise');


%{
for me = 1: numel(measures)
    figure('Name', measures{me});
    
    subplot(3, 2, 1); plot(1: npt, inp(1:npt), '.k'); title('Tones (Beginning of session)');
    subplot(3, 2, 3); plot(1: npt, reg.(measures{me})(1:npt), '.r'); title([measures{me} ': Beginning of session']);
    
    subplot(3, 2, 2); plot(nTrials-npt+1:nTrials, inp((end-npt+1):end), '.k'); title('Tones (End of session)'); %xlim([0 npt]);
    subplot(3, 2, 4); plot(nTrials-npt+1:nTrials, reg.(measures{me})((end-npt+1):end), '.r'); title([measures{me} ': End of session']); %xlim([0 npt]);

    subplot(3, 2, 5); plot(1: numel(dev), reg.deviant.(measures{me}), '.b'); title([measures{me} ': Deviant trials']);
    subplot(3, 2, 6); plot(1: max(pre), effect.(measures{me}), '^g', 'MarkerSize', 5, 'MarkerFaceColor', 'g'); title([measures{me} ': Effect of preceding standards']); xlim([0 11]);
end
%}

% Correlations amongst regressors: all trials


end
