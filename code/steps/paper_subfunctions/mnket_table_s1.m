function [ data ] = mnket_table_s1( savePath )
%MNKET_TABLE_S1 Collects all data for supplementary table S1: Priors on HGF perceptual parameters
%and starting values of beliefs.
%   IN:     -
%   OUT:    data    - struct with all priors and HGF model setup

tabPath = fullfile(savePath, 'table_s1');
mkdir(tabPath);

data = tapas_hgf_transition_config;
save(fullfile(tabPath, 'tabdata.mat'), 'data');

end

