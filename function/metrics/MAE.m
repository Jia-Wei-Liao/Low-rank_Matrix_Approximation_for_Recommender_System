function r = MAE(X, P)
    % calculate mean absolute error for P = Proj(X - AB')
    % RMSE = sqrt( sum( abs(Proj[X-AB^T]) / N )
    % where 
    %   Proj(*) is the projection function that keeps the value of nonzero
    %   entries of X
    %   N is the number of nonzero elements in X
    % Inputs:
    %   X: m-by-n sparse matrix
    %   P: m-by-n projected sparse matrix P(X-AB')
    
    N = numel(find(X));
    r = sum(abs(P), 'all');
    r = full(r / N);
end