function [R] = ReadTest(csvpath)
    Data = readtable(csvpath);
    % Generate rating matrix
    R = sparse(Data.UserID, Data.MovieID, Data.Rating);
end