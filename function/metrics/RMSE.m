function r = RMSE(X, P)
    % calculate root mean square error for P = Proj(X - AB')
    % RMSE = sqrt( sum( Proj[X-AB^T].^2 / N )
    % where 
    %   Proj(*) is the projection function that keeps the value of nonzero
    %   entries of X
    %   N is the number of nonzero elements in X
    % Inputs:
    %   X: m-by-n sparse matrix
    %   P: m-by-n projection sparse matrix (Proj(X - AB'))
    N = numel(find(X));
    r = sum(P.^2, 'all');
    r = full(sqrt(r / N));
end