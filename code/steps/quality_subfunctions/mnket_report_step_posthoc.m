function mnket_report_step_posthoc( stepStr, options )
%MNKET_REPORT_STEP_POSTHOC Loops through all subjects and creates quality check plots and variables 
%that have not been saved automatically during modeling, preprocessing, or first-level statistics.
%   IN:     stepStr - step identifier string, e.g. 'coregistration'
%           options - the struct that holds all analysis options
%   OUT:    -

for iSub = 1: numel(options.subjects.all)
    id = char(options.subjects.all{iSub});

    details = mn_subjects(id, options);


    switch lower(stepStr)
        case {'ebcorr', 'ebcorrection', 'eyeblinkcorrection'}
            tnueeg_check_eb_correction_on_average(details.ebfile, details.prepfile, ...
                details.ebcorrectfig, options);
        case {'coreg', 'coregistration'}
            tnueeg_check_coregistration(details.prepfile, details.coregmeshfig, ...
                details.coregdatafig); 
        case {'reg', 'regressors'}
            tnueeg_check_regressors_before_after(details.design, details.eegdesign, ...
                details.regressorplots);
        case {'mask', 'firstlevelmask'}
            tnueeg_check_mask_image(details.statroot, details.firstlevelmaskfig); 
    end
end

end
