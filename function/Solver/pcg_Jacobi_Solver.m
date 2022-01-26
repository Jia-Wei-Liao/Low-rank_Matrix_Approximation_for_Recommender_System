function x = pcg_Jacobi_Solver(A, b, LAMBDA)
    % This solver solves a linear system by using cg method
    %     (A' * A + lambda * I)x = A' * b [= (b' * A)']
    % Inputs:
    %   A: k-by-r matrix
    %   b: 1-by-k array
    %   LAMBDA: lambda
    
    [~, r] = size(A);
    LHS = A' * A + LAMBDA * eye(r);
    RHS = (b' * A)';
    Dinv = 1 ./ (sum(A.^2) + LAMBDA);
    M = @(x) Dinv .* x;
    [x, ~, ~] = pcg(LHS, RHS, 1e-10, r, M);
end