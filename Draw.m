clear; clc; close all;
addpath(genpath('function'));

%% Settings
DATASET = 'ml-1m';  % ml-1m or ml-10m
if strcmp(DATASET, 'ml-1m')
    SOLVER = 'DIRECT';
else
    SOLVER = 'cg';
end

% ALS, softImputeALS, softImputeALS_SVD
LAMBDA = 10;
LATENT_DIM = 50;

%% Read data and plot
figure(1);

% load ALS
load(fullfile('results', [DATASET '_ALS_' SOLVER '_' num2str(LAMBDA) '_' num2str(LATENT_DIM) '.mat']));
METRIC.CUMTIME = cumsum(METRIC.TIME);
plot(METRIC.CUMTIME, METRIC.TEST.RMSE); hold on;

% load softImputeALS
load(fullfile('results', [DATASET '_softImputeALS_' num2str(LAMBDA) '_' num2str(LATENT_DIM) '.mat']));
METRIC.CUMTIME = cumsum(METRIC.TIME);
plot(METRIC.CUMTIME, METRIC.TEST.RMSE); hold on;

% load softImputeALS_SVD
load(fullfile('results', [DATASET '_softImputeALS_SVD_' num2str(LAMBDA) '_' num2str(LATENT_DIM) '.mat']));
METRIC.CUMTIME = cumsum(METRIC.TIME);
plot(METRIC.CUMTIME, METRIC.TEST.RMSE); hold on;

ylim([0.7,1]);
legend('ALS', 'softImpute ALS', 'softImpute ALS SVD');