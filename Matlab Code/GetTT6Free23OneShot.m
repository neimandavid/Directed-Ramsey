%7374 (ran for regular, no tournaments (fails on ABC! Can verify with a SAT solver in about 10 minutes))
%6663 (found 11, all subtournaments of ST27)
%6654 (found 17, all subtournaments of ST27)
%6645 (found same 17 as 6654, still all subtournaments of ST27)
%6564 (found 20 (no 10 or 21).)
%6555 (found all 22 subtournaments)
%6465 (found 20 (no 9 or 22). Previously ran for regular but reran this version)
%5655 (found 20 (no 10 or 21). NOTE: Any non-DR tournament will get caught by an earlier case)
%5556 (only care about the three DR tournaments; by definition, anything else pops up in another category also)

global memonchoosek;
memonchoosek = memoize(@nchoosek);
memonchoosek.CacheSize = 1000;

tic
blocksizes = [6, 6, 4, 5]; %Sum to 21
n = sum(blocksizes) + 2;
myfilename = strcat('myfile', num2str(blocksizes), '.mat');
myfilename = myfilename(~isspace(myfilename))

%Step 0: Initialize blockparams to a format I expect
%[startA, endA; startB, endB; etc.]
blockparams = zeros(4, 2);
blockparams(1, 1) = 1; blockparams(4, 2) = sum(blocksizes);
for i = 2:4
    blockparams(i, 1) = blockparams(i-1, 1) + blocksizes(i-1);
    blockparams(i-1, 2) = blockparams(i, 1) - 1;
end

'Step 1: Get all isomorphism classes for AB'
outcatAB = {};
load('metacatalogtt4.mat');
parfor i = 1:size(metacatalog{blocksizes(1)+1}, 2)
    for j = 1:size(metacatalog{blocksizes(2)+1}, 2)
        strcat("i = ", num2str(i), " of ", num2str(size(metacatalog{blocksizes(1)+1}, 2)), "; j = ", num2str(j), " of ", num2str(size(metacatalog{blocksizes(2)+1}, 2)))
        T = -ones(n, n) + eye(n);
        %Fill in A and B blocks
        T(blockparams(1, 1):blockparams(1, 2), blockparams(1, 1):blockparams(1, 2)) = full(adjacency(metacatalog{blocksizes(1)+1}{i}));
        T(blockparams(2, 1):blockparams(2, 2), blockparams(2, 1):blockparams(2, 2)) = full(adjacency(metacatalog{blocksizes(2)+1}{j}));
        %Fill in u and v rows
        T(blockparams(1, 1):blockparams(1, 2), n-1:n) = 0; T(n-1:n, blockparams(1, 1):blockparams(1, 2)) = 1; %A is double out, so A <- u, v
        T(blockparams(2, 1):blockparams(2, 2), n-1) = 0; T(blockparams(2, 1):blockparams(2, 2), n) = 1; T(n-1, blockparams(2, 1):blockparams(2, 2)) = 1; T(n, blockparams(2, 1):blockparams(2, 2)) = 0; %B is transitive
        T(blockparams(3, 1):blockparams(3, 2), n-1:n) = 1; T(n-1:n, blockparams(3, 1):blockparams(3, 2)) = 0; %C is double in
        T(blockparams(4, 1):blockparams(4, 2), n-1) = 1; T(blockparams(4, 1):blockparams(4, 2), n) = 0; T(n-1, blockparams(4, 1):blockparams(4, 2)) = 0; T(n, blockparams(4, 1):blockparams(4, 2)) = 1; %D is cycle
        T(n-1, n) = 1; T(n, n-1) = 0; %u -> v

        v = [n-1, n, blockparams(1, 1):blockparams(2, 2)]; %This vector and the norig value have to be chosen cleverly...
        outcatAB = [outcatAB, bruteForceColumns(T(v, v), 6, blocksizes(1) + 2)];
    end
end
outcatABs = outcatAB;
save(myfilename);

