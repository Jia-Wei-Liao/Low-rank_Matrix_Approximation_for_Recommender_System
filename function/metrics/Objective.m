function F = Objective(P, A, B)
    % objective function (X:m-by-n, A:m-by-r, B:r-by-n)
    % F(P, A, B) = .5*fro(Proj(X-AB'))^2 + .5*lambda(fro(A)^2 +fro(B)^2)
    % Where
    %   P = Proj(X-AB'): projection matrix
    %   fro(*) is frobenius norm
    % Input:
    %   P: projection sparse matrix of shape m-by-n (P(X-AB'))
    %   A: dense matrix of shape m-by-r
    %   B: dense matrix of shape n-by-r
    % Output:
    %   F: objective function value F(X, A, B)
    MAIN = norm(P, 'fro')^2;
    PENALTY = norm(A, 'fro')^2 + norm(B, 'fro')^2;
    F = 0.5 * (MAIN + PENALTY);
end