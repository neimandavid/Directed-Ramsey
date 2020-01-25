function out = inneighbors(M, v)
    out = find(M(v, :) == 0);
    out = out(out~=v);
end