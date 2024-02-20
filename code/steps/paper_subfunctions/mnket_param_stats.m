% script for calculating parameter stats for mnket simulation

global OPTIONS
OPTIONS = mnket_set_global_options;

placPara = NaN(numel(OPTIONS.stats.subjectIDs), 3);
ketaPara = NaN(numel(OPTIONS.stats.subjectIDs), 3);

idnum = 0;
OPTIONS.condition = 'placebo';
for idcell = OPTIONS.stats.subjectIDs
    id = char(idcell);
    idnum = idnum +1;
    
    placPara(idnum, :) = mnket_get_prc_parameters(id);
    disp(['got placebo parameters from subject ' id]);

end

idnum = 0;
cd(OPTIONS.workdir);
OPTIONS.condition = 'ketamine';
for idcell = OPTIONS.stats.subjectIDs
    id = char(idcell);
    idnum = idnum +1;
    
    ketaPara(idnum, :) = mnket_get_prc_parameters(id);
    disp(['got ketamine parameters from subject ' id]);

end

plac.params = placPara;
plac.meanParas = mean(placPara);
plac.stdParas = std(placPara);

keta.params = ketaPara;
keta.meanParas = mean(ketaPara);
keta.stdParas = std(ketaPara);

stats.placebo = plac;
stats.ketamine = keta;

[~, p1] = ttest(plac.params(:, 1), keta.params(:, 1));
[~, p2] = ttest(plac.params(:, 2), keta.params(:, 2));
[~, p3] = ttest(plac.params(:, 3), keta.params(:, 3));

stats.omega.mPla = plac.meanParas(1);
stats.omega.sPla = plac.stdParas(1);
stats.omega.mKet = keta.meanParas(1);
stats.omega.sKet = keta.stdParas(1);
stats.omega.p = p1;

stats.theta.mPla = plac.meanParas(2);
stats.theta.sPla = plac.stdParas(2);
stats.theta.mKet = keta.meanParas(2);
stats.theta.sKet = keta.stdParas(2);
stats.theta.p = p2;

stats.sa3_0.mPla = plac.meanParas(3);
stats.sa3_0.sPla = plac.stdParas(3);
stats.sa3_0.mKet = keta.meanParas(3);
stats.sa3_0.sKet = keta.stdParas(3);
stats.sa3_0.p = p3;

save([OPTIONS.workdir '/data/simulation/parameters/stats.mat'], 'stats');

cd(OPTIONS.workdir);
clear;
