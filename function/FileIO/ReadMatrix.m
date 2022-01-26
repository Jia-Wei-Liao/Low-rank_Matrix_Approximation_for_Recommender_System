function R = ReadMatrix(csvpath)
    Data = readtable(csvpath);
    % Generate rating matrix
    R = sparse(Data.UserID, Data.MovieID, Data.Rating);
end