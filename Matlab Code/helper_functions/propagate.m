%Given a list of columns containing recent changes, checks to see if those
%changes imply other values. If so, it adds those new changes to its stuff
%to check and repeats until it either can't make a graph or can't deduce
%any new values, returning either 'F' or the new graph.
function out = propagate(G, k, tocheck, index, forceRegular)
    %Need G, k; other arguments optional
    %tocheck: List of columns to be checked. Defaults to everything
    %index: First index to check. Plug in 1, gets updated during recursion
    %forceRegular: If true, also enforces regularity of G
    n = size(G, 1);
    %Deal with missing arguments
    %If no 3rd argument, check everything (and use the more efficient function)
    if nargin < 3
        out = massPropagate(G, k);
        return;
    end
    if nargin < 4
        index = 1;
    end
    if nargin < 5
        forceRegular = false;
    end
    if forceRegular
        if mod(n, 2) == 0
            out = 'F';
            return;
        end
        for i = 1:n
            temp = G(i, :);
            if size(temp(temp == 0), 2) == (n+1)/2
                for j = 1:n
                    if G(i, j) == -1
                        G(i, j) = 1;
                        G(j, i) = 0;
                    end
                end
                if hasTTk(G, k)
                    out = 'F';
                    return;
                end
            end
            if size(temp(temp == 1), 2) == (n-1)/2
                for j = 1:n
                    if G(i, j) == -1
                        G(i, j) = 0;
                        G(j, i) = 1;
                    end
                end
                if hasTTk(G, k)
                    out = 'F';
                    return;
                end
            end
            if size(temp(temp==0),2)>(n+1)/2||size(temp(temp==1),2)>(n-1)/2
                out = 'F';
                return;
            end
        end
    end
    while index <= size(tocheck)
        x = tocheck(index);
        t = [1:x-1, x+1:n];
        temp = nchoosek(t, k-1);
        for uind = 1:size(temp, 1)
            u = temp(uind, :);
            v = [u, x];
            H = G(v, v);
            if isTransitive(H)
                out = 'F';
                return;
            end
            if nnz(H(:) < 0) == 2
                [i, j] = find(H<0, 1);
                G(v(i), v(j)) = 0;
                G(v(j), v(i)) = 1;
                valid0 = ~isTransitive(G(v, v));
                G(v(i), v(j)) = 1;
                G(v(j), v(i)) = 0;
                valid1 = ~isTransitive(G(v, v));
                G(v(i), v(j)) = -1;
                G(v(j), v(i)) = -1;
                if ~valid0 && ~valid1
                    out = 'F';
                    return;
                end
                if valid0 && ~valid1
                    G(v(i), v(j)) = 0;
                    G(v(j), v(i)) = 1;
                    tocheck = [tocheck(index:size(tocheck)), i];
                    %i fails iff j fails, don't need to add both
                    index = 1;
                end
                if valid1 && ~valid0
                    G(v(i), v(j)) = 1;
                    G(v(j), v(i)) = 0;
                    tocheck = [tocheck(index:size(tocheck)), i];
                    index = 1;
                end
            end
        end
        index = index + 1;
    %out = G;
    end
    out = G;
end