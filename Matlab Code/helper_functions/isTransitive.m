%Checks if a tournament is transitive
%Looks at score vector; this should be faster than explicitly looking for 3-cycles
%A is the adjacency matrix of the tournament being tested
%Undefined behavior if A doesn't correspond to a tournament
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