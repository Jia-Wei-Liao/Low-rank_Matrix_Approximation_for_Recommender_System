function absDiff = Testing(Rtest, X, Y)
    GT = full(Rtest(Rtest > 0));
    
    PD = (Rtest > 0) .* (X * Y');
    PD = full(PD(Rtest > 0));
    PD = round(PD);
    PD(PD > 5) = 5;
    PD(PD < 1) = 1;
    
    absDiff = abs(GT-PD);
end