'Step 2: Get all isomorphism classes for BC'
outcatBC = {};
load('metacatalogtt4.mat');
parfor i = 1:size(metacatalog{blocksizes(3)+1}, 2)
    for j = 1:size(metacatalog{blocksizes(2)+1}, 2)
        strcat("i = ", num2str(i), " of ", num2str(size(metacatalog{blocksizes(3)+1}, 2)), "; j = ", num2str(j), " of ", num2str(size(metacatalog{blocksizes(2)+1}, 2)))
        T = -ones(n, n) + eye(n);
        %Fill in C and B blocks
        T(blockparams(3, 1):blockparams(3, 2), blockparams(3, 1):blockparams(3, 2)) = full(adjacency(metacatalog{blocksizes(3)+1}{i}));
        T(blockparams(2, 1):blockparams(2, 2), blockparams(2, 1):blockparams(2, 2)) = full(adjacency(metacatalog{blocksizes(2)+1}{j}));
        %Fill in u and v rows
        T(blockparams(1, 1):blockparams(1, 2), n-1:n) = 0; T(n-1:n, blockparams(1, 1):blockparams(1, 2)) = 1; %A is double out, so A <- u, v
        T(blockparams(2, 1):blockparams(2, 2), n-1) = 0; T(blockparams(2, 1):blockparams(2, 2), n) = 1; T(n-1, blockparams(2, 1):blockparams(2, 2)) = 1; T(n, blockparams(2, 1):blockparams(2, 2)) = 0; %B is transitive
        T(blockparams(3, 1):blockparams(3, 2), n-1:n) = 1; T(n-1:n, blockparams(3, 1):blockparams(3, 2)) = 0; %C is double in
        T(blockparams(4, 1):blockparams(4, 2), n-1) = 1; T(blockparams(4, 1):blockparams(4, 2), n) = 0; T(n-1, blockparams(4, 1):blockparams(4, 2)) = 0; T(n, blockparams(4, 1):blockparams(4, 2)) = 1; %D is cycle
        T(n-1, n) = 1; T(n, n-1) = 0; %u -> v

        v = [n-1, n, blockparams(2, 1):blockparams(3, 2)]; %This vector and the norig value have to be chosen cleverly...
        outcatBC = [outcatBC, bruteForceColumns(T(v, v), 6, blocksizes(2) + 2)];
    end
end
outcatBCs = outcatBC;
save(myfilename);

'Step 3: Combine these into all combinations of ABC blocks'
%I'll blindly assume B is the same block for each case. Could slow
%stuff down for B = 4 (B = 5 and either AB or BC only has one option
%because that combined with u or v is the ST12), but I'm okay with this
%If B blocks are different, I'll either get isomorphic stuff that's
%pruned later, or bad cases I could have thrown out earlier but didn't

%In BC: B is 3:blocksizes(2)+1
%In AB: B = end-blocksizes(2)+1:end

