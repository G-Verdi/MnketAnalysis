function mnket_2ndlevel_erpbased
%MNKET_2NDLEVEL_ERPBASED Performs all 2nd level analyses steps for
%modelfree ERP analysis in the MNKET study.
%   Currently, this only uses the difference waves from the first level (no
%   computation of grand averages or stats for deviant and standard
%   waveforms separately).
%   IN:     --
%   OUT:    --

options = mnket_set_analysis_options;

options.conversion.mode = 'diffWaves';
options.stats.mode = 'diffWaves';

for optionsCell = {'placebo','ketamine'}
    options.condition = char(optionsCell);
    
    % tones definition
    options.erp.type = 'tone';
    mnket_2ndlevel_erpanalysis_percondition(options);
    
    % lowhighEpsi2 definition
    options.erp.type = 'lowhighEpsi2';
    mnket_2ndlevel_erpanalysis_percondition(options);
    mnket_2ndlevel_erpstats_percondition_highlowERP(options);
    mnket_2ndlevel_erpstats_percondition_diffERP(options);
    % lowhighEpsi3 definition
    options.erp.type = 'lowhighEpsi3';
    mnket_2ndlevel_erpanalysis_percondition(options);
    mnket_2ndlevel_erpstats_percondition_highlowERP(options);
    mnket_2ndlevel_erpstats_percondition_diffERP(options);
    
    % lowhighMuhat1 definition
    options.erp.type = 'lowhighMuhat1';
    mnket_2ndlevel_erpanalysis_percondition(options);
    mnket_2ndlevel_erpstats_percondition_highlowERP(options);
    mnket_2ndlevel_erpstats_percondition_diffERP(options);
    
    % lowhighMuhat3 definition
    options.erp.type = 'lowhighMuhat3';
    mnket_2ndlevel_erpanalysis_percondition(options);
    mnket_2ndlevel_erpstats_percondition_highlowERP(options);
    mnket_2ndlevel_erpstats_percondition_diffERP(options);
    
    % lowhighPrcsn definition
    options.erp.type = 'lowhighSahat';
    mnket_2ndlevel_erpanalysis_percondition(options);
    mnket_2ndlevel_erpstats_percondition_highlowERP(options);
    mnket_2ndlevel_erpstats_percondition_diffERP(options);
end

% tones definition
options.erp.type = 'tone';
mnket_2ndlevel_erpanalysis_drugdiff(options);

%lowhighepsi2
options.erp.type = 'lowhighEpsi2';
mnket_2ndlevel_erpanalysis_drugdiff(options);
mnket_2ndlevel_erpstats_drugdiff(options);

%lowhighepsi3
options.erp.type = 'lowhighEpsi3';
mnket_2ndlevel_erpanalysis_drugdiff(options);
mnket_2ndlevel_erpstats_drugdiff(options);

%lowhighMuhat1
options.erp.type = 'lowhighMuhat1';
mnket_2ndlevel_erpanalysis_drugdiff(options);
mnket_2ndlevel_erpstats_drugdiff(options);

%lowhighMuhat3
options.erp.type = 'lowhighMuhat3';
mnket_2ndlevel_erpanalysis_drugdiff(options);
mnket_2ndlevel_erpstats_drugdiff(options);

%lowhighPrcsn
options.erp.type = 'lowhighSahat';
mnket_2ndlevel_erpanalysis_drugdiff(options);
mnket_2ndlevel_erpstats_drugdiff(options);

% roving definition
%options.erp.type = 'roving';
%mnket_2ndlevel_erpanalysis_drugdiff(options);
%mnket_2ndlevel_erpstats_drugdiff(options);

% MMN AD definition
%options.erp.type = 'mmnad';
%mnket_2ndlevel_erpanalysis_drugdiff(options);
%mnket_2ndlevel_erpstats_drugdiff(options);

end
