function fh = mnket_plot_prediction_errors_alltrials(sim, design)

inp = sim.u;
inpo = sim.u_orig;
nTrials = length(inp);

% regressors
reg.epsilon2 = design.epsilon2;
reg.epsilon2(1) = NaN;
reg.epsilon3 = design.epsilon3;
reg.epsilon3(1) = NaN;

%% plot

fh = figure('Name', 'Prediction Errors: All trials');
    
subplot(2, 1, 1);
plot(1: nTrials, reg.epsilon3, '+', 'Color', [0 0 0.5], 'LineWidth', 2); 
xlim([1 nTrials]);
xlabel('Trials')
ylabel('Epsilon3')
title('Higher-level PE');

subplot(2, 1, 2);
plot(1: nTrials, reg.epsilon2, '+', 'Color', [0 0.5 0], 'LineWidth', 2); 
xlim([1 nTrials]);
xlabel('Trials')
ylabel('Epsilon2')
title('Lower-level PE');

end
