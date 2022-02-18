function TTk = makeTTk(k)
    TTk = eye(k) - ones(k);
    for i = 1:k
        for j = i+1:k
            TTk(i, j) = 1; TTk(j, i) = 0;
        end
    end
end
