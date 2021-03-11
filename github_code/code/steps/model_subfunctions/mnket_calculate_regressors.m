function sim = mnket_calculate_regressors( sim )
%MNKET_CALCULATE_REGRESSORS Creates the trial-by-trial estimates of prediction error, precision, or
%surprise in the MNKET study.
%   IN:     sim     - the struct that holds the simulated trajectories (from the HGF toolbox)
%   OUT:    sim     - the struct that additionally holds the regressors

% collect data
tones = sim.u_orig;
eps2 = squeeze(sim.traj.epsi(:, 2, :, :));
eps3 = squeeze(sim.traj.epsi(:, 3, :, :));

muhat1 = squeeze(sim.traj.muhat(:,1,:,:));
muhat3 = squeeze(sim.traj.muhat(:,3,:,:));
sahat = squeeze(sim.traj.sahat(:,1,:,:));

% calculate regressors
sim.reg.epsi2 = mnket_calculate_transitionPE(eps2, tones);
sim.reg.epsi3 = mnket_calculate_sumPE(eps3, tones);

sim.reg.muhat1 = mnket_calculate_transitionPE(muhat1,tones);
sim.reg.sahat = mnket_calculate_transitionPE(sahat,tones);
sim.reg.muhat3 = muhat3(:,1);

%{ 
%this is not in use anymore, as we're now removing the first EEG trial instead of adding a dummy
value as the first model-PE trial:
% add priors / first trial for EEG
sim.reg.epsi2 = [epsi2(1); epsi2];
sim.reg.epsi3 = [epsi3(1); epsi3];
%}

end