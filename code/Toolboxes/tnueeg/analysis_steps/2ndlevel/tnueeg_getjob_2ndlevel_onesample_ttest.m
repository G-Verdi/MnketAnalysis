function [ job ] = tnueeg_getjob_2ndlevel_onesample_ttest(facdir, scans, factorName)
%TNUEEG_GETJOB_2NDLEVEL_ONESAMPLE_TTEST Creates a job for running a
%one-sample t-test on the second level for the effect of factorName.
%   The function automatically specifies 3 contrasts (2 t-contrasts for
%   positive and negative effects of factorName, and 1 F-contrast for the
%   overall effect of factorName.
%   IN:     facdir      - directory (string) for saving the SPM.mat
%           scans       - cell array list of image filenames, including paths
%           factorName  - string with a name for the effect
%   OUT:    job         - the job for the 2nd level statistics that can be
%                       run using the spm_jobman

% job 1: factorial design
job{1}.spm.stats.factorial_design.dir = {facdir};
job{1}.spm.stats.factorial_design.des.t1.scans = scans;


 %% Load Covariates
%     job{1}.spm.stats.factorial_design.cov(1).c = [0
% 0
% 0
% 0.333333
% 0
% 0.666666
% 2
% 0
% 0
% 0
% 0
% 0
% 0.666666
% 0
% 0.666666
% 1.666666];
%     %
%     job{1}.spm.stats.factorial_design.cov(1).cname = 'DE';
%     job{1}.spm.stats.factorial_design.cov(1).iCFI = 2;
%     job{1}.spm.stats.factorial_design.cov(1).iCC = 1;
% %     %%
%     job{1}.spm.stats.factorial_design.cov(2).c = [0
% 0
% 0
% 0
% 0
% 0.6
% 1.6
% 0
% 0
% 0
% 0
% 0
% 1
% 0
% 0.4
% 1];
%     %%
%     job{1}.spm.stats.factorial_design.cov(2).cname = 'EU';
%     job{1}.spm.stats.factorial_design.cov(2).iCFI = 2;
%     job{1}.spm.stats.factorial_design.cov(2).iCC = 1;
% %     %%
%     job{1}.spm.stats.factorial_design.cov(3).c = [0
% 0
% 0
% 0.666666
% 0
% 0.666666
% 1.666666
% 0
% 0
% 0
% 0
% 0
% 1
% 0.333333
% 0.333333
% 1];
%     %
%     job{1}.spm.stats.factorial_design.cov(3).cname = 'SP';
%     job{1}.spm.stats.factorial_design.cov(3).iCFI = 2;
%     job{1}.spm.stats.factorial_design.cov(3).iCC = 1;
%     job{1}.spm.stats.factorial_design.cov(4).c = [0
% 0
% 0
% 0.666666
% 0
% 0.333333
% 2.333333
% 0
% 0
% 0
% 0
% 0
% 1
% 0
% 3
% 1.333333];
%     %
%     job{1}.spm.stats.factorial_design.cov(4).cname = 'BS';
%     job{1}.spm.stats.factorial_design.cov(4).iCFI = 2;
%     job{1}.spm.stats.factorial_design.cov(4).iCC = 1;
%     job{1}.spm.stats.factorial_design.cov(5).c = [0
% 0
% 0
% 1
% 0
% 1
% 2.333333
% 0
% 0
% 0
% 0
% 0
% 1
% 0
% 0
% 1];
%     %
%     job{1}.spm.stats.factorial_design.cov(5).cname = 'IN';
%     job{1}.spm.stats.factorial_design.cov(5).iCFI = 2;
%     job{1}.spm.stats.factorial_design.cov(5).iCC = 1;
% 
%     job{1}.spm.stats.factorial_design.cov(6).c = [0
% 0
% 0
% 0
% 0
% 1.333333
% 1.666666
% 0
% 0
% 0
% 0
% 0
% 0.333333
% 0
% 0
% 0.666666];
% 
%     job{1}.spm.stats.factorial_design.cov(6).cname = 'EI';
%     job{1}.spm.stats.factorial_design.cov(6).iCFI = 2;
%     job{1}.spm.stats.factorial_design.cov(6).iCC = 1;
% 
%     job{1}.spm.stats.factorial_design.cov(7).c = [0
% 0
% 0
% 0.666666
% 0
% 1
% 2
% 0
% 0
% 0
% 0
% 0
% 0.333333
% 0
% 0
% 1.666666];
% 
%     job{1}.spm.stats.factorial_design.cov(7).cname = 'CI';
%     job{1}.spm.stats.factorial_design.cov(7).iCFI = 2;
%     job{1}.spm.stats.factorial_design.cov(7).iCC = 1;
%     job{1}.spm.stats.factorial_design.cov(7).c = [0
%     0
%     0
%     0.666666
%     0
%     1
%     1.666666
%     0
%     0
%     0
%     0
%     0
%     0.666666
%     5.333333
%     0.333333
%     1];
% 
%     job{1}.spm.stats.factorial_design.cov(7).cname = 'AV';
%     job{1}.spm.stats.factorial_design.cov(7).iCFI = 2;
%     job{1}.spm.stats.factorial_design.cov(7).iCC = 1;

%%
%     job{1}.spm.stats.factorial_design.cov(1).c = [0
% 0
% 0
% 0.571428
% 0
% 0.857142
% 1.857142
% 0
% 0
% 0
% 5.285714
% 0
% 1
% 1.142857
% 0
% 1.428571];
% 

%     job{1}.spm.stats.factorial_design.cov(1).cname = 'ICC';
%     job{1}.spm.stats.factorial_design.cov(1).iCFI = 2;
%     job{1}.spm.stats.factorial_design.cov(1).iCC = 1;
% 
%%
%     job{1}.spm.stats.factorial_design.cov(9).c = [0
% 0
% 0
% 0.666666
% 0
% 1
% 1.666666
% 0
% 0
% 0
% 0
% 0
% 0.5
% 0
% 0.166666
% 1.166666];
% %%

%     job{1}.spm.stats.factorial_design.cov(9).cname = 'AX';
%     job{1}.spm.stats.factorial_design.cov(9).iCFI = 2;
%     job{1}.spm.stats.factorial_design.cov(9).iCC = 1;
% 
%     job{1}.spm.stats.factorial_design.cov(10).c = [0
% 0
% 0.285714
% 0.285714
% 0
% 2
% 2
% 0
% 0
% 0
% 0
% 0
% 1
% 0.142857
% 2.285714
% 1.714285];
% 
%     job{1}.spm.stats.factorial_design.cov(10).cname = 'PD';
%     job{1}.spm.stats.factorial_design.cov(10).iCFI = 2;
%     job{1}.spm.stats.factorial_design.cov(10).iCC = 1;
% 
% 
%     job{1}.spm.stats.factorial_design.cov(11).c = [0
% 0
% 0
% 0.5
% 0
% 0.5
% 1.75
% 0
% 0
% 0
% 0
% 0
% 0.75
% 0
% 0.75
% 1.5];
%     job{1}.spm.stats.factorial_design.cov(11).cname = 'PDP';
%     job{1}.spm.stats.factorial_design.cov(11).iCFI = 2;
%     job{1}.spm.stats.factorial_design.cov(11).iCC = 1;
% 
% 
%     job{1}.spm.stats.factorial_design.cov(12).c = [0
% 0
% 0
% 0.536796091
% 0
% 0.799133909
% 1.859739818
% 0
% 0
% 0
% 0.480519455
% 0
% 0.712121
% 0.619047545
% 0.506060364
% 1.205627364];
%     job{1}.spm.stats.factorial_design.cov(12).cname = 'GASC';
%     job{1}.spm.stats.factorial_design.cov(12).iCFI = 2;
%     job{1}.spm.stats.factorial_design.cov(12).iCC = 1;
% 
% 
%     job{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
%     job{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
%     job{1}.spm.stats.factorial_design.masking.im = 1;
%     job{1}.spm.stats.factorial_design.masking.em = {''};
%     job{1}.spm.stats.factorial_design.globalc.g_omit = 1;
%     job{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
%     job{1}.spm.stats.factorial_design.globalm.glonorm = 1;


% job{1}.spm.stats.factorial_design.cov(1).c = [11.333333
%                                                       7
%                                                       51
%                                                       5
%                                                       0
%                                                       14.666666
%                                                       6
%                                                       4.333333
%                                                       0
%                                                       8
%                                                       34.333333
%                                                       21
%                                                       1
%                                                       4.666666
%                                                       5
%                                                       15.333333];
% %%
% job{1}.spm.stats.factorial_design.cov(1).cname = 'DE';
% job{1}.spm.stats.factorial_design.cov(1).iCFI = 2;
% job{1}.spm.stats.factorial_design.cov(1).iCC = 1;
% %%
% job{1}.spm.stats.factorial_design.cov(2).c = [60.6
%                                                       3
%                                                       36.4
%                                                       19.8
%                                                       0
%                                                       0.8
%                                                       27.6
%                                                       11.8
%                                                       20
%                                                       27.4
%                                                       51.8
%                                                       2
%                                                       4
%                                                       2
%                                                       7.6
%                                                       3.8];
% %%
% job{1}.spm.stats.factorial_design.cov(2).cname = 'EU';
% job{1}.spm.stats.factorial_design.cov(2).iCFI = 2;
% job{1}.spm.stats.factorial_design.cov(2).iCC = 1;
% %%
% job{1}.spm.stats.factorial_design.cov(3).c = [34
%                                                       11.666666
%                                                       43.333333
%                                                       1.666666
%                                                       0
%                                                       1
%                                                       3
%                                                       0
%                                                       0
%                                                       15.666666
%                                                       0
%                                                       0
%                                                       0.333333
%                                                       0
%                                                       0.666666
%                                                       24.666666];
% %%
% job{1}.spm.stats.factorial_design.cov(3).cname = 'SP';
% job{1}.spm.stats.factorial_design.cov(3).iCFI = 2;
% job{1}.spm.stats.factorial_design.cov(3).iCC = 1;
% %%
% job{1}.spm.stats.factorial_design.cov(4).c = [51
%                                                       13.333333
%                                                       29.333333
%                                                       38
%                                                       0
%                                                       32
%                                                       21.666666
%                                                       21.666666
%                                                       8.666666
%                                                       60.666666
%                                                       29.333333
%                                                       17.333333
%                                                       11.333333
%                                                       14.666666
%                                                       1
%                                                       72.333333];
% %%
% job{1}.spm.stats.factorial_design.cov(4).cname = 'BS';
% job{1}.spm.stats.factorial_design.cov(4).iCFI = 2;
% job{1}.spm.stats.factorial_design.cov(4).iCC = 1;
% %%
% job{1}.spm.stats.factorial_design.cov(5).c = [63
%                                                       47.333333
%                                                       89.333333
%                                                       11
%                                                       6.666666
%                                                       0
%                                                       17
%                                                       6.333333
%                                                       0
%                                                       28.333333
%                                                       10
%                                                       0
%                                                       3.333333
%                                                       0
%                                                       2.333333
%                                                       1.666666];
% %%
% job{1}.spm.stats.factorial_design.cov(5).cname = 'IN';
% job{1}.spm.stats.factorial_design.cov(5).iCFI = 2;
% job{1}.spm.stats.factorial_design.cov(5).iCC = 1;
% %%
% job{1}.spm.stats.factorial_design.cov(6).c = [12.666666
%                                                       36
%                                                       48.333333
%                                                       1.333333
%                                                       4.333333
%                                                       37.333333
%                                                       7.333333
%                                                       53.666666
%                                                       0
%                                                       51
%                                                       51.333333
%                                                       56.333333
%                                                       6
%                                                       0
%                                                       13.333333
%                                                       68.333333];
% %%
% job{1}.spm.stats.factorial_design.cov(6).cname = 'EI';
% job{1}.spm.stats.factorial_design.cov(6).iCFI = 2;
% job{1}.spm.stats.factorial_design.cov(6).iCC = 1;
% %%
% job{1}.spm.stats.factorial_design.cov(7).c = [0.666666
%                                                       76
%                                                       17
%                                                       20
%                                                       0
%                                                       38.666666
%                                                       65.333333
%                                                       8.333333
%                                                       0
%                                                       76.333333
%                                                       24.666666
%                                                       6.333333
%                                                       4.666666
%                                                       12.333333
%                                                       4.666666
%                                                       96.333333];
% %%
% job{1}.spm.stats.factorial_design.cov(7).cname = 'AV';
% job{1}.spm.stats.factorial_design.cov(7).iCFI = 2;
% job{1}.spm.stats.factorial_design.cov(7).iCC = 1;
% %%
% job{1}.spm.stats.factorial_design.cov(8).c = [42
%                                                       14
%                                                       5.857142
%                                                       6.285714
%                                                       0.714285
%                                                       5.714285
%                                                       12.428571
%                                                       14
%                                                       18.714285
%                                                       3
%                                                       39.714285
%                                                       6
%                                                       1
%                                                       17.714285
%                                                       23.285714
%                                                       50.571428];
% %%
% job{1}.spm.stats.factorial_design.cov(8).cname = 'ICC';
% job{1}.spm.stats.factorial_design.cov(8).iCFI = 2;
% job{1}.spm.stats.factorial_design.cov(8).iCC = 1;
% %%
% job{1}.spm.stats.factorial_design.cov(9).c = [0.333333
%                                                       9.166666
%                                                       0.166666
%                                                       0
%                                                       0
%                                                       0.833333
%                                                       12.166666
%                                                       0
%                                                       0
%                                                       0.5
%                                                       1
%                                                       0
%                                                       0.333333
%                                                       0
%                                                       1
%                                                       36.666666];
% %%
% job{1}.spm.stats.factorial_design.cov(9).cname = 'AX';
% job{1}.spm.stats.factorial_design.cov(9).iCFI = 2;
% job{1}.spm.stats.factorial_design.cov(9).iCC = 1;
% %%
% job{1}.spm.stats.factorial_design.cov(10).c = [39.571428
%                                                        14.714285
%                                                        49.571428
%                                                        14.571428
%                                                        0
%                                                        11.571428
%                                                        34
%                                                        15
%                                                        15.571428
%                                                        36.857142
%                                                        37
%                                                        20.714285
%                                                        9.571428
%                                                        7.714285
%                                                        8.857142
%                                                        24.285714];
% %%
% job{1}.spm.stats.factorial_design.cov(10).cname = 'PD';
% job{1}.spm.stats.factorial_design.cov(10).iCFI = 2;
% job{1}.spm.stats.factorial_design.cov(10).iCC = 1;
% %%
% job{1}.spm.stats.factorial_design.cov(11).c = [28.5
%                                                        5.75
%                                                        61
%                                                        8.75
%                                                        0
%                                                        11.5
%                                                        8.75
%                                                        3.25
%                                                        0
%                                                        9
%                                                        26.5
%                                                        15.75
%                                                        0.75
%                                                        3.5
%                                                        4.25
%                                                        12];
% %%
% job{1}.spm.stats.factorial_design.cov(11).cname = 'PDP';
% job{1}.spm.stats.factorial_design.cov(11).iCFI = 2;
% job{1}.spm.stats.factorial_design.cov(11).iCC = 1;
% %%
% job{1}.spm.stats.factorial_design.cov(12).c = [32.47878764
%                                                        27.37878764
%                                                        38.00822473
%                                                        14.09870118
%                                                        3.095237818
%                                                        13.42554082
%                                                        23.41168809
%                                                        10.92121191
%                                                        7.277056091
%                                                        31.86969673
%                                                        30.77402564
%                                                        11.42424227
%                                                        3.393939091
%                                                        6.822510545
%                                                        6.322943455
%                                                        44.30649309];
% %%
% job{1}.spm.stats.factorial_design.cov(12).cname = 'GASC';
% job{1}.spm.stats.factorial_design.cov(12).iCFI = 2;
% job{1}.spm.stats.factorial_design.cov(12).iCC = 1;
% %%
% job{1}.spm.stats.factorial_design.cov(13).c = [40.333333
%                                                        58.333333
%                                                        39.666666
%                                                        30
%                                                        6.666666
%                                                        15
%                                                        64
%                                                        0
%                                                        32.666666
%                                                        36.666666
%                                                        56.666666
%                                                        16
%                                                        3.666666
%                                                        18.666666
%                                                        9.333333
%                                                        58];
% %%
% job{1}.spm.stats.factorial_design.cov(13).cname = 'CMP';
% job{1}.spm.stats.factorial_design.cov(13).iCFI = 2;
% job{1}.spm.stats.factorial_design.cov(13).iCC = 1;
% %%
% job{1}.spm.stats.factorial_design.cov(14).c = [41.333333
%                                                        25.333333
%                                                        57.666666
%                                                        22
%                                                        15.666666
%                                                        1.666666
%                                                        21
%                                                        0
%                                                        0
%                                                        43
%                                                        39.666666
%                                                        0.666666
%                                                        1.666666
%                                                        5
%                                                        1.333333
%                                                        59.666666];
% %%
% job{1}.spm.stats.factorial_design.cov(14).cname = 'Complex Imagery';
% job{1}.spm.stats.factorial_design.cov(14).iCFI = 2;
% job{1}.spm.stats.factorial_design.cov(14).iCC = 1;
% 
% 
%     job{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
%     job{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
%     job{1}.spm.stats.factorial_design.masking.im = 1;
%     job{1}.spm.stats.factorial_design.masking.em = {''};
%     job{1}.spm.stats.factorial_design.globalc.g_omit = 1;
%     job{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
%     job{1}.spm.stats.factorial_design.globalm.glonorm = 1;


job{1}.spm.stats.factorial_design.cov = ...
    struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
job{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
job{1}.spm.stats.factorial_design.masking.im = 1;
job{1}.spm.stats.factorial_design.masking.em = {''};
job{1}.spm.stats.factorial_design.globalc.g_omit = 1;
job{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
job{1}.spm.stats.factorial_design.globalm.glonorm = 1;

% job 2: estimate factorial design
job{2}.spm.stats.fmri_est.spmmat(1) = ...
    cfg_dep('Factorial design specification: SPM.mat File', ...
    substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), ...
    substruct('.','spmmat'));
job{2}.spm.stats.fmri_est.write_residuals = 0;
job{2}.spm.stats.fmri_est.method.Classical = 1;

% job 3: specify contrasts
job{3}.spm.stats.con.spmmat(1) = ...
    cfg_dep('Model estimation: SPM.mat File', ...
    substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), ...
    substruct('.','spmmat'));
job{3}.spm.stats.con.consess{1}.tcon.name = [factorName '_pos'];
job{3}.spm.stats.con.consess{1}.tcon.weights = 1;
job{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
job{3}.spm.stats.con.consess{2}.tcon.name = [factorName '_neg'];
job{3}.spm.stats.con.consess{2}.tcon.weights = -1;
job{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
job{3}.spm.stats.con.consess{3}.fcon.name = ['Effect of ' factorName];
job{3}.spm.stats.con.consess{3}.fcon.weights = 1;
job{3}.spm.stats.con.consess{3}.fcon.sessrep = 'none';
job{3}.spm.stats.con.delete = 0;

% job 4: print results
job{4}.spm.stats.results.spmmat(1) = ...
    cfg_dep('Contrast Manager: SPM.mat File', ...
    substruct('.','val', '{}',{3}, ...
            '.','val', '{}',{1}, ...
            '.','val', '{}',{1}), ...
            substruct('.','spmmat'));

job{4}.spm.stats.results.conspec(1).titlestr = '';
job{4}.spm.stats.results.conspec(1).contrasts = 1;
job{4}.spm.stats.results.conspec(1).threshdesc = 'none';
job{4}.spm.stats.results.conspec(1).thresh = 0.001;
job{4}.spm.stats.results.conspec(1).extent = 0;
job{4}.spm.stats.results.conspec(1).mask = ...
    struct('contrasts', {}, 'thresh', {}, 'mtype', {});

job{4}.spm.stats.results.conspec(2).titlestr = '';
job{4}.spm.stats.results.conspec(2).contrasts = 2;
job{4}.spm.stats.results.conspec(2).threshdesc = 'none';
job{4}.spm.stats.results.conspec(2).thresh = 0.001;
job{4}.spm.stats.results.conspec(2).extent = 0;
job{4}.spm.stats.results.conspec(2).mask = ...
    struct('contrasts', {}, 'thresh', {}, 'mtype', {});

job{4}.spm.stats.results.conspec(3).titlestr = '';
job{4}.spm.stats.results.conspec(3).contrasts = 3;
job{4}.spm.stats.results.conspec(3).threshdesc = 'none';
job{4}.spm.stats.results.conspec(3).thresh = 0.001;
job{4}.spm.stats.results.conspec(3).extent = 0;
job{4}.spm.stats.results.conspec(3).mask = ...
    struct('contrasts', {}, 'thresh', {}, 'mtype', {});


job{4}.spm.stats.results.units = 2;
job{4}.spm.stats.results.print = []; % Disable PDF output (GA 16/11/2023)
job{4}.spm.stats.results.write.none = 1;


end