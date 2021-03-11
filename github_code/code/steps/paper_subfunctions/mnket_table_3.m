function [ data ] = mnket_table_3( options, savePath )
%MNKET_TABLE_3 Collects all data points needed to create table 3 of paper: modelbased
%2ndlevel results for drug difference on epsilon3
%   IN:     options     - the struct that holds all analysis options
%           savePath    - where to save the images and data

[~, paths] = mnket_subjects(options);

tabPath = fullfile(savePath, 'table_3');
mkdir(tabPath);

% collect data for tab. 3: epsilon3 under ketamine (no sig. voxel for epsi2)
resultsDir = fullfile(paths.statdifffold, 'epsi3');
csvTable = fullfile(resultsDir, 'table_T_peakFWE.csv');
copyfile(csvTable, tabPath);
T = readtable(csvTable);
data.epsi3 = T;

% save all paper-relevant data for this table
save(fullfile(tabPath, 'tabdata.mat'), 'data');

end