outcatABC = {};
parfor i = 1:size(outcatABs, 2)
    strcat("i = ", num2str(i), " of ", num2str(size(outcatABs, 2)))
    pause(0.001); %So stuff prints
    for j = 1:size(outcatBCs, 2)
        %strcat("j = ", num2str(j), " of ", num2str(size(outcatBCs, 2)))
        %Add AB
        T = -ones(n, n) + eye(n);
        temp = full(adjacency(outcatABs{i}));
        v = (blockparams(1, 1):blockparams(2, 2)) + 2;
        T(blockparams(1, 1):blockparams(2, 2), blockparams(1, 1):blockparams(2, 2)) = temp(v, v);
        %Add BC
        temp2 = full(adjacency(outcatBCs{j}));
        v2 = (blockparams(2, 1):blockparams(3, 2)) - blockparams(2, 1) + 3; %Start at 3, get the rest of the matrix
        T(blockparams(2, 1):blockparams(3, 2), blockparams(2, 1):blockparams(3, 2)) = temp2(v2, v2);
        %Check for incompatible B block
        v0 = (blockparams(2, 1):blockparams(2, 2)) + 2;
        v00 = (blockparams(2, 1):blockparams(2, 2)) - blockparams(2, 1) + 3;
        if ~isequal(temp(v0, v0), temp2(v00, v00))
            continue;
        end
        %Add u, v
        T(blockparams(1, 1):blockparams(1, 2), n-1:n) = 0; T(n-1:n, blockparams(1, 1):blockparams(1, 2)) = 1; %A is double out, so A <- u, v
        T(blockparams(2, 1):blockparams(2, 2), n-1) = 0; T(blockparams(2, 1):blockparams(2, 2), n) = 1; T(n-1, blockparams(2, 1):blockparams(2, 2)) = 1; T(n, blockparams(2, 1):blockparams(2, 2)) = 0; %B is transitive
        T(blockparams(3, 1):blockparams(3, 2), n-1:n) = 1; T(n-1:n, blockparams(3, 1):blockparams(3, 2)) = 0; %C is double in
        T(blockparams(4, 1):blockparams(4, 2), n-1) = 1; T(blockparams(4, 1):blockparams(4, 2), n) = 0; T(n-1, blockparams(4, 1):blockparams(4, 2)) = 0; T(n, blockparams(4, 1):blockparams(4, 2)) = 1; %D is cycle
        T(n-1, n) = 1; T(n, n-1) = 0; %u -> v
        %Pick appropriate columns and solve
        v = [n-1, n, blockparams(1, 1):blockparams(3, 2)]; %This vector and the norig value have to be chosen cleverly...
        outcatABC = [outcatABC, bruteForceColumns(T(v, v), 6, blocksizes(1) + blocksizes(2) + 2)];
    end
end
outcatABCs = outcatABC;
%NOTE: outcatABCs has stuff in the order [u, v, A, B, C]
save(myfilename);

'Step 4: Add all possible D tournaments'
outcat = {};
load('metacatalogtt5.mat');
for i = 1:size(outcatABCs, 2)
    strcat("i = ", num2str(i), " of ", num2str(size(outcatABCs, 2)))
    pause(0.001); %So stuff prints
    for j = 1:size(metacatalog{blocksizes(4)+1}, 2)
        strcat("j = ", num2str(j), " of ", num2str(size(metacatalog{blocksizes(4)+1}, 2)))
        T = -ones(n-1, n-1) + eye(n-1);
        %Add ABC
        temp = full(adjacency(outcatABCs{i}));
        v = (blockparams(1, 1):blockparams(3, 2))+2; %The +2 skips u and v
        T(blockparams(1, 1):blockparams(3, 2), blockparams(1, 1):blockparams(3, 2)) = temp(v, v);
        %Add D
        T(blockparams(4, 1):blockparams(4, 2), blockparams(4, 1):blockparams(4, 2)) = full(adjacency(metacatalog{blocksizes(4) + 1}{j}));
        %Add u, v
        T(blockparams(1, 1):blockparams(1, 2), n-1:n) = 0; T(n-1:n, blockparams(1, 1):blockparams(1, 2)) = 1; %A is double out, so A <- u, v
        T(blockparams(2, 1):blockparams(2, 2), n-1) = 0; T(blockparams(2, 1):blockparams(2, 2), n) = 1; T(n-1, blockparams(2, 1):blockparams(2, 2)) = 1; T(n, blockparams(2, 1):blockparams(2, 2)) = 0; %B is transitive
        T(blockparams(3, 1):blockparams(3, 2), n-1:n) = 1; T(n-1:n, blockparams(3, 1):blockparams(3, 2)) = 0; %C is double in
        T(blockparams(4, 1):blockparams(4, 2), n-1) = 1; T(blockparams(4, 1):blockparams(4, 2), n) = 0; T(n-1, blockparams(4, 1):blockparams(4, 2)) = 0; T(n, blockparams(4, 1):blockparams(4, 2)) = 1; %D is cycle
        T(n-1, n) = 1; T(n, n-1) = 0; %u -> v
        %Pick appropriate columns and solve
        v = [n-1, n, 1:n-2]; %This vector and the norig value have to be chosen cleverly...
        outcat = [outcat, bruteForceColumns(T(v, v), 6, blockparams(3, 2) + 2)];
    end
end
outcats = stripIsomorphicCopies(outcat);
save(myfilename);
toc
return;