function sim = mnket_calculate_regressors( sim )
%MNKET_CALCULATE_REGRESSORS Creates the trial-by-trial estimates of prediction error, precision, or
%surprise in the MNKET study.
%   IN:     sim     - the struct that holds the simulated trajectories (from the HGF toolbox)
%   OUT:    sim     - the struct that additionally holds the regressors

% collect data
tones = sim.u_orig;
eps2 = squeeze(sim.traj.epsi(:, 2, :, :));
eps3 = squeeze(sim.traj.epsi(:, 3, :, :));

% pihat1 = squeeze(1./sim.traj.sahat(:,1,:,:));
% pihat2 = squeeze(1./sim.traj.sahat(:,2,:,:));
% pihat3 = squeeze(1./sim.traj.sahat(:,3,:,:));


% sahat2 = squeeze(sim.traj.sahat(:,2,:,:));
% sahat3 = squeeze(sim.traj.sahat(:,3,:,:));
 
% delta1 = squeeze(sim.traj.da(:,2,:,:));
% delta2 = squeeze(sim.traj.da(:,3,:,:));

% sigma2 = squeeze(sim.traj.sa(:,2,:,:));
% sigma3 = squeeze(sim.traj.sa(:,3,:,:));

% calculate regressors
sim.reg.epsi2 = mnket_calculate_transitionPE(eps2,tones);
sim.reg.epsi3 = mnket_calculate_sumPE(eps3,tones);

% sim.reg.pihat1 = mnket_calculate_transitionPE(pihat1,tones);
% sim.reg.pihat2 = mnket_calculate_transitionPE(pihat2,tones);
% sim.reg.pihat3 = pihat3(:,1);

% sim.reg.delta1 = mnket_calculate_transitionPE(delta1,tones);
% sim.reg.delta2 = mnket_calculate_sumPE(delta2,tones);

% sim.reg.sahat2 = mnket_calculate_transitionPE(sahat2,tones);
% sim.reg.sahat3 = mnket_calculate_transitionPE(sahat3,tones);
% 
% sim.reg.sigma2 = mnket_calculate_transitionPE(sigma2,tones);
% sim.reg.sigma3 = mnket_calculate_transitionPE(sigma3,tones);

% add priors / first trial for EEG (Note: needs to be added when
% running psilocybin study subjects)

% sim.reg.epsi2 = [sim.reg.epsi2(1); sim.reg.epsi2];
% sim.reg.epsi3 = [sim.reg.epsi3(1); sim.reg.epsi3];
% % %
% sim.reg.pihat1 = [sim.reg.pihat1(1); sim.reg.pihat1];
% sim.reg.pihat2 = [sim.reg.pihat2(1); sim.reg.pihat2];
% sim.reg.pihat3 = [sim.reg.pihat3(1); sim.reg.pihat3];



end