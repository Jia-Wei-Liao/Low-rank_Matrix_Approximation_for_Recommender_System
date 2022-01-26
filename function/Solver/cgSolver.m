function x = cgSolver(A, b, LAMBDA)
    % This solver solves a linear system by using cg method
    %     (A' * A + lambda * I)x = A' * b [= (b' * A)']
    % Inputs:
    %   A: k-by-r matrix
    %   b: 1-by-k array
    %   LAMBDA: lambda
    
    [~, r] = size(A);
    LHS = @(x) (((A * x)' * A)' + LAMBDA * x);
    RHS = (b' * A)';
    [x, ~, ~] = pcg(LHS, RHS, 1e-10, r);
end