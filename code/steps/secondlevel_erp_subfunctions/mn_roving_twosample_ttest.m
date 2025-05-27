function [ job ] = mn_roving_twosample_ttest(facdir, icell, covariates)
%TNUEEG_GETJOB_2NDLEVEL_TWOSAMPLE_TTEST Creates a job for running a
%two-sample t-test on the second level for the effect of factorName.
%   IN:     facdir      - directory (string) for saving the SPM.mat
%           scans       - cell array list of image filenames, including paths
%           factorName  - string with a name for the effect
%   OUT:    job         - the job for the 2nd level statistics that can be
%                       run using the spm_jobman

% job 1: factorial design
job{1}.spm.stats.factorial_design.dir = {facdir};
job{1}.spm.stats.factorial_design.des.t2.scans1 = icell(2).scans;
job{1}.spm.stats.factorial_design.des.t2.scans2 = icell(4).scans;
%% Load covariate

     job{1}.spm.stats.factorial_design.cov(1).c = covariates.DE; 
     job{1}.spm.stats.factorial_design.cov(1).cname = 'DE';
     job{1}.spm.stats.factorial_design.cov(1).iCFI = 1;
     job{1}.spm.stats.factorial_design.cov(1).iCC = 1;
     job{1}.spm.stats.factorial_design.cov(2).c = covariates.EU;
     job{1}.spm.stats.factorial_design.cov(2).cname = 'EU';
     job{1}.spm.stats.factorial_design.cov(2).iCFI = 1;
     job{1}.spm.stats.factorial_design.cov(2).iCC = 1;
     job{1}.spm.stats.factorial_design.cov(3).c = covariates.SP;
     job{1}.spm.stats.factorial_design.cov(3).cname = 'SP';
     job{1}.spm.stats.factorial_design.cov(3).iCFI = 1;
     job{1}.spm.stats.factorial_design.cov(3).iCC = 1;
     job{1}.spm.stats.factorial_design.cov(4).c = covariates.BS;
     job{1}.spm.stats.factorial_design.cov(4).cname = 'BS';
     job{1}.spm.stats.factorial_design.cov(4).iCFI = 1;
     job{1}.spm.stats.factorial_design.cov(4).iCC = 1;
     job{1}.spm.stats.factorial_design.cov(5).c = covariates.IN;
     job{1}.spm.stats.factorial_design.cov(5).cname = 'IN';
     job{1}.spm.stats.factorial_design.cov(5).iCFI = 1;
     job{1}.spm.stats.factorial_design.cov(5).iCC = 1;
     job{1}.spm.stats.factorial_design.cov(6).c = covariates.CP;
     job{1}.spm.stats.factorial_design.cov(6).cname = 'CP';
     job{1}.spm.stats.factorial_design.cov(6).iCFI = 1;
     job{1}.spm.stats.factorial_design.cov(6).iCC = 1;
     job{1}.spm.stats.factorial_design.cov(7).c = covariates.EI;
     job{1}.spm.stats.factorial_design.cov(7).cname = 'EI';
     job{1}.spm.stats.factorial_design.cov(7).iCFI = 1;
     job{1}.spm.stats.factorial_design.cov(7).iCC = 1;
     job{1}.spm.stats.factorial_design.cov(8).c = covariates.CI;
     job{1}.spm.stats.factorial_design.cov(8).cname = 'CI';
     job{1}.spm.stats.factorial_design.cov(8).iCFI = 1;
     job{1}.spm.stats.factorial_design.cov(8).iCC = 1;
     job{1}.spm.stats.factorial_design.cov(9).c = covariates.AV;
     job{1}.spm.stats.factorial_design.cov(9).cname = 'AV';
     job{1}.spm.stats.factorial_design.cov(9).iCFI = 1;
     job{1}.spm.stats.factorial_design.cov(9).iCC = 1;
     job{1}.spm.stats.factorial_design.cov(10).c = covariates.ICC;
     job{1}.spm.stats.factorial_design.cov(10).cname = 'ICC';
     job{1}.spm.stats.factorial_design.cov(10).iCFI = 1;
     job{1}.spm.stats.factorial_design.cov(10).iCC = 1;
     job{1}.spm.stats.factorial_design.cov(11).c = covariates.AX;
     job{1}.spm.stats.factorial_design.cov(11).cname = 'AX';
     job{1}.spm.stats.factorial_design.cov(11).iCFI = 1;
     job{1}.spm.stats.factorial_design.cov(11).iCC = 1;
     job{1}.spm.stats.factorial_design.cov(12).c = covariates.GASC;
     job{1}.spm.stats.factorial_design.cov(12).cname = 'GASC';
     job{1}.spm.stats.factorial_design.cov(12).iCFI = 1;
     job{1}.spm.stats.factorial_design.cov(12).iCC = 1;
