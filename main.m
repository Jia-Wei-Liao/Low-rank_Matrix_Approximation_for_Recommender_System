clear; clc; close all;
addpath(genpath('function'));
addpath(genpath('dataset'));

%% Settings
DATASET = 'ml-1m';  % ml-1m or ml-10m
METHOD = 'softImputeALS_SVD';  % ALS, softImputeALS, softImputeALS_SVD
SOLVER = 'cg';
SAVE_MATRIX = true;

EPOCH = 1000;
LAMBDA = 10;
LATENT_DIM = 50;

%% Read csv tables
TRAIN = readtable(fullfile('dataset', DATASET, 'Train.csv'));
TEST = readtable(fullfile('dataset', DATASET, 'Test.csv'));

%% 
switch METHOD
    case 'ALS'
        switch upper(SOLVER)
            case 'DIRECT'
                SOLVER_handle = @(A, b, LAMBDA) DirectSolver(A, b, LAMBDA);
            case 'CG'
                SOLVER_handle = @(A, b, LAMBDA) cgSolver(A, b, LAMBDA);
            otherwise
                error('Not implemented');
        end
        [METRIC, A, B] = ALS(TRAIN, TEST, EPOCH, LAMBDA, LATENT_DIM, SOLVER_handle);
        FileName = [DATASET '_' METHOD '_' SOLVER '_' num2str(LAMBDA) '_' num2str(LATENT_DIM)];
    case 'softImputeALS'
        [METRIC, A, B] = softImputeALS(TRAIN, TEST, EPOCH, LAMBDA, LATENT_DIM);
        FileName = [DATASET '_' METHOD '_' num2str(LAMBDA) '_' num2str(LATENT_DIM)];
    case 'softImputeALS_SVD'
        [METRIC, U, D, V] = softImputeALS_SVD(TRAIN, TEST, EPOCH, LAMBDA, LATENT_DIM);
        FileName = [DATASET '_' METHOD '_' num2str(LAMBDA) '_' num2str(LATENT_DIM)];
    otherwise
        error('Not Implemented');
end

if SAVE_MATRIX && strcmp(METHOD, 'softImputeALS_SVD')
    save(fullfile('results', [FileName '.mat']), 'METRIC', 'U', 'D', 'V');
elseif SAVE_MATRIX && ~strcmp(METHOD, 'softImputeALS_SVD')
    save(fullfile('results', [FileName '.mat']), 'METRIC', 'A', 'B');
else
    save(fullfile('results', [FileName '.mat']), 'METRIC');
end