function loop_mnket_2ndlevel_modelbased( options )
%LOOP_MNKET_QUALITY_CHECK Loops through conditions and preprocessing options and performs all
%quality checks after subject analysis
%   IN:     options     - the struct that holds all analysis options
%   OUT:    -

if nargin < 1
    options = mnket_set_analysis_options;
end

% compute 2nd level stats for all EB treatment options chosen
for ebOption = {'reject', 'ssp'}
    options.preproc.eyeblinktreatment = char(ebOption);
    
    mnket_2ndlevel_modelbased(options);
end

end

