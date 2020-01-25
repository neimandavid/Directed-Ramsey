function out = outneighbors(M, v)
    out = find(M(v, :) == 1);
end