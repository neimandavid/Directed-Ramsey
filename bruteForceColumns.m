function catalog = bruteForceColumns(G, k, norig, colcats)
    %Need G, k, norig; colcats optional
    %norig: Size of the known upper-left block
    %colcats: Catalog of valid columns for each column past norig

    %If colcats not given, auto-generate it
    if nargin == 3
        n = size(G, 1);
        colcats = {};
        for i = norig+1:n
            v = [1:norig, i];
            valid = bruteForceEdges(G(v, v), k);
            if size(valid, 2) == 0
                catalog = {};
                return;
            end
            colcat = {};
            for l = 1:size(valid, 2)
                temp = full(adjacency(valid{l}));
                colcat = [colcat, {temp(1:norig, norig+1)}];
            end
            colcats = [colcats, {colcat}];
        end
    end

    if nargin < 5
        depth = 0;
    end
    if nargin < 6
        toprint = "";
    end
    
    if G == 'F' %Check if we were recursively passed an invalid graph
        catalog = {};
        return;
    end
    if ~any(G(:)<0)
        if ~hasTTk(G, k)
            catalog = {digraph(G)};
            return;
        else
            catalog = {};
            return;
        end
    end
    tempind = 0;
    tempres = [];
    while(isempty(tempres))
        tempind = tempind + 1;
        tempres = find(G(1:tempind, 1:tempind)<0, 1);
    end
    [j, i] = find(G(1:tempind, 1:tempind)<0, 1);
    %Naturally looks for low col, then row; I want to flip this
    %which is fine because -1's are symmetric
    if j > norig
        temp = colcats{j - norig};
        catalog = {};
        if i <= size(temp{1}, 1)
            oldG = G;
            for q = 1:size(temp, 2)
                G = oldG; %Reset in case of fail
                G(1:size(temp{q}, 1), j) = temp{q};
                G(j, 1:size(temp{q}, 1)) = ones(size(temp{q}')) - temp{q}';
                G = propagate(G, k, j);
                if G(1, 1) == 'F' || hasTTk(G, k)
                    continue;
                end
                catalog = [catalog, bruteForceColumns(G, k, norig, colcats)];
            end
            return;
        end
    end
    %Only goes off if the column-filler code above doesn't happen
    G(i, j) = 0; G(j, i) = 1; G0 = propagate(G, k, i);
    G(i, j) = 1; G(j, i) = 0; G1 = propagate(G, k, i);
    %Recursively call bruteForceColumns and log current progress
    catalog = [bruteForceColumns(G0, k, norig, colcats), ...
        bruteForceColumns(G1, k, norig, colcats)];
end