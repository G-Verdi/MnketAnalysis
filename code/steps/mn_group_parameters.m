function groupHGFParamTable = mnCHR_group_parameters( options )
%--------------------------------------------------------------------------
% MNCHR_GROUP_PARAMETERS Creates a table summarizing the average initial
% HGF perceptual parameters
% 
%   IN:     options             - the struct that contains all analysis options
%   OUT:    groupHGFParamTable  - output table of HGF parameters
%--------------------------------------------------------------------------

if nargin < 1
    options = mn_set_analysis_options;
end

% paths and files
for idCell = options.subjects.all  % Modified the loop to go through each subject ID
    id = char(idCell);             % G.A

    [details, paths] = mn_subjects(id, options);

    mkdir(fullfile(paths.qualityroot, 'reject'));
    
    % loop through conditions
    for i_group = 1:length(options.subjects.group_labels)
        options.condition = char(options.subjects.group_labels{i_group});
    
         % loop through subjects and get their stats
         for iSub = 1: length(options.subjects.group{i_group})
            subID = char(options.subjects.group{i_group}{iSub});
            details = feval(options.funs.details, subID, options);
            load(fullfile(details.simfilepost))
    
            mu_2(iSub) = sim.p_prc.mu2_0(1);
            mu_3(iSub) = sim.p_prc.mu3_0(1);
    
            sa0_2(iSub) = sim.p_prc.sa2_0(1);
            sa0_3(iSub) = sim.p_prc.sa3_0(1); 
            om(iSub) = sim.p_prc.om;
            th(iSub) = sim.p_prc.th;
            ka (iSub) = sim.p_prc.ka;
            logitthmu(iSub) = sim.c_prc.logitthmu;
            logitthsa(iSub) = sim.c_prc.logitthsa;
            logitkamu(iSub) = sim.c_prc.logitkamu;
            logitkasa(iSub) = sim.c_prc.logitkasa;
            kaub(iSub) = sim.c_prc.kaub;  % fixed
            thub(iSub) = sim.c_prc.thub;  % fixed
           
         end
   
    
        % table
        groupHGFParamTable = table(mu_2', ...
                            mu_3', ...
                            sa0_2',...
                            sa0_3',  ...
                            om',...
                            th',...
                            ka',...
                            logitthmu',...
                            logitthsa',...
                            logitkamu',...
                            logitkasa',...
                            kaub',...
                            thub',...
                            'RowNames', options.subjects.group{i_group}', ...
                            'VariableNames', {'mu_2', ...
                            'mu_3', ...
                            'sa0_2', ...
                            'sa0_3', ...
                            'om', ...
                            'th', ...
                            'ka',...
                            'logitthmu', ...
                            'logitthsa', ...
                            'logitkamu' ...
                            'logitkasa', ...
                            'kaub', ...
                            'thub'});

    save(fullfile(paths.qualityroot, 'TableS1', [options.condition '_HGFParamTable']), 'groupHGFParamTable');

    clear mu_2
    clear mu_3
    clear sa0_2
    clear sa0_3
    clear om
    clear th
    clear ka
    clear logitthmu
    clear logitthsa
    clear logitkamu
    clear logitkasa
    clear kaub
    clear thub
    end 
end 
   
    