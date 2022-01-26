function x = DirectSolver(A, b, LAMBDA)
    % This solver solves a linear system directly
    %     (A' * A + lambda * I)x = A' * b [= (b' * A)']
    % Inputs:
    %   A: k-by-r matrix
    %   b: 1-by-k array
    %   LAMBDA: lambda
    
    [~, r] = size(A);
    LHS = A' * A + LAMBDA * eye(r);
    RHS = (b' * A)';
    x = LHS \ RHS;
end