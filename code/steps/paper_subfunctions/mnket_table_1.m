function [ data ] = mnket_table_1( options, savePath )
%MNKET_TABLE_1 Collects all data points needed to create table 1 of paper: modelbased
%2ndlevel results for placebo condition
%   IN:     options     - the struct that holds all analysis options
%           savePath    - where to save the images and data

options.condition = 'placebo';
[~, paths] = mnket_subjects(options);

tabPath = fullfile(savePath, 'table_1');
mkdir(tabPath);

% collect data for tab. 1A: epsilon2 under placebo
resultsDir = fullfile(paths.statfold, 'epsi2');
tabDir = fullfile(tabPath, 'epsi2');
mkdir(tabDir);
csvTable = fullfile(resultsDir, 'table_F_peakFWE.csv');
copyfile(csvTable, tabDir);
T = readtable(csvTable);
data.epsi2 = T;

% collect data for tab. 1B: epsilon3 under placebo
resultsDir = fullfile(paths.statfold, 'epsi3');
tabDir = fullfile(tabPath, 'epsi3');
mkdir(tabDir);
csvTable = fullfile(resultsDir, 'table_F_peakFWE.csv');
copyfile(csvTable, tabDir);
T = readtable(csvTable);
data.epsi3 = T;

% save all paper-relevant data for this table
save(fullfile(tabPath, 'tabdata.mat'), 'data');

end