% 
 %----------------------------------------------------------------------
 % Covariates
 %----------------------------------------------------------------------


    job{1}.spm.stats.con.consess{1}.fcon.name = 'DE';
    job{1}.spm.stats.con.consess{1}.fcon.convec = [0 0 1]; 
    job{1}.spm.stats.con.consess{1}.fcon.sessrep = 'none';
    job{1}.spm.stats.con.consess{2}.fcon.name = 'EI';
    job{1}.spm.stats.con.consess{2}.fcon.convec = [0 0 0 1];
    job{1}.spm.stats.con.consess{2}.fcon.sessrep = 'none';
    job{1}.spm.stats.con.consess{3}.fcon.name = 'ICC';
    job{1}.spm.stats.con.consess{3}.fcon.convec = [0 0 0 0 1];
    job{1}.spm.stats.con.consess{3}.fcon.sessrep = 'none';
    job{1}.spm.stats.con.consess{4}.fcon.name = 'BS';
    job{1}.spm.stats.con.consess{4}.fcon.convec = [0 0 0 0 0 1];
    job{1}.spm.stats.con.consess{4}.fcon.sessrep = 'none';
    job{1}.spm.stats.con.consess{5}.fcon.name = 'IN';
    job{1}.spm.stats.con.consess{5}.fcon.convec = [0 0 0 0 0 0 1];
    job{1}.spm.stats.con.consess{5}.fcon.sessrep = 'none';
    job{1}.spm.stats.con.consess{6}.fcon.name = 'CP';
    job{1}.spm.stats.con.consess{6}.fcon.convec = [0 0 0 0 0 0 0 1];
    job{1}.spm.stats.con.consess{6}.fcon.sessrep = 'none';
    job{1}.spm.stats.con.consess{7}.fcon.name = 'EI';
    job{1}.spm.stats.con.consess{7}.fcon.convec = [0 0 0 0 0 0 0 0 1];
    job{1}.spm.stats.con.consess{7}.fcon.sessrep = 'none';
    job{1}.spm.stats.con.consess{8}.fcon.name = 'CI';
    job{1}.spm.stats.con.consess{8}.fcon.convec = [0 0 0 0 0 0 0 0 0 1];
    job{1}.spm.stats.con.consess{8}.fcon.sessrep = 'none';
    job{1}.spm.stats.con.consess{9}.fcon.name = 'AV';
    job{1}.spm.stats.con.consess{9}.fcon.convec = [0 0 0 0 0 0 0 0 0 1];
    job{1}.spm.stats.con.consess{9}.fcon.sessrep = 'none';
    job{1}.spm.stats.con.consess{10}.fcon.name = 'ICC';
    job{1}.spm.stats.con.consess{10}.fcon.convec = [0 0 0 0 0 0 0 0 0 0 0 1];
    job{1}.spm.stats.con.consess{10}.fcon.sessrep = 'none';
    job{1}.spm.stats.con.consess{11}.fcon.name = 'AX';
    job{1}.spm.stats.con.consess{11}.fcon.convec = [0 0 0 0 0 0 0 0 0 0 0 1];
    job{1}.spm.stats.con.consess{11}.fcon.sessrep = 'none';
    job{1}.spm.stats.con.consess{12}.fcon.name = 'GASC';
    job{1}.spm.stats.con.consess{12}.fcon.convec = [0 0 0 0 0 0 0 0 0 0 0 0 1];
    job{1}.spm.stats.con.consess{12}.fcon.sessrep = 'none';

    job{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
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

 %----------------------------------------------------------------------
    % Follow-up all designs
    %----------------------------------------------------------------------
    % T-tests
    % job{3}.spm.stats.con.consess{1}.tcon.name = ['mmn' '_pos'];
    % job{3}.spm.stats.con.consess{1}.tcon.weights = [1 1];
    % job{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    % job{3}.spm.stats.con.consess{2}.tcon.name = ['mmn' '_neg'];
    % job{3}.spm.stats.con.consess{2}.tcon.weights = [-1 -1];
    % job{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    job{3}.spm.stats.con.consess{1}.fcon.name = ['Effect of ' 'mmn'];
    job{3}.spm.stats.con.consess{1}.fcon.weights =  [1 1];
    job{3}.spm.stats.con.consess{1}.fcon.sessrep = 'none';
    job{3}.spm.stats.con.delete = 0;

% job 4: print results
job{4}.spm.stats.results.spmmat(1) = ...
    cfg_dep('Contrast Manager: SPM.mat File', ...
    substruct('.','val', '{}',{3}, ...
            '.','val', '{}',{1}, ...
            '.','val', '{}',{1}), ...
            substruct('.','spmmat'));



% job{4}.spm.stats.results.conspec(3).titlestr = '';
% job{4}.spm.stats.results.conspec(3).contrasts = 3;
% job{4}.spm.stats.results.conspec(3).threshdesc = 'none';
% job{4}.spm.stats.results.conspec(3).thresh = 0.001;
% job{4}.spm.stats.results.conspec(3).extent = 0;
% job{4}.spm.stats.results.conspec(3).mask = ...
%     struct('contrasts', {}, 'thresh', {}, 'mtype', {});


job{4}.spm.stats.results.units = 2;
job{4}.spm.stats.results.print = []; % Disable PDF output (GA 16/11/2023)
job{4}.spm.stats.results.write.none = 1;

% Which modules really to include?
 actual_job = {job{1},job{2},job{3},job{4}};



% Execute actual_job
spm('defaults', 'EEG');
spm_jobman('initcfg');
spm_jobman('run', actual_job);
end