function R = Table2Matrix(Data, m, n)
    % Data is an (N, 3) table with UserID, MovieID and Rating columns
    % Return a rating a m-by-n rating matrix R
    % with R(i, j) = User(i)'s rating on Movie(j)

    R = sparse(Data.UserID, Data.MovieID, Data.Rating, m, n);
end