function fh = mnket_plot_prediction_errors_detailed(sim, design)

npt = 50;

inp = sim.u;
inpo = sim.u_orig;
nTrials = length(inpo);

% regressors
reg.epsilon2 = design.epsilon2;
reg.epsilon2(1) = NaN;
reg.epsilon3 = design.epsilon3;
reg.epsilon3(1) = NaN;

%% plot
fh = figure('Name', 'Prediction Errors: Details');
    
subplot(3, 2, 1); 
plot(1: npt, reg.epsilon3(1:npt), '+', 'Color', [0 0 0.5], 'LineWidth', 2); 
title('Epsilon3: Beginning of session');
xlim([0 npt]);

subplot(3, 2, 2); 
plot(nTrials-npt+1:nTrials, reg.epsilon3((end-npt+1):end), '+', 'Color', [0 0 0.5], 'LineWidth', 2); 
title('Epsilon3: End of session'); 
xlim([nTrials-npt+1 nTrials]);

subplot(3, 2, 3); 
plot(1: npt, reg.epsilon2(1:npt), '+', 'Color', [0 0.5 0], 'LineWidth', 2); 
title('Epsilon2: Beginning of session');
xlim([0 npt]);

subplot(3, 2, 4); 
plot(nTrials-npt+1:nTrials, reg.epsilon2((end-npt+1):end), '+', 'Color', [0 0.5 0], 'LineWidth', 2); 
title('Epsilon2: End of session'); 
xlim([nTrials-npt+1 nTrials]);

subplot(3, 2, 5); 
plot(1: npt, inp(1:npt), 'ok', 'LineWidth', 2); 
title('Tones (Beginning of session)');
xlim([0 npt]);

subplot(3, 2, 6); 
plot(nTrials-npt+1:nTrials, inp((end-npt+1):end), 'ok', 'LineWidth', 2); 
title('Tones (End of session)');
xlim([nTrials-npt+1 nTrials]);

end
