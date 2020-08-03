%Goal: Find a vector v of length k with no 3-cycles (thus transitive)
%If successful, return true (found a transitive), else fail
%Works like listTTks, but stops early on finding one
function [out, ttk] = hasTTk(T, k, v)
    if nargin < 3
        v = [];
    end
    if size(v, 2) == k
        out = true;
        ttk = v;
        return;
    else
        out = false;
        ttk = 'None';
        n = size(T, 1);
        %Assume (by induction) v is in increasing order
        %If too close to the end, there's no way to fill in
        %Fail condition: n-v(size(v)) < k - size(v)
        %(Intuitively, you'd need to pick more values than you have left)
        %Above happens iff v(size(v)) > n-k+size(v)
        %Means we need next element v(size(v)+1) <= n - k + (size(v) + 1)
        lb = 1;
        if size(v) > 0
            lb = v(size(v, 2))+1;
        end
        for i = lb:n-k+size(v, 2)+1 %Try all next elements
            %Check for 3-cycles involving the new element:
            isgood = true;
            for a = 1:size(v, 2)-1
                if ~isgood %End early if there's a 3-cycle
                    break;
                end
                for b = a+1:size(v, 2)
                    u = [v(a), v(b), i];
                    if ~isTransitive(T(u, u))
                        isgood = false;
                        break;
                    end
                end
            end
            [hasttk, ttk] = hasTTk(T, k, [v, i]);
            if isgood && hasttk
                out = hasttk;
                return;
            end
        end
        return; %Fail if nothing works
    end
end