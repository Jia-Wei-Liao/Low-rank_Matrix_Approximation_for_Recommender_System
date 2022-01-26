function [R, User2Obj, Obj2User] = ReadTrain(csvpath)
    Data = readtable(csvpath);
    % Generate rating matrix
    R = sparse(Data.UserID, Data.MovieID, Data.Rating);
    
    Data = table2array(Data);
    
    % Generate User structure 
    temp = Data(:, 1:2);  % [UserID, ObjID]
    [C, fia, ~] = unique(temp(:,1), 'first');
    [~, lia, ~] = unique(temp(:,1), 'last');
    User2Obj.UsrID = C;
    User2Obj.Indices = temp(:, 2);  % ObjID
    User2Obj.Fptr = fia;
    User2Obj.Lptr = lia;
    
    % Generate Obj structure
    [~, I] = sort(temp(:, 2));
    temp = temp(I, :);
    [C, fia, ~] = unique(temp(:,2), 'first');
    [~, lia, ~] = unique(temp(:,2), 'last');
    Obj2User.ObjID = C;
    Obj2User.Indices = temp(:, 1);  % UserID
    Obj2User.Fptr = fia;
    Obj2User.Lptr = lia;
end