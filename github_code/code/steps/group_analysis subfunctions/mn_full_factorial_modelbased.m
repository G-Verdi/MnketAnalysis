function mn_full_factorial_modelbased(icell, scndlvlroot,covariates,design, options, doDeleteExisting)
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
            if  regressor == 'epsilon2'
                fname = fullfile('beta_0002.nii'); % Chose regressor +1 (since first regressor is the mean)
                for i = 1:numel(icell)
                    files(i).scans = fullfile(icell(i).scans, fname);
                end
            elseif  regressor == 'epsilon3'
                 fname = fullfile('beta_0003.nii'); % Chose regressor +1 (since first regressor is the mean)
                 for i = 1:numel(icell)
                     files(i).scans = fullfile(icell(i).scans, fname);
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
    
    %% Full Factorial Design
    job{1}.spm.stats.factorial_design.dir = {outputpath};
    
    % Prepare filenames for first level images
    job{1}.spm.stats.factorial_design.des.fd.icell = files;
    
    % Specify factors
    job{1}.spm.stats.factorial_design.des.fd.fact(1).name = 'group';
    job{1}.spm.stats.factorial_design.des.fd.fact(1).levels = 2;
    job{1}.spm.stats.factorial_design.des.fd.fact(1).dept = 0;
    job{1}.spm.stats.factorial_design.des.fd.fact(1).variance = 1;
    job{1}.spm.stats.factorial_design.des.fd.fact(1).gmsca = 0;
    job{1}.spm.stats.factorial_design.des.fd.fact(1).ancova = 0;
    job{1}.spm.stats.factorial_design.des.fd.fact(2).name = 'condition';
    job{1}.spm.stats.factorial_design.des.fd.fact(2).levels = 2;
    job{1}.spm.stats.factorial_design.des.fd.fact(2).dept = 1;
    job{1}.spm.stats.factorial_design.des.fd.fact(2).variance = 1;
    job{1}.spm.stats.factorial_design.des.fd.fact(2).gmsca = 0;
    job{1}.spm.stats.factorial_design.des.fd.fact(2).ancova = 0;    
    job{1}.spm.stats.factorial_design.des.fd.contrasts = 1; % 1 = compute all contrasts
    job{1}.spm.stats.factorial_design.des.fd.icell(1).levels = [1,1];
    job{1}.spm.stats.factorial_design.des.fd.icell(2).levels = [2,1];
    job{1}.spm.stats.factorial_design.des.fd.icell(3).levels = [1,2];
    job{1}.spm.stats.factorial_design.des.fd.icell(4).levels = [2,2];
    
    % Load covariate

     job{1}.spm.stats.factorial_design.cov(1).c = covariates.OB; 
     job{1}.spm.stats.factorial_design.cov(1).cname = 'OB';
     job{1}.spm.stats.factorial_design.cov(1).iCFI = 1;
     job{1}.spm.stats.factorial_design.cov(1).iCC = 1;
     job{1}.spm.stats.factorial_design.cov(2).c = covariates.VR;
     job{1}.spm.stats.factorial_design.cov(2).cname = 'VR';
     job{1}.spm.stats.factorial_design.cov(2).iCFI = 1;
     job{1}.spm.stats.factorial_design.cov(2).iCC = 1;
     job{1}.spm.stats.factorial_design.cov(3).c = covariates.DED;
     job{1}.spm.stats.factorial_design.cov(3).cname = 'DED';
     job{1}.spm.stats.factorial_design.cov(3).iCFI = 1;
     job{1}.spm.stats.factorial_design.cov(3).iCC = 1;
