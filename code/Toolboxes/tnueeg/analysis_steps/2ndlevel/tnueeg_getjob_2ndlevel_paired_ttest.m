function [ job ] = tnueeg_getjob_2ndlevel_paired_ttest(facdir, pairs, factorName, label1, label2)
%TNUEEG_GETJOB_2NDLEVEL_PAIRED_TTEST Creates a job for running a paired
%t-test on the 2nd level for testing differences in the effect of the
%factorName across groups, drug conditions or time points.
%   IN:     facdir      - directory (string) for saving the SPM.mat
%           pairs       - cell array list of image filenames, including paths
%           regressor   - string with name of the regressor
%   OUT:    job         - the job for the 2nd level statistics that can be
%                       run using the spm_jobman

% job 1: factorial design
job{1}.spm.stats.factorial_design.dir = {facdir};

job{1}.spm.stats.factorial_design.des.pt.pair = pairs;
job{1}.spm.stats.factorial_design.des.pt.gmsca = 0;
job{1}.spm.stats.factorial_design.des.pt.ancova = 0;

 % Load Covariates
job{1}.spm.stats.factorial_design.cov(1).c = [0
11.333333
0
7
0
51
0.333333
5
0
0
0.666666
14.666666
2
6
0
4.333333
0
0
0
8
0
34.333333
0
21
0.666666
1
0
4.666666
0.666666
5
1.666666
15.333333];

    job{1}.spm.stats.factorial_design.cov(1).cname = 'DE';
    job{1}.spm.stats.factorial_design.cov(1).iCFI = 2;
    job{1}.spm.stats.factorial_design.cov(1).iCC = 1;


    job{1}.spm.stats.factorial_design.cov(2).c = [0
60.6
0
3
0
36.4
0
19.8
0
0
0.6
0.8
1.6
27.6
0
11.8
0
20
0
27.4
0
51.8
0
2
1
4
0
2
0.4
7.6
1
3.8];

    job{1}.spm.stats.factorial_design.cov(2).cname = 'EU';
    job{1}.spm.stats.factorial_design.cov(2).iCFI = 2;
    job{1}.spm.stats.factorial_design.cov(2).iCC = 1;

    job{1}.spm.stats.factorial_design.cov(3).c = [0
34
0
11.666666
0
43.333333
0.666666
1.666666
0
0
0.666666
1
1.666666
3
0
0
0
0
0
15.666666
0
0
0
0
1
0.333333
0.333333
0
0.333333
0.666666
1
24.666666];
    %%
    job{1}.spm.stats.factorial_design.cov(3).cname = 'SP';
    job{1}.spm.stats.factorial_design.cov(3).iCFI = 2;
    job{1}.spm.stats.factorial_design.cov(3).iCC = 1;


    job{1}.spm.stats.factorial_design.cov(4).c = [0
51
0
13.333333
0
29.333333
0.666666
38
0
0
0.333333
32
2.333333
21.666666
0
21.666666
0
8.666666
0
60.666666
0
29.333333
0
17.333333
1
11.333333
0
14.666666
3
1
1.333333
72.333333];
    %%
    job{1}.spm.stats.factorial_design.cov(4).cname = 'BS';
    job{1}.spm.stats.factorial_design.cov(4).iCFI = 2;
    job{1}.spm.stats.factorial_design.cov(4).iCC = 1;

    job{1}.spm.stats.factorial_design.cov(5).c = [0
63
0
47.333333
0
89.333333
1
11
0
6.666666
1
0
2.333333
17
0
6.333333
0
0
0
28.333333
0
10
0
0
1
3.333333
0
0
0
2.333333
1
1.666666];
    %
    job{1}.spm.stats.factorial_design.cov(5).cname = 'IN';
    job{1}.spm.stats.factorial_design.cov(5).iCFI = 2;
    job{1}.spm.stats.factorial_design.cov(5).iCC = 1;
    job{1}.spm.stats.factorial_design.cov(6).c = [0
40.333333
0
58.333333
0
39.666666
0.666666
30
0
6.666666
0.333333
15
1.666666
64
0
0
0
32.666666
0
36.666666
0
56.666666
0
16
0.333333
3.666666
0
18.666666
0.666666
9.333333
1.333333
58];
    %
    job{1}.spm.stats.factorial_design.cov(6).cname = 'CMP';
    job{1}.spm.stats.factorial_design.cov(6).iCFI = 2;
    job{1}.spm.stats.factorial_design.cov(6).iCC = 1;
    job{1}.spm.stats.factorial_design.cov(7).c = [0
12.666666
0
36
0
48.333333
0
1.333333
0
4.333333
1.333333
37.333333
1.666666
7.333333
0
53.666666
0
0
0
51
0
51.333333
0
56.333333
0.333333
6
0
0
0
13.333333
0.666666
68.333333];
    %
    job{1}.spm.stats.factorial_design.cov(7).cname = 'EI';
    job{1}.spm.stats.factorial_design.cov(7).iCFI = 2;
    job{1}.spm.stats.factorial_design.cov(7).iCC = 1;

    job{1}.spm.stats.factorial_design.cov(8).c = [0
41.333333
0
25.333333
0
57.666666
0.666666
22
0
15.666666
1
1.666666
2
21
0
0
0
0
0
43
0
39.666666
0
0.666666
0.333333
1.666666
0
5
0
1.333333
1.666666
59.666666];

    job{1}.spm.stats.factorial_design.cov(8).cname = 'CI';
    job{1}.spm.stats.factorial_design.cov(8).iCFI = 2;
    job{1}.spm.stats.factorial_design.cov(8).iCC = 1;

    job{1}.spm.stats.factorial_design.cov(9).c = [0
0.666666
0
76
0
17
0.666666
20
0
0
1
38.666666
1.666666
65.333333
0
8.333333
0
0
0
76.333333
0
24.666666
0
6.333333
0.666666
4.666666
5.333333
12.333333
0.333333
4.666666
1
96.333333];

    job{1}.spm.stats.factorial_design.cov(9).cname = 'AV';
    job{1}.spm.stats.factorial_design.cov(9).iCFI = 2;
    job{1}.spm.stats.factorial_design.cov(9).iCC = 1;

    job{1}.spm.stats.factorial_design.cov(10).c = [0
0.333333
0
9.166666
0
0.166666
0.666666
0
0
0
1
0.833333
1.666666
12.166666
0
0
0
0
0
0.5
0
1
0
0
0.5
0.333333
0
0
0.166666
1
1.166666
36.666666];

    job{1}.spm.stats.factorial_design.cov(10).cname = 'AX';
    job{1}.spm.stats.factorial_design.cov(10).iCFI = 2;
    job{1}.spm.stats.factorial_design.cov(10).iCC = 1;


    job{1}.spm.stats.factorial_design.cov(11).c = [0
39.571428
0
14.714285
0.285714
49.571428
0.285714
14.571428
0
0
2
11.571428
2
34
0
15
0
15.571428
0
36.857142
0
37
0
20.714285
1
9.571428
0.142857
7.714285
2.285714
8.857142
1.714285
24.285714];

    job{1}.spm.stats.factorial_design.cov(11).cname = 'PD';
    job{1}.spm.stats.factorial_design.cov(11).iCFI = 2;
    job{1}.spm.stats.factorial_design.cov(11).iCC = 1;

    job{1}.spm.stats.factorial_design.cov(12).c = [0
28.5
0
5.75
0
61
0.5
8.75
0
0
0.5
11.5
1.75
8.75
0
3.25
0
0
0
9
0
26.5
0
15.75
0.75
0.75
0
3.5
0.75
4.25
1.5
12];

    job{1}.spm.stats.factorial_design.cov(12).cname = 'PDP';
    job{1}.spm.stats.factorial_design.cov(12).iCFI = 2;
    job{1}.spm.stats.factorial_design.cov(12).iCC = 1;

