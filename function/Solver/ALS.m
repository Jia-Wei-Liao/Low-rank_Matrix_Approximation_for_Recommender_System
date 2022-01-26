function [METRIC, A, B] = ALS(TRAIN, TEST, EPOCH, LAMBDA, LATENT_DIM, SOLVER)
    % ALS solver
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
    Usr2Mov = Get_Usr2Mov(TRAIN);   % User 2 Movie correspondence
    Mov2Usr = Get_Mov2Usr(TRAIN);   % Movie 2 User correspondence
    
    M_user = length(Usr2Mov.UserID);   % Number of users in training data
    N_movie = length(Mov2Usr.MovieID); % Number of movies in training data

    A = rand(m, LATENT_DIM);         % Initialize A
    B = rand(n, LATENT_DIM);         % Initialize B
    
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
        % Step 2.1: Fix Y, update X(u, :) (u = 1, ..., m)
        for id = 1 : M_user
            % Update user vector
            user = Usr2Mov.UserID(id);
            
            % Which movies rated by that user before?
            Fptr = Usr2Mov.Fptr(id);
            Lptr = Usr2Mov.Lptr(id);
            movie = Usr2Mov.MovieID(Fptr : Lptr);
            
            % construct B_user and R_user
            B_user = B(movie, :);           % movie-by-r
            R_user = R_Train(user, movie);  % 1-by-movie
            
            % Solve Tx = b and update A(usr, :)
            % Where T = B_user' * B_user + lambda * I, r-by-r
            %       b = B_user' * R_user,              r-by-1
            A(user, :) = SOLVER(B_user, R_user', LAMBDA);
        end
        
        % Step 2.2: Fix X, update Y(i, :) (i = 1, ..., n)
        for id = 1 : N_movie
            % Update movie vector
            movie = Mov2Usr.MovieID(id);
            
            % Which user rated this movive before?
            Fptr = Mov2Usr.Fptr(id);
            Lptr = Mov2Usr.Lptr(id);
            user = Mov2Usr.UserID(Fptr : Lptr);
            
            % construct A_movie and R_movie
            A_movie = A(user, :);            % user-by-r
            R_movie = R_Train(user, movie);  % user-by-1
            
            % Solve Tx = b and update B(movie, :)
            % Where T = A_movie' * A_movie + lambda * I, r-by-r
            %       b = A_movie' * A_movie,              r-by-1
            B(movie, :) = SOLVER(A_movie, R_movie, LAMBDA);
        end
        
        METRIC.TIME(epoch)       = toc;
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