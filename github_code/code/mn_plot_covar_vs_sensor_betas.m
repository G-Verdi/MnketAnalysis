function mn_plot_covar_vs_sensor_betas(peakCoord, regressor, design, covariate, options)
% -------------------------------------------------------------------------
% COMPI_PLOT_COVAR_VS_SENSOR_BETAS Plot first-level source betas against a
% covariate of interest.
%
%   IN:     peakCoord       Peak coordinate in voxel space
%           design          Regressor design 
%           covariate       The covariate of interest (cell)
%           options         Options structure as set by set_analysis_options()
% -------------------------------------------------------------------------

     
    % switch options.eeg.stats.mode
    %     case 'modelbased'
    %         if  regressor == 'pihat1'
    %             fname = fullfile('beta_0004.nii'); % Chose regressor +1 (since first regressor is the mean)
    % 
    %         elseif  regressor == 'pihat2'
    %                  fname = fullfile('beta_0002.nii'); % Chose regressor +1 (since first regressor is the mean)
    % 
    %         elseif  regressor == 'pihat3'
    %                  fname = fullfile('beta_0003.nii'); % Chose regressor +1 (since first regressor is the mean)
    % 
    %         end
    % end

    switch options.eeg.stats.mode
        case 'modelbased'
            if  regressor == 'epsi2'
                fname = fullfile('beta_0002.nii'); % Chose regressor +1 (since first regressor is the mean)

            elseif  regressor == 'epsi3'
                     fname = fullfile('beta_0003.nii'); % Chose regressor +1 (since first regressor is the mean)

            end
    end


 

    % Create results directory
    idx_design = find(contains(options.eeg.stats.design, design));
    statspath = options.eeg.stats.secondlevel.secondlevelDir.classical{idx_design};
    scndlvlroot = fullfile(statspath, 'groupdiff', 'ANCOVA','beta_plots');
    if ~exist(scndlvlroot, 'dir')
        mkdir(scndlvlroot);
    end
    cd(scndlvlroot);
    
    %----------------------------------------------------------------------
    % Collect 1st level beta images
    %----------------------------------------------------------------------
    % beta images of 1st level regression for each regressor in each
    % subject and each condition serve as input 
    
    % Cycle through groups

    betaAll_mnket=[];
    betaAll_mnpsi=[];
    betaAll=[];

    idx = 1;
    IDs = cell(0);
    for g = 1:numel(options.subjects.group_labels)
        for c = 1:numel(options.subjects.condition_labels)
            temp = options.groupxcond.IDs{g,c};
            
            % Collect subject beta image paths
            for s = 1:numel(temp)
                if c == 1
                    
                    options.workdir = fullfile(options.preprocdir,'test_mnket');
                    

                    if g==1
                        options.condition ='placebo';
                        [details] = mn_subjects(temp{s}, options);

                        % Set path to beta file for subject 
                        imgFile = fullfile(details.statroot,fname);
                        [betaVal] = mn_extract_sensor_betas(imgFile,peakCoord);

                        % Append beta values to betaAll_mnket
                        betaAll_mnket = [betaAll_mnket;betaVal];
    
                    end

                    if g==2
                        options.condition ='ketamine';
                        [details] = mn_subjects(temp{s}, options);
                        
                        %Set path to beta file for subject 
                        imgFile = fullfile(details.statroot,fname);
                        [betaVal] = mn_extract_sensor_betas(imgFile,peakCoord);
    
                        % append beta values to betaAll_mnket
                        betaAll_mnket = [betaAll_mnket;betaVal];

                    end
                    
                elseif c==2
                    
                    options.workdir = fullfile(options.preprocdir,'test_mnpsi');
                    

                    if g==1
                        options.condition = 'placebo'; 
                        [details] = mn_subjects(temp{s}, options);
    
                        %set path to beta file for subject
                        imgFile = fullfile(details.statroot,fname);

                        [betaVal] = mn_extract_sensor_betas(imgFile,peakCoord);
    
                        % append beta values to betaAll_mnpsi
                        betaAll_mnpsi = [betaAll_mnpsi;betaVal];
                    end

                    
                    if g==2
                        options.condition ='psilocybin';
                        [details] = mn_subjects(temp{s}, options);

                        %set path to beta file for subject
                        imgFile = fullfile(details.statroot,fname);

                        [betaVal] = mn_extract_sensor_betas(imgFile,peakCoord);
    
                        % append beta values to betaAll_mnpsi
                        betaAll_mnpsi = [betaAll_mnpsi;betaVal];

                    end
                    
                end
                
            end
            icell(idx).levels = [g, c];
            IDs = [IDs temp];
            clear temp
            idx = idx+1;
        end
    end

    % Append betas into one vector
    betaAll=[betaAll_mnket;betaAll_mnpsi];

    %Specify contrast vector
    con_vec = [repelem(0,19) repelem(1,19) repelem(0,16) repelem(0,16)]';

    betaAll = betaAll.*con_vec;
   
    % % adjust for difference in condition
    pla_ket = betaAll(1:19,:);
    ket = betaAll(20:38,:);
    % pla_psi = betaAll(39:54,:);
    % psi    =  betaAll(55:70,:);

    betaAll_mnket = (pla_ket + ket);

    betaAll = betaAll_mnket;






%% Create scatter plot

% get covariates

covars = perez_get_covariate_labels(IDs, options);
ASC_Scores = table2array(covars(:,covariate));


% adjust for difference in condition
    pla_ket = ASC_Scores(1:19,:);
    ket = ASC_Scores(20:38,:);


    asc_mnket = (ket - pla_ket);


    ASC_Scores= asc_mnket;


% Create scatter plot with solid black dots
figure;
%set(gcf,'position',[500,500,400,300])
scatter(betaAll, ASC_Scores, 'filled', 'k', 'SizeData', 70);
ylim([-50,50])
set(gca, 'FontSize', 30)
xlim([-0.1,0.1])
% xlim([-2,4])
xlabel('Beta Value', 'FontSize', 14);
ylabel(covariate,'FontSize', 14);
title('Mean Beta Value vs.', covariate);

% Fit a linear regression model to the data
p = polyfit(betaAll, ASC_Scores, 1);

% Add the regression line to the plot
hline = refline(p);
hline.Color = 'k';
hline.LineWidth = 1.5;

 % Calculate the Pearson correlation
 [r, pValue] = corr(betaAll, ASC_Scores);

 
% % Display the correlation coefficient at the bottom right of the plot
% text(1.5, 6, sprintf('r = %.2f, p = %.3f', r, pValue), ...
%     'VerticalAlignment', 'bottom', ...
%     'HorizontalAlignment', 'right');


disp(r)
disp(pValue)

% save the figure as both .fig and .jpg
saveas(gca, fullfile(scndlvlroot, 'fig'));
saveas(gca, fullfile(scndlvlroot, 'jpg'));