% 
    job{1}.spm.stats.factorial_design.cov(13).c = [0
27.37878764
0
38.00822473
0
14.09870118
0.536796091
3.095237818
0
13.42554082
0.799133909
23.41168809
1.859739818
10.92121191
0
7.277056091
0
31.86969673
0
30.77402564
0.480519455
11.42424227
0
3.393939091
0.712121
6.822510545
0.619047545
6.322943455
0.506060364
44.30649309
1.205627364
0];
    job{1}.spm.stats.factorial_design.cov(13).cname = 'GASC';
    job{1}.spm.stats.factorial_design.cov(13).iCFI = 2;
    job{1}.spm.stats.factorial_design.cov(13).iCC = 1;



 %     job{1}.spm.stats.factorial_design.cov(1).c = [0
% 42
% 0
% 14
% 0
% 5.857142
% 0.571428
% 6.285714
% 0
% 0.714285
% 0.857142
% 5.714285
% 1.857142
% 12.428571
% 0
% 14
% 0
% 18.714285
% 0
% 3
% 5.285714
% 39.714285
% 0
% 6
% 1
% 1
% 1.142857
% 17.714285
% 0
% 23.285714
% 1.428571
% 50.571428];
% 
%     job{1}.spm.stats.factorial_design.cov(1).cname = 'ICC'; %Note: collinearity between DE and ICC s
%     job{1}.spm.stats.factorial_design.cov(1).iCFI = 2;
%     job{1}.spm.stats.factorial_design.cov(1).iCC = 1;

    job{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
    job{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
    job{1}.spm.stats.factorial_design.masking.im = 1;
    job{1}.spm.stats.factorial_design.masking.em = {''};
    job{1}.spm.stats.factorial_design.globalc.g_omit = 1;
    job{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
    job{1}.spm.stats.factorial_design.globalm.glonorm = 1;




% job{1}.spm.stats.factorial_design.cov = ...
%     struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
% job{1}.spm.stats.factorial_design.multi_cov = ...
%     struct('files', {}, 'iCFI', {}, 'iCC', {});
% job{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
% job{1}.spm.stats.factorial_design.masking.im = 1;
% job{1}.spm.stats.factorial_design.masking.em = {''};
% job{1}.spm.stats.factorial_design.globalc.g_omit = 1;
% job{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
% job{1}.spm.stats.factorial_design.globalm.glonorm = 1;

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
job{3}.spm.stats.con.consess{1}.tcon.name = [factorName ': ' label1 ' > ' label2];
job{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0];
job{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
job{3}.spm.stats.con.consess{2}.tcon.name = [factorName ': ' label1 ' < ' label2];
job{3}.spm.stats.con.consess{2}.tcon.weights = [-1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
job{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
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


job{4}.spm.stats.results.units = 2;
job{4}.spm.stats.results.print = 'pdf'; % Disable PDF output, (GA 16/11/2023) % Renabled (GA 24/02/2024)
job{4}.spm.stats.results.write.none = 1;



end