function mnket_save_trajectories( id )

details = mnket_subjects(id);
load(details.simFilePre);

% collect data
tones = sim.u_orig;

eps2 = squeeze(sim.traj.epsi(:, 2, :, :));
eps3 = squeeze(sim.traj.epsi(:, 3, :, :));

da1 = squeeze(sim.traj.da(:, 1, :, :));
da2 = squeeze(sim.traj.da(:, 2, :, :));

sa2 = squeeze(sim.traj.sa(:, 2, :, :));
sa3 = squeeze(sim.traj.sa(:, 2, 1, 1));

sa2_0 = sim.p_prc.sa2_0(1);
sa3_0 = sim.p_prc.sa3_0;

mu1hat = squeeze(sim.traj.muhat(:, 1, :, :));
mu2hat = squeeze(sim.traj.muhat(:, 2, :, :));
mu2 = squeeze(sim.traj.mu(:, 2, :, :));

% calculate regressors
delta1 = mnket_calculate_transitionPE(da1, tones);
delta2 = mnket_calculate_sumPE(da2, tones);

sigma2 = mnket_calculate_transitionPE(sa2, tones);
sigma3 = sa3;

epsi2 = mnket_calculate_transitionPE(eps2, tones);
epsi3 = mnket_calculate_sumPE(eps3, tones);

bayesian = mnket_calculate_bayesian(mu2, mu2hat, tones);
shannon = mnket_calculate_shannon(mu1hat, tones);

% add priors / first trial for EEG
sim.reg.delta1 = [delta1(1); delta1];
sim.reg.delta2 = [delta2(1); delta2];

sim.reg.sigma2 = [sa2_0; sigma2];
sim.reg.sigma3 = [sa3_0; sigma3];

sim.reg.epsi2 = [epsi2(1); epsi2];
sim.reg.epsi3 = [epsi3(1); epsi3];

sim.reg.bayesian = [mean(bayesian); bayesian];
sim.reg.shannon = [mean(shannon); shannon];

% save new sim file
save(details.simFilePost, 'sim');


end

