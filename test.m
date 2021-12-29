clear; clc; close all;

ResultLoc = fullfile('results');
FileName = 'softImputeALS_SVD_30_100.mat';

load(fullfile(ResultLoc, FileName));
METRIC.TRAIN.MAE = METRIC.TRAIN.MAE .^ 2;
METRIC.TEST.MAE = METRIC.TEST.MAE .^ 2;
save(fullfile(ResultLoc, FileName), 'METRIC');