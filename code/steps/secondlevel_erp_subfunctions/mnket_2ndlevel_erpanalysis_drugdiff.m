function mnket_2ndlevel_erpanalysis_drugdiff(options)
%MNKET_2NDLEVEL_ERPANALYSIS_DRUGDIFF Computes the second level contrast
%images for ERP effects in one condition in the MNKET study.
%   IN:     options - the struct that holds all analysis options
%   OUT:    --

% general analysis options
if nargin < 1
    options = mn_set_analysis_options;
end

% paths and files
[~, paths] = mn_subjects(options);

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
    for iCh = 1:numel(options.erp.channels)
        diff = struct();
    
        for ic = 1:numel(options.conditions)
            cond = options.conditions{ic};
            options.condition = cond;
            [~, paths] = mn_subjects(options);
            dataFile = paths.erpgafiles{iCh};
            S = load(dataFile);
            ga = S.ga;
    
            switch options.erp.type
                case {'roving','mmnad'}
                    A = ga.deviant;   B = ga.standard;
                case {'lowhighEpsi2','lowhighEpsi3','lowhighPihat1','lowhighPihat2','lowhighPihat3'}
                    A = ga.high;      B = ga.low;
                case 'tone'
                    A = ga.tone;      B.data = 0;
                otherwise
                    error('Unknown ERP type %s', options.erp.type);
            end
    
            diffWave = A.data - B.data;
            nSub = size(A.data,1);
    
            diff.(cond).time = A.time;
            diff.(cond).electrode = A.electrode;
            diff.(cond).data = diffWave;
            diff.(cond).mean = mean(diffWave);
            diff.(cond).sd = std(diffWave);
            diff.(cond).error = std(diffWave) / sqrt(nSub);
            diff.(cond).nsubjects = nSub;
        end
    
        save(paths.diffgafiles{iCh}, 'diff');
        mnket_grandmean_plot(diff, diff.(options.conditions{1}).electrode, options, 'drugdiff');
    end


    disp(['Computed drug differences in ' options.erp.type ' ERPs.']);
end
close all;
cd(options.workdir);

diary OFF
end



