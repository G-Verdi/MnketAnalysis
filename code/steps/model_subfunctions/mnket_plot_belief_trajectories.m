function fh = mnket_plot_belief_trajectories(sim)

inp = sim.u;
inpo = sim.u_orig;
nTrials = length(inpo);

% beliefs
bel.volatility = [NaN; sim.traj.mu(:, 3, 1, 1)];
bel.repetition = [NaN; sim.traj.muhat(:, 1, 1, 1)];
bel.transition = [NaN; sim.traj.muhat(:, 1, 3, 1)];
bel.tones = inpo;

%% plot

fh = figure('Name', 'Prediction Errors: All trials');
    
subplot(4, 1, 1);
plot(1: nTrials, bel.volatility, 'Color', [0 0 0.5], 'LineWidth', 2); 
xlim([1 nTrials]);
ylim([min(bel.volatility-0.1) 1.01]);
xlabel('Trials')
ylabel('mu3')
title('Belief about Volatility');

subplot(4, 1, 2);
plot(1: nTrials, bel.repetition, 'Color', [0 0.5 0], 'LineWidth', 2); 
xlim([1 nTrials]);
xlabel('Trials')
ylabel('mu1_1to1')
title('Probability Estimate for Repetition of Tone 1');

subplot(4, 1, 3);
plot(1: nTrials, bel.transition, 'Color', [0 0.5 0], 'LineWidth', 2); 
xlim([1 nTrials]);
xlabel('Trials')
ylabel('mu1_1to3')
title('Probability Estimate for Transition from Tone 1 to Tone 3');

subplot(4, 1, 4);
plot(1: nTrials, bel.tones, '.k', 'LineWidth', 1); 
xlim([1 nTrials]);
xlabel('Trials')
ylabel('Frequency (category)')
title('Tones presented');

end
