function loop_mnket_quality_check( options )
%LOOP_MNKET_QUALITY_CHECK Loops through conditions and performs all
%quality checks after subject analysis
%   IN:     options     - the struct that holds all analysis options
%   OUT:    -

if nargin < 1
    options = mnket_set_analysis_options;
end

% perform quality check for subject analysis in both conditions
for cond = options.conditions
    options.condition = char(cond);

    mnket_quality_check(options);
end
    
% compare trial statistics across drug conditions
mnket_compare_trial_stats(options);


end
