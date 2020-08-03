%Given a list of columns containing recent changes, checks to see if those
%changes imply other values. If so, it adds those new changes to its stuff
%to check and repeats until it either can't make a graph or can't deduce
%any new values, returning either 'F' or the new graph.
function out = massPropagate(G, k, forceRegular)
    if G(1, 1) == 'F'
        %This generally shouldn't happen
        return;
    end
    n = size(G, 1);
    repeat = false;
    
    if nargin < 3
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
            if size(temp(temp == 0),2)>(n+1)/2||size(temp(temp == 1),2)>(n-1)/2
                out = 'F';
                return;
            end
        end
    end
    vs = nchoosek(1:n, k);
    for i = 1:size(vs, 1)
        v = vs(i, :);
        H = G(v, v);
        if isTransitive(H)
            out = 'F';
            return;
        end
        if nnz(H(:) < 0) == 2
            [b, a] = find(H == -1, 1);
            G(v(a), v(b)) = 0;
            G(v(b), v(a)) = 1;
            valid0 = ~isTransitive(G(v, v));
            G(v(a), v(b)) = 1;
            G(v(b), v(a)) = 0;
            valid1 = ~isTransitive(G(v, v));
            G(v(a), v(b)) = -1;
            G(v(b), v(a)) = -1;
            if ~valid0 && ~valid1
                out = 'F';
                return;
            end
            if valid0 && ~valid1
                G(v(a), v(b)) = 0;
                G(v(b), v(a)) = 1;
                repeat = true;
            end
            if valid1 && ~valid0
                G(v(a), v(b)) = 1;
                G(v(b), v(a)) = 0;
                repeat = true;
            end
        end
    end
    if repeat
        out = massPropagate(G, k, forceRegular);
    else
        out = G;
    end
end