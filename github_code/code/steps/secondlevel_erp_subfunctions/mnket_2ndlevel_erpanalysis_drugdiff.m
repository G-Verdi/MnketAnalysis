function mnket_2ndlevel_erpanalysis_drugdiff(options)
%MNKET_2NDLEVEL_ERPANALYSIS_DRUGDIFF Computes the second level contrast
%images for ERP effects in one condition in the MNKET study.
%   IN:     options - the struct that holds all analysis options
%   OUT:    --

% general analysis options
if nargin < 1
    options = mnpsi_set_analysis_options;
end

% paths and files
[~, paths] = mnpsi_subjects(options);

% record what we're doing
diary(paths.logfile);
mnket_display_analysis_step_header('secondlevel erpanalysis drugdiff', ...
    'all', options.erp);

try
    % check for previous drugdifference erpanalysis
    load(paths.diffgafiles{end});
    disp(['Drug differences in ' options.erp.type ' ERPs have been ' ...
        'computed before.']);
    if options.erp.overwrite
        clear diff;
        disp('Overwriting...');
        error('Continue to drug difference step');
    else
        disp('Nothing is being done.');
    end
catch
    disp(['Computing drug differences in ' options.erp.type  ' ERPs...']);
    
    % make sure we have a results directory
    GAroot = paths.erpdiffold;
    if ~exist(GAroot, 'dir')
        mkdir(GAroot);
    end
    
    % data from both conditions serve as input for drug differences in
    % difference waves
    cd(options.workdir);
    for iCh = 1: numel(options.erp.channels)
        options.condition = 'placebo';
        [~, paths] = mnpsi_subjects(options);
        pla = load(paths.erpgafiles{iCh});
        options.condition = 'psilocybin';
        [~, paths] = mnpsi_subjects(options);
        psi = load(paths.erpgafiles{iCh});

        % compute the difference waves condition-wise
%         diff.time = pla.ga.time;
%         diff.electrode = pla.ga.electrode;
        switch options.erp.type
            case {'roving', 'mmnad'}
                diff.nsubjects = size(pla.ga.standard.data, 1);
                diffwavesPla = pla.ga.deviant.data - pla.ga.standard.data;
                diffwavespsi = psi.ga.deviant.data - psi.ga.standard.data;
                % Added by Colleen
                diff.placebo.time = pla.ga.deviant.time;
                diff.placebo.electrode = pla.ga.deviant.electrode;
                diff.psilocybin.time = pla.ga.deviant.time;
                diff.psilocybin.electrode = pla.ga.deviant.electrode;
            case {'lowhighEpsi2', 'lowhighEpsi3'}
                diff.nsubjects = size(pla.ga.low.data, 1);
                diffwavesPla = pla.ga.high.data - pla.ga.low.data;
                diffwavespsi = psi.ga.high.data - psi.ga.low.data;
                % Added by Colleen
                diff.placebo.time = pla.ga.high.time;
                diff.placebo.electrode = pla.ga.high.electrode;
                diff.psilocybin.time = pla.ga.high.time;
                diff.psilocybin.electrode = pla.ga.high.electrode;
            case {'lowhighMuhat2', 'lowhighMuhat3','lowhighPihat'}
                diff.nsubjects = size(pla.ga.low.data, 1);
                diffwavesPla = pla.ga.high.data - pla.ga.low.data;
                diffwavespsi = psi.ga.high.data - psi.ga.low.data;
                % Added by Colleen
                diff.placebo.time = pla.ga.high.time;
                diff.placebo.electrode = pla.ga.high.electrode;
                diff.psilocybin.time = pla.ga.high.time;
                diff.psilocybin.electrode = pla.ga.high.electrode;
            case 'tone'
                diff.nsubjects = size(pla.ga.tone.data, 1);
                diffwavesPla = pla.ga.tone.data;
                diffwavespsi = psi.ga.tone.data;
                % Added by Colleen
                diff.placebo.time = pla.ga.tone.time;
                diff.placebo.electrode = pla.ga.tone.electrode;
                diff.psilocybin.time = pla.ga.tone.time;
                diff.psilocybin.electrode = pla.ga.tone.electrode;
        end        
        
        diff.placebo.mean = mean(diffwavesPla);
        diff.placebo.sd  = std(diffwavesPla);
        diff.placebo.error  = std(diffwavesPla)/sqrt(diff.nsubjects);
        diff.placebo.data = diffwavesPla;

        diff.psilocybin.mean = mean(diffwavespsi);
        diff.psilocybin.sd  = std(diffwavespsi);
        diff.psilocybin.error  = std(diffwavespsi)/sqrt(diff.nsubjects);
        diff.psilocybin.data = diffwavespsi;

        save(paths.diffgafiles{iCh}, 'diff');
        
        mnket_grandmean_plot(diff, diff.placebo.electrode, options, 'drugdiff');
    end

    disp(['Computed drug differences in ' options.erp.type ' ERPs.']);
end
close all;
cd(options.workdir);

diary OFF
end



