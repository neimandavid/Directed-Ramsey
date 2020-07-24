%Tests a given size-24 tournament case
%Only need to test blobs with size between 4 and 6; sizes should add to 22
%(If sizes don't add to 22, there are probably bugs, so don't do that...)
%Blockparams is a length-4 vector of sizes for each block

%Things that are slow: Big D blocks (more cases for the D block and more
%free variables at the end)
function outcats = runCase(blocksizes)
    parpool(1); %Increase this if you're on a multi-core computer

    %Step 0: Initialize blockparams to a format I expect
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
            strcat("i = ", num2str(i), " of ",...
                num2str(size(metacatalog{blocksizes(1)+1}, 2)),...
                "; j = ", num2str(j), " of ",...
                num2str(size(metacatalog{blocksizes(2)+1}, 2)))
            T = -ones(24, 24) + eye(24);
            %Fill in A and B blocks
            T(blockparams(1, 1):blockparams(1, 2),...
                blockparams(1, 1):blockparams(1, 2)) =...
                full(adjacency(metacatalog{blocksizes(1)+1}{i}));
            T(blockparams(2, 1):blockparams(2, 2),...
                blockparams(2, 1):blockparams(2, 2)) =...
                full(adjacency(metacatalog{blocksizes(2)+1}{j}));
            %Add u, v and their connections:
            %A is double out, so A <- u, v
            T(blockparams(1, 1):blockparams(1, 2), 23:24) = 0;
            T(23:24, blockparams(1, 1):blockparams(1, 2)) = 1;
            %u->B->v
            T(blockparams(2, 1):blockparams(2, 2), 23) = 0;
            T(blockparams(2, 1):blockparams(2, 2), 24) = 1;
            T(23, blockparams(2, 1):blockparams(2, 2)) = 1;
            T(24, blockparams(2, 1):blockparams(2, 2)) = 0;
            %C is double in, so C -> u, v
            T(blockparams(3, 1):blockparams(3, 2), 23:24) = 1;
            T(23:24, blockparams(3, 1):blockparams(3, 2)) = 0;
            %v->D->u
            T(blockparams(4, 1):blockparams(4, 2), 23) = 1;
            T(blockparams(4, 1):blockparams(4, 2), 24) = 0;
            T(23, blockparams(4, 1):blockparams(4, 2)) = 0;
            T(24, blockparams(4, 1):blockparams(4, 2)) = 1;
            %u -> v
            T(23, 24) = 1; T(24, 23) = 0;
            
            v = [23, 24, blockparams(1, 1):blockparams(2, 2)];
            outcatAB = [outcatAB, bruteForceColumns(T(v, v),...
                6, blocksizes(1) + 2)];
        end
    end
    outcatABs = outcatAB;

    'Step 2: Get all isomorphism classes for BC'
    outcatBC = {};
    load('metacatalogtt4.mat');
    parfor i = 1:size(metacatalog{blocksizes(3)+1}, 2)
        for j = 1:size(metacatalog{blocksizes(2)+1}, 2)
            strcat("i = ", num2str(i), " of ",...
                num2str(size(metacatalog{blocksizes(3)+1}, 2)),...
                "; j = ", num2str(j), " of ",...
                num2str(size(metacatalog{blocksizes(2)+1}, 2)))
            T = -ones(24, 24) + eye(24);
            %Fill in C and B blocks
            T(blockparams(3, 1):blockparams(3, 2),...
                blockparams(3, 1):blockparams(3, 2)) =...
                full(adjacency(metacatalog{blocksizes(3)+1}{i}));
            T(blockparams(2, 1):blockparams(2, 2),...
                blockparams(2, 1):blockparams(2, 2)) =...
                full(adjacency(metacatalog{blocksizes(2)+1}{j}));
            
            %Add u, v and their connections:
            %A is double out, so A <- u, v
            T(blockparams(1, 1):blockparams(1, 2), 23:24) = 0;
            T(23:24, blockparams(1, 1):blockparams(1, 2)) = 1;
            %u->B->v
            T(blockparams(2, 1):blockparams(2, 2), 23) = 0;
            T(blockparams(2, 1):blockparams(2, 2), 24) = 1;
            T(23, blockparams(2, 1):blockparams(2, 2)) = 1;
            T(24, blockparams(2, 1):blockparams(2, 2)) = 0;
            %C is double in, so C -> u, v
            T(blockparams(3, 1):blockparams(3, 2), 23:24) = 1;
            T(23:24, blockparams(3, 1):blockparams(3, 2)) = 0;
            %v->D->u
            T(blockparams(4, 1):blockparams(4, 2), 23) = 1;
            T(blockparams(4, 1):blockparams(4, 2), 24) = 0;
            T(23, blockparams(4, 1):blockparams(4, 2)) = 0;
            T(24, blockparams(4, 1):blockparams(4, 2)) = 1;
            %u -> v
            T(23, 24) = 1; T(24, 23) = 0;
            
            v = [23, 24, blockparams(2, 1):blockparams(3, 2)];
            outcatBC = [outcatBC, bruteForceColumns(T(v, v),...
                6, blocksizes(2) + 2)];
        end
    end
    outcatBCs = outcatBC;

    'Step 3: Combine these into all combinations of ABC blocks'
    %I'll blindly assume B is the same block for each case. Could slow
    %stuff down for B = 4 (B = 5 and either AB or BC only has one option
    %because that combined with u or v is the ST12), but I'm okay with this
    %If B blocks are different, I'll either get isomorphic stuff that's
    %pruned later, or bad cases I could have thrown out earlier but didn't
    
    outcatABC = {};
    parfor i = 1:size(outcatABs, 2)
        for j = 1:size(outcatBCs, 2)
            %Display progress
            strcat("i = ", num2str(i), " of ", num2str(size(outcatABs, 2)),...
                "; j = ", num2str(j), " of ", num2str(size(outcatBCs, 2)))
            
            %Add AB
            T = -ones(24, 24) + eye(24);
            temp = full(adjacency(outcatABs{i}));
            v = (blockparams(1, 1):blockparams(2, 2)) + 2;
            T(blockparams(1, 1):blockparams(2, 2),...
                blockparams(1, 1):blockparams(2, 2)) = temp(v, v);
            
            %Add BC
            temp2 = full(adjacency(outcatBCs{j}));
            %Start at 3, get the rest of the matrix
            v2 = (blockparams(2, 1):blockparams(3, 2)) - blockparams(2, 1) + 3;
            T(blockparams(2, 1):blockparams(3, 2),...
                blockparams(2, 1):blockparams(3, 2)) = temp2(v2, v2);
            
            %Add u, v and their connections:
            %A is double out, so A <- u, v
            T(blockparams(1, 1):blockparams(1, 2), 23:24) = 0;
            T(23:24, blockparams(1, 1):blockparams(1, 2)) = 1;
            %u->B->v
            T(blockparams(2, 1):blockparams(2, 2), 23) = 0;
            T(blockparams(2, 1):blockparams(2, 2), 24) = 1;
            T(23, blockparams(2, 1):blockparams(2, 2)) = 1;
            T(24, blockparams(2, 1):blockparams(2, 2)) = 0;
            %C is double in, so C -> u, v
            T(blockparams(3, 1):blockparams(3, 2), 23:24) = 1;
            T(23:24, blockparams(3, 1):blockparams(3, 2)) = 0;
            %v->D->u
            T(blockparams(4, 1):blockparams(4, 2), 23) = 1;
            T(blockparams(4, 1):blockparams(4, 2), 24) = 0;
            T(23, blockparams(4, 1):blockparams(4, 2)) = 0;
            T(24, blockparams(4, 1):blockparams(4, 2)) = 1;
            %u -> v
            T(23, 24) = 1; T(24, 23) = 0;
            %Pick appropriate columns and solve
            v = [23, 24, blockparams(1, 1):blockparams(3, 2)];
            outcatABC = [outcatABC, bruteForceColumns(T(v, v),...
                6, blocksizes(1) + blocksizes(2) + 2)];
        end
    end
    outcatABCs = outcatABC;
    
    'Step 4: Add all possible D tournaments'
    outcat = {};
    load('metacatalogtt5.mat');
    parfor i = 1:size(outcatABCs, 2)
        pause(0.001); %So stuff prints
	for j = 1:size(metacatalog{blocksizes(4)+1}, 2)
            strcat("i = ", num2str(i), " of ", num2str(size(outcatABCs, 2)),...
                "; j = ", num2str(j), " of ",...
                num2str(size(metacatalog{blocksizes(4)+1}, 2)))
            T = -ones(24, 24) + eye(24);
            %Add ABC
            temp = full(adjacency(outcatABCs{i}));
            v = (blockparams(1, 1):blockparams(3, 2))+2;
            T(blockparams(1, 1):blockparams(3, 2),...
                blockparams(1, 1):blockparams(3, 2)) = temp(v, v);
            %Add D
            T(blockparams(4, 1):blockparams(4, 2),...
                blockparams(4, 1):blockparams(4, 2)) =...
                full(adjacency(metacatalog{blocksizes(4) + 1}{j}));
            
            %Add u, v and their connections:
            %A is double out, so A <- u, v
            T(blockparams(1, 1):blockparams(1, 2), 23:24) = 0;
            T(23:24, blockparams(1, 1):blockparams(1, 2)) = 1;
            %u->B->v
            T(blockparams(2, 1):blockparams(2, 2), 23) = 0;
            T(blockparams(2, 1):blockparams(2, 2), 24) = 1;
            T(23, blockparams(2, 1):blockparams(2, 2)) = 1;
            T(24, blockparams(2, 1):blockparams(2, 2)) = 0;
            %C is double in, so C -> u, v
            T(blockparams(3, 1):blockparams(3, 2), 23:24) = 1;
            T(23:24, blockparams(3, 1):blockparams(3, 2)) = 0;
            %v->D->u
            T(blockparams(4, 1):blockparams(4, 2), 23) = 1;
            T(blockparams(4, 1):blockparams(4, 2), 24) = 0;
            T(23, blockparams(4, 1):blockparams(4, 2)) = 0;
            T(24, blockparams(4, 1):blockparams(4, 2)) = 1;
            %u -> v
            T(23, 24) = 1; T(24, 23) = 0;
            %Pick appropriate columns and solve
            v = [23, 24, 1:22];
            outcat = [outcat, bruteForceColumns(T(v, v),...
                6, blockparams(3, 2) + 2)];
        end
    end
    outcats = stripIsomorphicCopies(outcat);
    return;
end