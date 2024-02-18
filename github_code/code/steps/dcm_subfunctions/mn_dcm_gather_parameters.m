function []=mn_dcm_gather_parameters(options,paths)
% DCM_GATHER Runs mnket_dcm for each subject and gathers 
% parameters into one structure
% IN: options               -the struct that holds all analysis options
% OUT:                      -
% BY: GABRIELLE A

%set up a structure to hold results
results=struct('pihat',{zeros(19,13),zeros(19,13)},'muhat2',...
{zeros(19,13),zeros(19,13)},'muhat3',{zeros(19,13),zeros(19,13)});

% paths and files
[~, paths] = mnket_subjects(options);
    
%set output file
if ~exist(paths.dcmroot,'dir')
    mkdir(paths.dcmroot)
end

%Record what we're doing
diary(paths.logfile);
mnket_display_analysis_step_header('Reporting DCM Stats', ...
    'all', options.stats);

%Gather parameters   

options.erp.type='lowhighPihat';
[pla_mat,ket_mat]=mn_dcm_loop(options);       
results(1).pihat= pla_mat;
results(2).pihat=ket_mat;

% options.erp.type='lowhighMuhat2';
% [pla_mat,ket_mat]=mnket_dcm_loop(options); 
% results(1).muhat2= pla_mat;
% results(2).muhat2=ket_mat;
% 
% options.erp.type='lowhighMuhat3';
% [pla_mat,ket_mat]=mnket_dcm_loop(options);       
% results(1).muhat3=pla_mat;
% results(2).muhat3=ket_mat;


save(paths.dcmroot, 'results');

end





