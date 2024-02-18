function montage = mnket_montage_swap_channels
%MNKET_MONTAGE Creates the montage struct for swapping F1 and C2 channels in the MNKET study.
%   IN:     -
%   OUT:    montage     - the montage struct with labels and montage matrix

montage = struct;

% channel labels
montage.labelorg = {...
    'Fp1', 'AF7', 'AF3', 'F1', 'F3', 'F5', 'F7', 'FT7', ...
    'FC5', 'FC3', 'FC1', 'C1', 'C3', 'C5', 'T7', 'TP7', ...
    'CP5', 'CP3', 'CP1', 'P1', 'P3', 'P5', 'P7', 'P9', ...
    'PO7', 'PO3', 'O1', 'Iz', 'Oz', 'POz', 'Pz', 'CPz', ...
    'Fpz', 'Fp2', 'AF8', 'AF4', 'AFz', 'Fz', 'F2', 'F4', ...
    'F6', 'F8', 'FT8', 'FC6', 'FC4', 'FC2', 'FCz', 'Cz', ...
    'C2', 'C4', 'C6', 'T8', 'TP8', 'CP6', 'CP4', 'CP2', ...
    'P2', 'P4', 'P6', 'P8', 'P10', 'PO8', 'PO4', 'O2', ...
    'EXG1', 'EXG2', 'EXG5', 'EXG6'};

montage.labelnew = montage.labelorg;

% swap channels F1 (4) and C2 (49)
tra = eye(68);
tra(4, 4)   = 0;
tra(4, 49)  = 1;
tra(49, 49) = 0;
tra(49, 4)  = 1;

montage.tra = tra;

end
