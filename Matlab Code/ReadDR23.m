%Load some DR TT6-free 23-vertex tournaments
goodcat = {};
fid = fopen('drtourn23');

tcount = 0;
while ~feof(fid)
    mystring = fgetl(fid);
    count = 1;
    T = zeros(23, 23);
    for i = 1:23
        for j = i+1:23
            T(i, j) = mystring(count) == 49;
            T(j, i) = 1 - T(i, j);
            count = count + 1;
        end
    end
    T
    tcount = tcount + 1;
    if hasTTk(T, 6)
        continue;
    end
    goodcat = [goodcat, {digraph(T)}];
end

save('TT6DR23.mat', 'goodcat');