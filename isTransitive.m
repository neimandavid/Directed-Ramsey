%Looks at score vector, should be faster than looking for 3-cycles
function b = isTransitive(A)
    if any(A(:)<0)
        b = false;
        return;
    end
    n = size(A, 1); %A is square, just need one dimension
    
    %Check if degree sequence matches 0, 1, ..., n-1
    b = isequal(sort(sum(A)), (0:(n-1)));
    return;
end