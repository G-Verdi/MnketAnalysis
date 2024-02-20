% All the data that is displayed in tables in the ketamine paper

%% 1) PRIORS
% to be found in tapas_hgf_transition_config
% Model name
c.model = 'hgf_transition';

% Number of states
c.n_states = 7;

% Upper bound for kappa and theta (lower bound is always zero)
c.kaub = 2;
c.thub = 0.1;

% Sufficient statistics of Gaussian parameter priors

% Initial mu2
c.mu2_0mu = repmat(tapas_logit(1/c.n_states,1),c.n_states);
c.mu2_0sa = zeros(c.n_states);

% Initial sigma2
c.logsa2_0mu = repmat(log(1),c.n_states);
c.logsa2_0sa = zeros(c.n_states);

% Initial mu3
% Usually best kept fixed to 1 (determines origin on x3-scale).
c.mu3_0mu = 1;
c.mu3_0sa = 0;

% Initial sigma3
c.logsa3_0mu = log(0.1);
c.logsa3_0sa = 1;

% Kappa
% This should be fixed (preferably to 1) if the observation model
% does not use mu3 (kappa then determines the scaling of x3).
c.logitkamu = 0;
c.logitkasa = 0;

% Omega
c.ommu =  -6;
c.omsa = 5^2;

% Theta
c.logitthmu = 0;
c.logitthsa = 2;

%% 2) PARAMETERS
% to be found in file data/simulation/parameters/stats.mat
% calculated using script_mnket_calculate_parameter_stats
>> load('stats.mat')
>> stats

stats = 

     placebo: [1x1 struct]
    ketamine: [1x1 struct]
       omega: [1x1 struct]
       theta: [1x1 struct]
       sa3_0: [1x1 struct]

>> stats.placebo

ans = 

       params: [19x3 double]
    meanParas: [-10.0436 0.0445 0.1001]
     stdParas: [0.2002 0.0032 2.1152e-04]

>> stats.ketamine

ans = 

       params: [19x3 double]
    meanParas: [-10.0610 0.0455 0.1001]
     stdParas: [0.2826 0.0028 3.8101e-04]

>> stats.omega

ans = 

    mPla: -10.0436
    sPla: 0.2002
    mKet: -10.0610
    sKet: 0.2826
       p: 0.8330

>> stats.theta

ans = 

    mPla: 0.0445
    sPla: 0.0032
    mKet: 0.0455
    sKet: 0.0028
       p: 0.3339

>> stats.sa3_0

ans = 

    mPla: 0.1001
    sPla: 2.1152e-04
    mKet: 0.1001
    sKet: 3.8101e-04
       p: 0.6703
       
 %% 3) ARTEFACTS