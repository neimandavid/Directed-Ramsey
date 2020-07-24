%Goal: Find all vectors v with no 3-cycles (thus transitive)
function outlist = listTTks(T, k, v, outlist)
    if nargin < 3
        v = [];
    end
    if nargin < 4
        outlist = zeros(0, k);
    end
    if size(v, 2) == k
        outlist = [outlist; v];
    else
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
            if isgood
                outlist = listTTks(T, k, [v, i], outlist);
            end
        end
    end
end