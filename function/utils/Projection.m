function P = Projection(X, A, B)
    % Implement the projection function P_{\Omega}(AB')
    % Inputs:
    %   A: (m-by-r) full matrix
    %   B: (n-by-r) full matrix
    %   X: (m-by-n) sparse matrix with (user id, movie id, rating) triplet.
    [I, J] = find(X);
    [m, n] = size(X);
    P = sparse(I, J, sum(A(I,:) .* B(J,:), 2), m, n);
    
%     [Rows, Cols] = find(X);
%     
%     [Cols, Permute] = sort(Cols);
%     Rows = Rows(Permute);
%     
%     [~, Fptr, ~] = unique(Cols, 'first');
%     [~, Lptr, ~] = unique(Cols, 'last');
%     
%     Vals = cell(numel(Fptr), 1);
%     parfor id = 1 : numel(Fptr)
%         fptr = Fptr(id);
%         lptr = Lptr(id);
%         
%         Vals{id} = A(Rows(fptr : lptr), :) * B(Cols(fptr), :)';
%     end
%     Vals = cell2mat(Vals);
%     P = sparse(Rows, Cols, Vals);
end