function mn_full_factorial_modelbased_DI(icell, scndlvlroot,covariates,design, options, doDeleteExisting)
%--------------------------------------------------------------------------
% 
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
                case 'epsilon2'
                    fname = fullfile('beta_0002.nii'); % Chose regressor +1 (since first regressor is the mean)
                    for i = 1:numel(icell)
                        files(i).scans = fullfile(icell(i).scans, fname);
                    end
                case  'epsilon3'
                     fname = fullfile('beta_0003.nii'); % Chose regressor +1 (since first regressor is the mean)
                     for i = 1:numel(icell)
                         files(i).scans = fullfile(icell(i).scans, fname);
                     end
                case 'pihat1'
                    fname = fullfile('beta_0002.nii'); % Chose regressor +1 (since first regressor is the mean)
                    for i = 1:numel(icell)
                        files(i).scans = fullfile(icell(i).scans, fname);
                    end

                case 'pihat2'
                     fname = fullfile('beta_0003.nii'); % Chose regressor +1 (since first regressor is the mean)
                     for i = 1:numel(icell)
                         files(i).scans = fullfile(icell(i).scans, fname);
                     end

                case 'pihat3'
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


    %% Calculate difference images 

    % Create cell arrays for input images
    input_pla_ket_images = cell(19, 1); 
    input_drug_ket_images = cell(19, 1); 
    input_pla_psi_images = cell(16, 1); 
    input_drug_psi_images = cell(16, 1); 
    
    % Define input images
    for i = 1:19
        input_pla_ket_images{i} = [files(1).scans{i}];
        input_drug_ket_images{i} = [files(3).scans{i}];
    end

    for i = 1:16
        input_pla_psi_images{i} = [files(2).scans{i}];
        input_drug_psi_images{i} = [files(4).scans{i}];
    end

    % Output filenames
    output_filenames_mnket = cell(19, 1);
    output_filenames_mnpsi = cell(16, 1);
    
    for i = 1:19
        output_filenames_mnket{i} = fullfile(outputpath, ['difference_image_ket', '_' regressor '_', num2str(i) '.nii']);
    end
    
    for i = 1:16
        output_filenames_mnpsi{i} = fullfile(outputpath, ['difference_image_psi', '_' regressor '_', num2str(i) '.nii']);
    end
    
    % Define expression for imcalc
    expression = '(i1 - i2)';  % We are looking at placebo - drug 
     
    % Run imcalc for each pair of images:mnket group
    for i = 1:19
        spm_imcalc({input_pla_ket_images{i}, input_drug_ket_images{i}}, output_filenames_mnket{i}, expression);
    end

    % Run imcalc for each pair of images:mnpsi group
    for i = 1:16
        spm_imcalc({input_pla_psi_images{i}, input_drug_psi_images{i}}, output_filenames_mnpsi{i}, expression);
    end
    
    disp('imcalc operations completed.');
    
    DI_files(1).scans = output_filenames_mnket;
    DI_files(2).scans = output_filenames_mnpsi;
    
     %% Two sample t-test Design

    job{1}.spm.stats.factorial_design.des.t2.scans1 = DI_files(1).scans;
    job{1}.spm.stats.factorial_design.des.t2.scans2 = DI_files(2).scans;

    
    job{1}.spm.stats.factorial_design.des.t2.dept = 0;
    job{1}.spm.stats.factorial_design.des.t2.variance = 1;
    job{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
    job{1}.spm.stats.factorial_design.des.t2.ancova = 0;
    
   
%     %% Load Covariates 
%     % 07/03/2024 Note: Scores are placebo - drug 
    job{1}.spm.stats.factorial_design.dir = {outputpath};

%     job{1}.spm.stats.factorial_design.cov(1).c = [72.666666
%                                                         83.666666
%                                                         34.666666
%                                                         13
%                                                         28.333333
%                                                         -0.666666
%                                                         31.666666
%                                                         0
%                                                         15.666666
%                                                         36.666666
%                                                         87.333333
%                                                         55.333333
%                                                         32.666666
%                                                         28.333333
%                                                         56
%                                                         28.666666
%                                                         95.666666
%                                                         34.666666
%                                                         25.666666
%                                                         11.333333
%                                                         7
%                                                         51
%                                                         4.666667
%                                                         0
%                                                         14
%                                                         4
%                                                         4.333333
%                                                         0
%                                                         8
%                                                         34.333333
%                                                         21
%                                                         0.333334
%                                                         4.666666
%                                                         4.333334
%                                                         13.666667];
%     %
%     job{1}.spm.stats.factorial_design.cov(1).cname = 'DE';
%     job{1}.spm.stats.factorial_design.cov(1).iCFI = 2;
%     job{1}.spm.stats.factorial_design.cov(1).iCC = 1;
% %     %%
%     job{1}.spm.stats.factorial_design.cov(2).c = [65.666667
% 8
% 27.666666
% 3.333333
% 19
% 0
% 4.666666
% 0
% 2.333333
% 16
% 0
% 70.666667
% 0
% 44.666666
% 39.333333
% 7.666666
% 32
% 27.333333
% 0
% 12.666666
% 36
% 48.333333
% 1.333333
% 4.333333
% 36
% 5.666667
% 53.666666
% 0
% 51
% 51.333333
% 56.333333
% 5.666667
% 0
% 13.333333
% 67.666667];
%     %%
%     job{1}.spm.stats.factorial_design.cov(2).cname = 'EI';
%     job{1}.spm.stats.factorial_design.cov(2).iCFI = 2;
%     job{1}.spm.stats.factorial_design.cov(2).iCC = 1;
% %     %%
%     job{1}.spm.stats.factorial_design.cov(3).c = [49.571429
% 37.857142
% 30.714285
% 1
% 44.285714
% 8.571429
% 23.714285
% 16
% 3.571428
% 27
% 13.142857
% 59.142857
% 30.285714
% 34.428571
% 30
% 29.428571
% 44.571429
% 39.571429
% 43.142857
% 42
% 14
% 5.857142
% 5.714286
% 0.714285
% 4.857143
% 10.571429
% 14
% 18.714285
% 3
% 34.428571
% 6
% 0
% 16.571428
% 23.285714
% 49.142857];
%     %
%     job{1}.spm.stats.factorial_design.cov(3).cname = 'ICC';
%     job{1}.spm.stats.factorial_design.cov(3).iCFI = 2;
%     job{1}.spm.stats.factorial_design.cov(3).iCC = 1;
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
%     job{3}.spm.stats.con.consess{1}.fcon.name = [regressor ': DE'];
%     job{3}.spm.stats.con.consess{1}.fcon.weights = [0 0 1 1];
%     job{3}.spm.stats.con.consess{1}.fcon.sessrep = 'none';
%     job{3}.spm.stats.con.consess{2}.fcon.name = [regressor ': EI'];
%     job{3}.spm.stats.con.consess{2}.fcon.weights = [0 0 0 0 1 1];
%     job{3}.spm.stats.con.consess{2}.fcon.sessrep = 'none';
%     job{3}.spm.stats.con.consess{3}.fcon.name = [regressor ': ICC'];
%     job{3}.spm.stats.con.consess{3}.fcon.weights = [0 0 0 0 0 0 1 1];
%     job{3}.spm.stats.con.consess{3}.fcon.sessrep = 'none';
    job{3}.spm.stats.con.consess{1}.fcon.name = [regressor ': ket vs psi'];
    job{3}.spm.stats.con.consess{1}.fcon.weights = [1 -1];
    job{3}.spm.stats.con.consess{1}.fcon.sessrep = 'none';
    job{3}.spm.stats.con.consess{2}.fcon.name = [regressor ': psi vs ket'];
    job{3}.spm.stats.con.consess{2}.fcon.weights = [-1 1];
    job{3}.spm.stats.con.consess{2}.fcon.sessrep = 'none';

    job{3}.spm.stats.con.consess{3}.tcon.name = [regressor ': ket>psi'];
    job{3}.spm.stats.con.consess{3}.tcon.weights = [1 -1];
    job{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
    job{3}.spm.stats.con.consess{4}.tcon.name = [regressor ': ket<psi'];
    job{3}.spm.stats.con.consess{4}.tcon.weights = [-1 1];
    job{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';

    %% 2 sample t-tests
%     job{3}.spm.stats.con.consess{8}.tcon.name = [regressor 'DE: ket>psi'];
%     job{3}.spm.stats.con.consess{8}.tcon.weights = [0 0 1 -1];
%     job{3}.spm.stats.con.consess{8}.tcon.sessrep = 'none';    
%     job{3}.spm.stats.con.consess{9}.tcon.name = [regressor 'DE: ket<psi'];
%     job{3}.spm.stats.con.consess{9}.tcon.weights = [0 0 -1 1];
%     job{3}.spm.stats.con.consess{9}.tcon.sessrep = 'none';
%     job{3}.spm.stats.con.consess{10}.tcon.name = [regressor 'EI: ket>psi'];
%     job{3}.spm.stats.con.consess{10}.tcon.weights = [0 0 0 0 1 -1];
%     job{3}.spm.stats.con.consess{10}.tcon.sessrep = 'none';
%     job{3}.spm.stats.con.consess{11}.tcon.name = [regressor 'EI: ket<psi'];
%     job{3}.spm.stats.con.consess{11}.tcon.weights = [0 0 0 0 -1 1];
%     job{3}.spm.stats.con.consess{11}.tcon.sessrep = 'none';
%     job{3}.spm.stats.con.consess{12}.tcon.name = [regressor 'ICC: ket>psi'];
%     job{3}.spm.stats.con.consess{12}.tcon.weights = [0 0 0 0 0 0 1 -1];
%     job{3}.spm.stats.con.consess{12}.tcon.sessrep = 'none';
%     job{3}.spm.stats.con.consess{13}.tcon.name = [regressor 'ICC: ket<psi'];
%     job{3}.spm.stats.con.consess{13}.tcon.weights = [0 0 0 0 0 0 -1 1];
%     job{3}.spm.stats.con.consess{13}.tcon.sessrep = 'none';
% 
%     % T-tests: Positive and negative one-sample of each covariates 
% 
%     job{3}.spm.stats.con.consess{14}.tcon.name = [regressor ': Positive DE in ket'];
%     job{3}.spm.stats.con.consess{14}.tcon.weights = [0 0 1];
%     job{3}.spm.stats.con.consess{14}.tcon.sessrep = 'none';    
%     job{3}.spm.stats.con.consess{15}.tcon.name = [regressor 'Positive: DE in psi'];
%     job{3}.spm.stats.con.consess{15}.tcon.weights = [0 0 0 1];
%     job{3}.spm.stats.con.consess{15}.tcon.sessrep = 'none'; 
%     job{3}.spm.stats.con.consess{16}.tcon.name = [regressor 'Negative: DE in ket'];
%     job{3}.spm.stats.con.consess{16}.tcon.weights = [0 0 -1 0];
%     job{3}.spm.stats.con.consess{16}.tcon.sessrep = 'none'; 
%     job{3}.spm.stats.con.consess{17}.tcon.name = [regressor 'Negative: DE in psi'];
%     job{3}.spm.stats.con.consess{17}.tcon.weights = [0 0 0 -1];
%     job{3}.spm.stats.con.consess{17}.tcon.sessrep = 'none'; 
%     job{3}.spm.stats.con.consess{18}.tcon.name = [regressor 'Positive: EI in ket'];
%     job{3}.spm.stats.con.consess{18}.tcon.weights = [0 0 0 0 1];
%     job{3}.spm.stats.con.consess{18}.tcon.sessrep = 'none'; 
%     job{3}.spm.stats.con.consess{19}.tcon.name = [regressor 'Positive: EI in psi'];
%     job{3}.spm.stats.con.consess{19}.tcon.weights = [0 0 0 0 0 1];
%     job{3}.spm.stats.con.consess{19}.tcon.sessrep = 'none'; 
%     job{3}.spm.stats.con.consess{20}.tcon.name = [regressor 'Negative: EI in ket'];
%     job{3}.spm.stats.con.consess{20}.tcon.weights = [0 0 0 0 -1];
%     job{3}.spm.stats.con.consess{20}.tcon.sessrep = 'none'; 
%     job{3}.spm.stats.con.consess{21}.tcon.name = [regressor 'Negative: EI in psi'];
%     job{3}.spm.stats.con.consess{21}.tcon.weights = [0 0 0 0 0 -1];
%     job{3}.spm.stats.con.consess{21}.tcon.sessrep = 'none'; 
%     job{3}.spm.stats.con.consess{22}.tcon.name = [regressor 'Positive: ICC in ket'];
%     job{3}.spm.stats.con.consess{22}.tcon.weights = [0 0 0 0 0 0 1];
%     job{3}.spm.stats.con.consess{22}.tcon.sessrep = 'none'; 
%     job{3}.spm.stats.con.consess{23}.tcon.name = [regressor 'Positive: ICC in psi'];
%     job{3}.spm.stats.con.consess{23}.tcon.weights = [0 0 0 0 0 0 0 1];
%     job{3}.spm.stats.con.consess{23}.tcon.sessrep = 'none'; 
%     job{3}.spm.stats.con.consess{24}.tcon.name = [regressor 'Negative: ICC in ket'];
%     job{3}.spm.stats.con.consess{24}.tcon.weights = [0 0 0 0 0 0 -1];
%     job{3}.spm.stats.con.consess{24}.tcon.sessrep = 'none'; 
%     job{3}.spm.stats.con.consess{25}.tcon.name = [regressor 'Negative: ICC in psi'];
%     job{3}.spm.stats.con.consess{25}.tcon.weights = [0 0 0 0 0 0 0 -1];
%     job{3}.spm.stats.con.consess{25}.tcon.sessrep = 'none'; 

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
    spm_jobman('run', actual_job);


end