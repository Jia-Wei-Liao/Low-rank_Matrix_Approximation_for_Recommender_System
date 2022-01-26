function Mov2Usr = Get_Mov2Usr(Data)
    % Data is an (N, 3) table with UserID, MovieID and Rating columns
    % Return a rating a structure Usr2Mov (User to Movie) with
    %   MovieID: an array indicate MovieID (e.g: [1, 2, 3, ..., 174])
    %            elements in MovieID is unique
    %   UserID: an array indicate UserID
    %           however, we don't perform unique here
    %   Fptr, Lptr: two arrays indicate first/last pointer
    %               if [f, l] = [Fptr(i), Lptr(i)]
    %               then MovieID(i) rates by UserID(f:l)
    
    Data = table2array(Data);
    UserID = Data(:, 1);
    MovieID  = Data(:, 2);
    
    [MovieID, Permute] = sort(MovieID);
    UserID = UserID(Permute);
    
    [UniqMovID, Fptr, ~] = unique(MovieID, 'first');
    [~, Lptr, ~] = unique(MovieID, 'last');
    
    Mov2Usr.UserID = UserID;
    Mov2Usr.MovieID = UniqMovID;
    Mov2Usr.Fptr = Fptr;
    Mov2Usr.Lptr = Lptr;
end