%       job{1}.spm.stats.factorial_design.cov(1).c = covariates.EI; 
%       job{1}.spm.stats.factorial_design.cov(1).cname = 'EI';
%       job{1}.spm.stats.factorial_design.cov(1).iCFI = 1;
%       job{1}.spm.stats.factorial_design.cov(1).iCC = 1;

    job{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
        
    job{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
    job{1}.spm.stats.factorial_design.masking.im = 1;
    job{1}.spm.stats.factorial_design.masking.em = {''};  % explicit mask
    
    job{1}.spm.stats.factorial_design.globalc.g_omit = 1;
    job{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
    job{1}.spm.stats.factorial_design.globalm.glonorm = 1;
     
    % Estimate model
    job{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    job{2}.spm.stats.fmri_est.write_residuals = 0;
    job{2}.spm.stats.fmri_est.method.Classical = 1;
    % Specify contrasts
     job{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}), substruct('.','spmmat'));

    %----------------------------------------------------------------------
    % Covariates
    %----------------------------------------------------------------------

    job{3}.spm.stats.con.consess{1}.fcon.name = ['OB'];
    job{3}.spm.stats.con.consess{1}.fcon.convec = [1 -1 -1 1 1]; 
    job{3}.spm.stats.con.consess{1}.fcon.sessrep = 'none';
    job{3}.spm.stats.con.consess{2}.fcon.name = ['VR'];
    job{3}.spm.stats.con.consess{2}.fcon.convec = [1 -1 -1 1 0 1];
    job{3}.spm.stats.con.consess{2}.fcon.sessrep = 'none';
    job{3}.spm.stats.con.consess{3}.fcon.name = ['DED'];
    job{3}.spm.stats.con.consess{3}.fcon.convec = [1 -1 -1 1 0 0 1];
    job{3}.spm.stats.con.consess{3}.fcon.sessrep = 'none';
%     job{3}.spm.stats.con.consess{1}.fcon.name = ['EI'];
%     job{3}.spm.stats.con.consess{1}.fcon.convec = [1 -1 -1 1 1]; 
%     job{3}.spm.stats.con.consess{1}.fcon.sessrep = 'none';

    job{3}.spm.stats.con.delete = 1;
    %----------------------------------------------------------------------
    % Follow-up all designs
    %----------------------------------------------------------------------
    % T-test: Increase ket -> psi
    job{3}.spm.stats.con.consess{4}.tcon.name = [regressor ': ket > psi'];
    job{3}.spm.stats.con.consess{4}.tcon.convec = [1  1 -1 -1];
    job{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
    % T-test: Decrease ket -> psi
    job{3}.spm.stats.con.consess{5}.tcon.name = [regressor ': ket < psi'];
    job{3}.spm.stats.con.consess{5}.tcon.convec = [-1 -1 1 1];
    job{3}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
    % T-tests: Pairwise comparisons
    job{3}.spm.stats.con.consess{6}.tcon.name = [regressor ': drug > placebo'];
    job{3}.spm.stats.con.consess{6}.tcon.convec = [-1 1 -1 1];
    job{3}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
    job{3}.spm.stats.con.consess{7}.tcon.name = [regressor ': placebo > drug'];
    job{3}.spm.stats.con.consess{7}.tcon.convec = [1 -1 1 -1];
    job{3}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
    job{3}.spm.stats.con.consess{8}.tcon.name = [regressor ': placebo > ket'];
    job{3}.spm.stats.con.consess{8}.tcon.convec = [1 -1 0 0 1 1 1];
    job{3}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
    job{3}.spm.stats.con.consess{9}.tcon.name = [regressor ': placebo > psi'];
    job{3}.spm.stats.con.consess{9}.tcon.convec = [0 0  1 -1];
    job{3}.spm.stats.con.consess{9}.tcon.sessrep = 'none';
    job{3}.spm.stats.con.consess{10}.tcon.name = [regressor ': [placebo - ket] > [placebo - psi]'];
    job{3}.spm.stats.con.consess{10}.tcon.convec = [1 -1 -1 1];
    job{3}.spm.stats.con.consess{10}.tcon.sessrep = 'none';
    job{3}.spm.stats.con.consess{11}.tcon.name = [regressor ': [ket - placebo] < [psi - placebo]'];
    job{3}.spm.stats.con.consess{11}.tcon.convec = [-1 1 1 -1];
    job{3}.spm.stats.con.consess{11}.tcon.sessrep = 'none';
    job{3}.spm.stats.con.consess{12}.tcon.name = [regressor ': psilocybin > placebo'];
    job{3}.spm.stats.con.consess{12}.tcon.convec = [0 0 -1 1];
    job{3}.spm.stats.con.consess{12}.tcon.sessrep = 'none';
    job{3}.spm.stats.con.consess{13}.tcon.name = [regressor ': psilocybin < placebo'];
    job{3}.spm.stats.con.consess{13}.tcon.convec = [-1 1 0 0];
    job{3}.spm.stats.con.consess{13}.tcon.sessrep = 'none';
  
    %job{4}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}), substruct('.','spmmat'));
    job{4}.spm.stats.results.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{3}, '.','val', '{}',{1}), substruct('.','spmmat'));
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
    
    % Which modules really to include?
     actual_job = {job{1},job{2},job{3},job{4}};
    
    % Execute actual_job
    spm_jobman('run', actual_job);

 %----------------------------------------------------------------------%
 %      Merge pdfs into one
 %----------------------------------------------------------------------%
   % Select pdfs from folder and select output directory 

      %pdfmerge 

    
end

