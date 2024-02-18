function [ params ] = mnket_get_prc_parameters( id, options )
%MNKET_GET_PRC_PARAMETERS Collects posterior HGF parameters for one subject from the MNKET study.
%   IN:     id      - subject identifier string, e.g. '0001'
%           options - the struct that holds all analysis options
%   OUT:    params  - vector with posterior omega, theta and sigma3_0 values

if nargin < 2
    options = mnket_set_analysis_options;
end

details = mnket_subjects(id, options);
load(details.simfilepost);

params(1) = sim.p_prc.om;
params(2) = sim.p_prc.th;
params(3) = sim.p_prc.sa3_0;


end

