function Usr2Mov = Get_Usr2Mov(Data)
    % Data is an (N, 3) table with UserID, MovieID and Rating columns
    % Return a rating a structure Usr2Mov (User to Movie) with
    %   UserID: an array indicate UserID (e.g: [1, 2, 3, ..., 87])
    %           elements in UserID is unique
    %   MovieID: an array indicate MovieID
    %            however, we don't perform unique here
    %   Fptr, Lptr: two arrays indicate first/last pointer
    %               if [f, l] = [Fptr(i), Lptr(i)]
    %               then UserID(i) rates MovieID(f:l)
    
    Data = table2array(Data);
    UserID = Data(:, 1);
    MovieID  = Data(:, 2);
    
    [UserID, Permute] = sort(UserID);
    MovieID = MovieID(Permute);
    
    [UniqUsrID, Fptr, ~] = unique(UserID, 'first');
    [~, Lptr, ~] = unique(UserID, 'last');
    
    Usr2Mov.UserID = UniqUsrID;
    Usr2Mov.MovieID = MovieID;
    Usr2Mov.Fptr = Fptr;
    Usr2Mov.Lptr = Lptr;
end