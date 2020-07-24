function catalog = bruteForceEdges(G, k, forceRegular)
    %G, k needed; other arguments optional
    %forceRegular tells propagation to also enforce regularity of G
    if nargin < 3
        forceRegular = false;
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
    
    [j, i] = find(G<0, 1);
    %Naturally looks for low col, then row; I want to flip this
    %which is fine because -1's are symmetric
    
    G(i, j) = 0; G(j, i) = 1; G0 = propagate(G, k, i, 1, forceRegular);
    G(i, j) = 1; G(j, i) = 0; G1 = propagate(G, k, i, 1, forceRegular);
    %Recursively call bruteForceEdges
    catalog = [bruteForceEdges(G0, k, forceRegular), ...
        bruteForceEdges(G1, k, forceRegular)];
end