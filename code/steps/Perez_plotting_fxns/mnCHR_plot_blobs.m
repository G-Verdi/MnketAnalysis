function mnCHR_plot_blobs(contrast_idx, regressor, options)
%--------------------------------------------------------------------------
% Plotting function from Perez Study
% 
%
%--------------------------------------------------------------------------


%% Defaults
if nargin < 1
    options = mn_set_analysis_options();
end

% paths and files
[~, paths] = mn_subjects(options);

%% Set options
% spm_root = fullfile(paths.erpstatroot, regressor,'drugdiff', 'mmn');
% spm_root = fullfile(paths.statroot, 'drugdiff', regressor);
 spm_root = fullfile(paths.groupfold,'ANCOVA','no_placebo',regressor);

%% Load SPM file

% Create dummy xSPM structure
temp = struct;
temp.swd = spm_root;   % SPM working directory - directory containing current SPM.mat
temp.Ic = contrast_idx;                         % index of contrast in SPM file
temp.Im = [];                                   % indices of masking contrasts (in xCon)
temp.Ex = [];                                   % flag for exclusive or inclusive masking
temp.pm = [];                                   % p-value for masking (uncorrected)
temp.k = 1;                                     % Minimum #Voxels (extend threshold)

% Get cluster-level results
temp.u = 0.001;           % Significance threshold: 0.001 (cluster) or 0.05 (peak)
temp.thresDesc = 'none';  % Threshold description: 'none' (cluster) or 'FWE' (peak)

[~, xSPM] = spm_getSPM(temp);   % Load SPM results structure

max_stat = max(xSPM.Z);     % Get maximum stats value
stat_thresh = xSPM.u;       % Get critical stats threshold
stat = xSPM.STAT;           % Get statistic (F or T);
clear xSPM

% Get peak-level results
temp.u = 0.05;            % Significance threshold: 0.001 (cluster) or 0.05 (peak)
temp.thresDesc = 'FWE';   % Threshold description: 'none' (cluster) or 'FWE' (peak)

[~, xSPM] = spm_getSPM(temp);   % Load SPM results structure

stat_thresh_contour = xSPM.u;   % Get critical stats threshold for contour
clear xSPM temp


%% Smooth SPM file for plotting
fname = sprintf('spm%s_%.4d.nii', stat, contrast_idx);
spm_nii_unsmoothed = fullfile(spm_root, fname);

% Perform smoothing
job{1}.spm.spatial.smooth.data = {spm_nii_unsmoothed};
job{1}.spm.spatial.smooth.fwhm = [4.25 5.38 2];
job{1}.spm.spatial.smooth.dtype = 0;
job{1}.spm.spatial.smooth.im = 1;   % Use implicit masking (removes NaNs)
job{1}.spm.spatial.smooth.prefix = 's';
spm_jobman('run', job);

smoothed_file = spm_file(spm_nii_unsmoothed, 'prefix', 's');

% Perform maximum intensity projection
spm_nii_unsmoothed = compute_mips(spm_nii_unsmoothed);
spm_nii_smoothed = compute_mips(smoothed_file); 
% spm_nii_unsmoothed = {spm_nii_unsmoothed};
% spm_nii_smoothed = {smoothed_file};



%%  Create color map
color_mode = 'map_thresh';                                  % 'single_color', 'map_thresh' or 'no_thresh'
n_cols = 64;                                                % Should be kept at 64, because SPM uses 64 colors
n_black = ceil((stat_thresh/max_stat)*n_cols);              % Use cluster threshold or
%n_black = ceil((stat_thresh_contour/max_stat)*n_cols);    % Use peak threshold
n_colored = n_cols - n_black;

switch color_mode
    case 'single_col'
        color_array = eye(3);
        start_color = color_array(r,:);
        temp = zeros(n_colored,3);
        for iColorChannel = 1:3
            temp(:,iColorChannel) = linspace(start_color(iColorChannel), 1, n_colored)';
        end
        %cmap = [zeros(n_black,3); temp];
        cmap = [colormap(gray(n_black)); temp];
        
    case 'map_thresh'
        cmap = colormap(jet(n_cols));
        %cmap(1:n_black,:) = colormap(gray(n_black));
        cmap(1:n_black,:) = repmat(linspace(0, 0.7, n_black)',1, 3);
        %cmap(1:n_black,:) = zeros(n_black,3);
        
    case 'no_thresh'
        cmap = colormap(jet(n_cols));
        %cmap(1,:) = zeros(1,3);
end

%% Plot
suffix_maps = {'mipX' 'mipY', 'mipZ'};
pixel_dim_figs = [600 1250; 500 1250; 500 600];

% make output folder
save_root = fullfile(spm_root, sprintf('con%s_contours', stat));

if ~exist(save_root, 'dir')
    mkdir(save_root);
end
cd(save_root);

for idx_map = 1:numel(spm_nii_smoothed)
    spm_nii_fname = spm_nii_smoothed{idx_map};
    spm_nii_fname_contour = spm_nii_unsmoothed{idx_map};

            
         plot_map_spm_checkreg_global_max(...
            spm_nii_fname_contour,...               % Nifti file containing SPM for contrast image to plot
            spm_nii_fname_contour,...               % Nifti file containing SPM for contour plot (unsmoothed file is recommended)
            max_stat,...                            % Maximal F- or T-value in SPM
            cmap,...                                % Color map
            stat_thresh_contour...                  % Critical F- or T-value for contour plot
            );
        fh = gcf;
    
    
    % Save
    save_fname = sprintf('checkreg_%s', suffix_maps{idx_map});
    saveas(fh, fullfile(save_root, save_fname), 'fig');

    % Export relevant subplots into their own figures
    all_axes = findall(fh,'type','axes');
    f = getSubplot(all_axes(idx_map));
    pos = f.OuterPosition;
    f.OuterPosition = [pos(1) pos(2) pixel_dim_figs(idx_map,1) pixel_dim_figs(idx_map,2)];
    save_fname = sprintf('checkreg_%s_%s_single_plot.png', color_mode, suffix_maps{idx_map});
    exportgraphics(f,fullfile(save_root, save_fname),'Resolution',600)
    clear f
end


% Create colorbar figure
cb_fig = figure('color',[1 1 1], 'colormap', cmap);
c = colorbar;
axis off
caxis([0 max_stat])
if ~strcmp(color_mode, 'no_thresh')
    c.Limits = [stat_thresh+0.1 max_stat];
end
c.FontSize = 48;
c.Location = 'South'; %South - horizontal; East - vertical 
save_fname = 'checkreg_colorbar.png';
exportgraphics(cb_fig,fullfile(save_root, save_fname),'Resolution',600)
% clear cb_fig; 

end
