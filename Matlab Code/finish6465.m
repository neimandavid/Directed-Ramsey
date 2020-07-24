load('runCase6  4  6  6.mat')
load('metacatalogtt5.mat')
outcat = {};
tic
for i = 1:size(outcatABCs, 2)
    i
    T = -ones(23, 23) + eye(23);
    T(1:18, 1:18) = full(adjacency(outcatABCs{i}));
    T(1, 19:23) = 0; T(19:23, 1) = 1;
    T(2, 19:23) = 1; T(19:23, 2) = 0;
    for j = 1:size(metacatalog{6}, 2)
        j
        T(19:23, 19:23) = full(adjacency(metacatalog{6}{j}));
        outcat = [outcat, bruteForceEdges(T, 6)];
    end
    size(outcat, 2)
    toc
end
outcats = stripIsomorphicCopies(outcat);