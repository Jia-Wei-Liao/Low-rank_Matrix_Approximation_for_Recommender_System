function [METRIC, U, D, V] = softImputeALS_SVD(TRAIN, TEST, EPOCH, LAMBDA, LATENT_DIM)
    % soft Impute ALS solver
    % Given:
    %   X(m-by-n) matrix, with observed indices OMEGA
    %   r(int) latent space dimension
    % Goal: minimize F(A, B) over A(m-by-r), B(n-by-r)
    % where F(A, B) = fro(Proj_OMEGA(X-AB'))^2 + lambda*(fro(A)^2+fro(B)^2)
    %       fro(*): frobenius norm
    %       Proj_OMEGA(*): keep the entries of observed indices, set the
    %       others to 0
    % Input:
    %     TRAIN, TEST: N-by-3 table, with UserID, MovieID and Rating
    %     columns
    %     EPOCH: training epochs
    %     LAMBDA: regularzation coeficient
    %     LATENT_DIM: latent space dimension
    %     SOLVER: a callable function with
    %        SOLVER(A, b, lambda) solves (A'*A+lambda*I)x=b
    
    % Step1: Construct everything that we need
    m = max(TRAIN.UserID);
    n = max(TRAIN.MovieID);
    R_Train = Table2Matrix(TRAIN, m, n);  % Train matrix
    R_Test  = Table2Matrix(TEST, m, n);   % Test matrix

    % A=U*D (m-by-r), B=VD (n-by-r)
    % U's columns are orthonormal
    % D is diagonal
    TEMP = rand(m, LATENT_DIM); [U, ~, ~] = svds(TEMP, LATENT_DIM);
    D = ones(LATENT_DIM, 1);
    V = zeros(n, LATENT_DIM);
    
    METRIC.TIME       = zeros(EPOCH, 1);
    METRIC.OBJECTIVE  = zeros(EPOCH, 1);
    METRIC.REL_OBJ    = zeros(EPOCH, 1);
    METRIC.TRAIN.RMSE = zeros(EPOCH, 1);
    METRIC.TRAIN.MAE  = zeros(EPOCH, 1);
    METRIC.TEST.RMSE  = zeros(EPOCH, 1);
    METRIC.TEST.MAE   = zeros(EPOCH, 1);
    
    % ALS iteration scheme
    for epoch = 1 : EPOCH
        tic;
        
        % Step 2: Update B
        A = U .* D';
        B = V .* D';
        SHINK = D ./ (D.^2 + LAMBDA);
        SPARSE = R_Train - Projection(R_Train, A, B);
        B = (SHINK .* U') * SPARSE;
        B = B' + V .* (D'.^2) .* SHINK';
        
        [V, D, ~] = svds(B .* D', LATENT_DIM, 'largest');
%         V = V(:, 1:LATENT_DIM);
        D = diag(D).^(1/2);
        
        % Step 3: Update A
        A = U .* D';
        B = V .* D';
        SHINK = D ./ (D.^2 + LAMBDA);
        SPARSE = R_Train - Projection(R_Train, A, B);
        A = SPARSE * (V .* SHINK') + U .* (D'.^2) .* SHINK';
        [U, D, ~] = svds(A .* D', LATENT_DIM, 'largest');
%         U = U(:, 1:LATENT_DIM);
        D = diag(D).^(1/2);
        
        METRIC.TIME(epoch)       = toc;
        A = U .* D'; B = V .* D';
        SPARSE_Train = R_Train - Projection(R_Train, A, B);
        SPARSE_Test = R_Test - Projection(R_Test, A, B);
        METRIC.OBJECTIVE(epoch)  = Objective(SPARSE_Train, A, B);
        if epoch == 1
            METRIC.REL_OBJ(epoch) = 1;
        else
            METRIC.REL_OBJ(epoch) = abs(METRIC.OBJECTIVE(epoch) - METRIC.OBJECTIVE(epoch-1)) / METRIC.OBJECTIVE(epoch);
        end
        METRIC.TRAIN.RMSE(epoch) = RMSE(R_Train, SPARSE_Train);
        METRIC.TRAIN.MAE(epoch)  = MAE(R_Train, SPARSE_Train);
        METRIC.TEST.RMSE(epoch)  = RMSE(R_Test, SPARSE_Test);
        METRIC.TEST.MAE(epoch)   = MAE(R_Test, SPARSE_Test);
        
        fprintf('Epoch: %d, Elpased Time: %f, relative objective: %f\n', ...
                epoch, METRIC.TIME(epoch), METRIC.REL_OBJ(epoch));
        fprintf('Training RMSE: %f, MAE: %f\n', METRIC.TRAIN.RMSE(epoch),...
                METRIC.TRAIN.MAE(epoch));
        fprintf('Testing  RMSE: %f, MAE: %f\n\n', METRIC.TEST.RMSE(epoch),...
                METRIC.TEST.MAE(epoch));
    end
    
end