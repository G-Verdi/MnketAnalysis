function mn_full_factorial_modelbased_ANCOVA(icell, scndlvlroot,covariates,design, options, doDeleteExisting)
%--------------------------------------------------------------------------
% Description goes here.
%
%
%
%--------------------------------------------------------------------------
%% Defaults
if nargin < 3
    doDeleteExisting = true;
end


%% Main
switch options.eeg.stats.mode
    case {'modelbased'}
        regressors = options.eeg.stats.regressors{design};
    case {'erpbased'}
        %regressors = {options.eeg.erp.type{design}};
        regressors = options.eeg.stats.regressors{design};
end

% delete previous results, if wanted
if doDeleteExisting
    rmdir(scndlvlroot, 's');
    mkdir(scndlvlroot);   
end


%% # Change the following if you want to run multiple analyses for different betas
for r = 1:numel(regressors)
    %Select regressor
    regressor = regressors{r};
    files = icell;
    
    switch options.eeg.stats.mode
        case 'modelbased'
            switch regressor
                case'epsilon2'
                    fname = fullfile('beta_0002.nii'); % Chose regressor +1 (since first regressor is the mean)
                    for i = 1:numel(icell)
                        files(i).scans = fullfile(icell(i).scans, fname);
                    end
                case 'epsilon3'
                     fname = fullfile('beta_0003.nii'); % Chose regressor +1 (since first regressor is the mean)
                     for i = 1:numel(icell)
                         files(i).scans = fullfile(icell(i).scans, fname);
                     end
                case 'pihat1'
                        fname = fullfile('beta_0002.nii'); % Chose regressor +1 (since first regressor is the mean)
                        for i = 1:numel(icell)
                            files(i).scans = fullfile(icell(i).scans, fname);
                        end
                case'pihat2'
                         fname = fullfile('beta_0003.nii'); % Chose regressor +1 (since first regressor is the mean)
                         for i = 1:numel(icell)
                             files(i).scans = fullfile(icell(i).scans, fname);
                         end
                case'pihat3'
                         fname = fullfile('beta_0004.nii'); % Chose regressor +1 (since first regressor is the mean)
                         for i = 1:numel(icell)
                             files(i).scans = fullfile(icell(i).scans, fname);
                         end

            end
    end
         

    % Initialize
    spm('defaults', 'EEG');
    spm_jobman('initcfg');
    which spm
    
    switch options.eeg.stats.mode
        case {'modelbased'}
            outputpath = fullfile(scndlvlroot,regressor);
            mkdir(outputpath);
        case {'erpbased'}
            outputpath=strcat(scndlvlroot);
            mkdir(outputpath)
    end
    cd(outputpath);
    


    %% Two sample t-test Design

     % Use the active drug images
     job{1}.spm.stats.factorial_design.des.t2.scans1 = files(3).scans;
     job{1}.spm.stats.factorial_design.des.t2.scans2 = files(4).scans;

    
    job{1}.spm.stats.factorial_design.des.t2.dept = 0;
    job{1}.spm.stats.factorial_design.des.t2.variance = 1;
    job{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
    job{1}.spm.stats.factorial_design.des.t2.ancova = 0;
    %% Load Covariates
    job{1}.spm.stats.factorial_design.dir = {outputpath};
    job{1}.spm.stats.factorial_design.cov(1).c = [72.6667
                                                          83.6667
                                                          34.6667
                                                          13
                                                          28.3333
                                                          0
                                                          31.6667
                                                          0
                                                          15.6667
                                                          36.6667
                                                          87.3333
                                                          56.3333
                                                          32.6667
                                                          28.3333
                                                          59
                                                          28.6667
                                                          97.6667
                                                          34.6667
                                                          25.6667
                                                          11.3333
                                                          7
                                                          51
                                                          5
                                                          0
                                                          14.6667
                                                          6
                                                          4.33333
                                                          0
                                                          8
                                                          34.3333
                                                          21
                                                          1
                                                          4.66667
                                                          5
                                                          15.3333];
    %
    job{1}.spm.stats.factorial_design.cov(1).cname = 'DE';
    job{1}.spm.stats.factorial_design.cov(1).iCFI = 2;
    job{1}.spm.stats.factorial_design.cov(1).iCC = 1;
%     %%
    job{1}.spm.stats.factorial_design.cov(2).c = [94
                                                          0
                                                          10.3333
                                                          6
                                                          0
                                                          0
                                                          5.66667
                                                          0
                                                          1.33333
                                                          0
                                                          0
                                                          39.3333
                                                          0
                                                          19
                                                          32.3333
                                                          0
                                                          21
                                                          7.33333
                                                          22
                                                          12.6667
                                                          36
                                                          48.3333
                                                          1.33333
                                                          4.33333
                                                          37.3333
                                                          7.33333
                                                          53.6667
                                                          0
                                                          51
                                                          51.3333
                                                          56.3333
                                                          6
                                                          0
                                                          13.3333
                                                          68.3333];
    %%
    job{1}.spm.stats.factorial_design.cov(2).cname = 'EI';
    job{1}.spm.stats.factorial_design.cov(2).iCFI = 2;
    job{1}.spm.stats.factorial_design.cov(2).iCC = 1;
%     %%
    job{1}.spm.stats.factorial_design.cov(3).c = [50.428
                                                          37.8571
                                                          30.7143
                                                          1.14286
                                                          44.2857
                                                          9
                                                          23.7143
                                                          16
                                                          3.57143
                                                          27
                                                          13.1429
                                                          60.2857
                                                          30.2857
                                                          34.4286
                                                          33.8571
                                                          29.4286
                                                          48.4286
                                                          44.4286
                                                          43.1429
                                                          42
                                                          14
                                                          5.85714
                                                          6.28571
                                                          0.714285
                                                          5.71429
                                                          12.4286
                                                          14
                                                          18.7143
                                                          3
                                                          39.7143
                                                          6
                                                          1
                                                          17.7143
                                                          23.2857
                                                          50.5714];
    %
    job{1}.spm.stats.factorial_design.cov(3).cname = 'ICC';
    job{1}.spm.stats.factorial_design.cov(3).iCFI = 2;
    job{1}.spm.stats.factorial_design.cov(3).iCC = 1;
    job{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
    job{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
    job{1}.spm.stats.factorial_design.masking.im = 1;
    job{1}.spm.stats.factorial_design.masking.em = {''};
    job{1}.spm.stats.factorial_design.globalc.g_omit = 1;
    job{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
    job{1}.spm.stats.factorial_design.globalm.glonorm = 1;
    job{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    job{2}.spm.stats.fmri_est.write_residuals = 0;
    job{2}.spm.stats.fmri_est.method.Classical = 1;
    job{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));

     %% Contrast: F-tests
    job{3}.spm.stats.con.consess{1}.fcon.name = [regressor ': DE'];
    job{3}.spm.stats.con.consess{1}.fcon.weights = [0 0 1 1];
    job{3}.spm.stats.con.consess{1}.fcon.sessrep = 'none';
    job{3}.spm.stats.con.consess{2}.fcon.name = [regressor ': EI'];
    job{3}.spm.stats.con.consess{2}.fcon.weights = [0 0 0 0 1 1];
    job{3}.spm.stats.con.consess{2}.fcon.sessrep = 'none';
    job{3}.spm.stats.con.consess{3}.fcon.name = [regressor ': ICC'];
    job{3}.spm.stats.con.consess{3}.fcon.weights = [0 0 0 0 0 0 1 1];
    job{3}.spm.stats.con.consess{3}.fcon.sessrep = 'none';
    job{3}.spm.stats.con.consess{4}.fcon.name = [regressor ': ket vs psi'];
    job{3}.spm.stats.con.consess{4}.fcon.weights = [1 -1];
    job{3}.spm.stats.con.consess{4}.fcon.sessrep = 'none';
    job{3}.spm.stats.con.consess{5}.fcon.name = [regressor ': psi vs ket'];
    job{3}.spm.stats.con.consess{5}.fcon.weights = [-1 1];
    job{3}.spm.stats.con.consess{5}.fcon.sessrep = 'none';

    job{3}.spm.stats.con.consess{6}.tcon.name = [regressor ': ket>psi'];
    job{3}.spm.stats.con.consess{6}.tcon.weights = [1 -1];
    job{3}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
    job{3}.spm.stats.con.consess{7}.tcon.name = [regressor ': ket<psi'];
    job{3}.spm.stats.con.consess{7}.tcon.weights = [-1 1];
    job{3}.spm.stats.con.consess{7}.tcon.sessrep = 'none';

    %% 2 sample t-tests
    job{3}.spm.stats.con.consess{8}.tcon.name = [regressor 'DE: ket>psi'];
    job{3}.spm.stats.con.consess{8}.tcon.weights = [0 0 1 -1];
    job{3}.spm.stats.con.consess{8}.tcon.sessrep = 'none';    
    job{3}.spm.stats.con.consess{9}.tcon.name = [regressor 'DE: ket<psi'];
    job{3}.spm.stats.con.consess{9}.tcon.weights = [0 0 -1 1];
    job{3}.spm.stats.con.consess{9}.tcon.sessrep = 'none';
    job{3}.spm.stats.con.consess{10}.tcon.name = [regressor 'EI: ket>psi'];
    job{3}.spm.stats.con.consess{10}.tcon.weights = [0 0 0 0 1 -1];
    job{3}.spm.stats.con.consess{10}.tcon.sessrep = 'none';
    job{3}.spm.stats.con.consess{11}.tcon.name = [regressor 'EI: ket<psi'];
    job{3}.spm.stats.con.consess{11}.tcon.weights = [0 0 0 0 -1 1];
    job{3}.spm.stats.con.consess{11}.tcon.sessrep = 'none';
    job{3}.spm.stats.con.consess{12}.tcon.name = [regressor 'ICC: ket>psi'];
    job{3}.spm.stats.con.consess{12}.tcon.weights = [0 0 0 0 0 0 1 -1];
    job{3}.spm.stats.con.consess{12}.tcon.sessrep = 'none';
    job{3}.spm.stats.con.consess{13}.tcon.name = [regressor 'ICC: ket<psi'];
    job{3}.spm.stats.con.consess{13}.tcon.weights = [0 0 0 0 0 0 -1 1];
    job{3}.spm.stats.con.consess{13}.tcon.sessrep = 'none';

    % T-tests: Positive and negative one-sample of each covariates 

    job{3}.spm.stats.con.consess{14}.tcon.name = [regressor ': Positive DE in ket'];
    job{3}.spm.stats.con.consess{14}.tcon.weights = [0 0 1];
    job{3}.spm.stats.con.consess{14}.tcon.sessrep = 'none';    
    job{3}.spm.stats.con.consess{15}.tcon.name = [regressor 'Positive: DE in psi'];
    job{3}.spm.stats.con.consess{15}.tcon.weights = [0 0 0 1];
    job{3}.spm.stats.con.consess{15}.tcon.sessrep = 'none'; 
    job{3}.spm.stats.con.consess{16}.tcon.name = [regressor 'Negative: DE in ket'];
    job{3}.spm.stats.con.consess{16}.tcon.weights = [0 0 -1 0];
    job{3}.spm.stats.con.consess{16}.tcon.sessrep = 'none'; 
    job{3}.spm.stats.con.consess{17}.tcon.name = [regressor 'Negative: DE in psi'];
    job{3}.spm.stats.con.consess{17}.tcon.weights = [0 0 0 -1];
    job{3}.spm.stats.con.consess{17}.tcon.sessrep = 'none'; 
    job{3}.spm.stats.con.consess{18}.tcon.name = [regressor 'Positive: EI in ket'];
    job{3}.spm.stats.con.consess{18}.tcon.weights = [0 0 0 0 1];
    job{3}.spm.stats.con.consess{18}.tcon.sessrep = 'none'; 
    job{3}.spm.stats.con.consess{19}.tcon.name = [regressor 'Positive: EI in psi'];
    job{3}.spm.stats.con.consess{19}.tcon.weights = [0 0 0 0 0 1];
    job{3}.spm.stats.con.consess{19}.tcon.sessrep = 'none'; 
    job{3}.spm.stats.con.consess{20}.tcon.name = [regressor 'Negative: EI in ket'];
    job{3}.spm.stats.con.consess{20}.tcon.weights = [0 0 0 0 -1];
    job{3}.spm.stats.con.consess{20}.tcon.sessrep = 'none'; 
    job{3}.spm.stats.con.consess{21}.tcon.name = [regressor 'Negative: EI in psi'];
    job{3}.spm.stats.con.consess{21}.tcon.weights = [0 0 0 0 0 -1];
    job{3}.spm.stats.con.consess{21}.tcon.sessrep = 'none'; 
    job{3}.spm.stats.con.consess{22}.tcon.name = [regressor 'Positive: ICC in ket'];
    job{3}.spm.stats.con.consess{22}.tcon.weights = [0 0 0 0 0 0 1];
    job{3}.spm.stats.con.consess{22}.tcon.sessrep = 'none'; 
    job{3}.spm.stats.con.consess{23}.tcon.name = [regressor 'Positive: ICC in psi'];
    job{3}.spm.stats.con.consess{23}.tcon.weights = [0 0 0 0 0 0 0 1];
    job{3}.spm.stats.con.consess{23}.tcon.sessrep = 'none'; 
    job{3}.spm.stats.con.consess{24}.tcon.name = [regressor 'Negative: ICC in ket'];
    job{3}.spm.stats.con.consess{24}.tcon.weights = [0 0 0 0 0 0 -1];
    job{3}.spm.stats.con.consess{24}.tcon.sessrep = 'none'; 
    job{3}.spm.stats.con.consess{25}.tcon.name = [regressor 'Negative: ICC in psi'];
    job{3}.spm.stats.con.consess{25}.tcon.weights = [0 0 0 0 0 0 0 -1];
    job{3}.spm.stats.con.consess{25}.tcon.sessrep = 'none'; 
    job{3}.spm.stats.con.consess{26}.tcon.name = [regressor 'EI'];
    job{3}.spm.stats.con.consess{26}.tcon.weights = [0 0 0 0 1 1 0 0];
    job{3}.spm.stats.con.consess{26}.tcon.sessrep = 'none'; 
    


    
    job{3}.spm.stats.con.delete = 1;
    job{4}.spm.stats.results.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    job{4}.spm.stats.results.conspec.titlestr = '';
    job{4}.spm.stats.results.conspec.contrasts = Inf;
    job{4}.spm.stats.results.conspec.threshdesc = 'none';
    job{4}.spm.stats.results.conspec.thresh = 0.001;
    job{4}.spm.stats.results.conspec.extent = 0;
    job{4}.spm.stats.results.conspec.conjunction = 1;
    job{4}.spm.stats.results.conspec.mask.none = 1;
    job{4}.spm.stats.results.units = 2;
    job{4}.spm.stats.results.print = 'pdf';
    job{4}.spm.stats.results.write.none = 1;
    job{4}.spm.stats.results.export = {};

    % Which modules really to include?
     actual_job = {job{1},job{2},job{3},job{4}};
    
    % Execute actual_job
    spm_jobman('interactive', actual_job);


        
    end

