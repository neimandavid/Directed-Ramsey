%Idea: Divide-and-conquer. Take indices of unknowns, solve first half, if
%nonempty solve second half and merge
function outcat = divideAndConquer(T, k, inds)
    %T, k needed; other arguments optional
    %inds: Indices of unknown entries to brute-force over. Used in recursion
    if nargin < 3
        inds = find(triu(T == -1)); %Find -1s
    end
    outcat = {};
    oldT = T;
    
    %Edge case (if given a tournament with no unknowns)
    if size(inds, 1) == 0
        outcat = {T};
        return;
    end
    
    %Base case
    if size(inds) == 1
        %Only one index to play with, try both cases
        [i, j] = ind2sub(size(T), inds);
        
        %Try T(i, j) = 0
        T(i, j) = 0; T(j, i) = 1; T = propagate(T, k, i);
        if T(1, 1) ~= 'F'
            outcat = [outcat, {T}];
        end
        
        %Try T(i, j) = 1
        T = oldT; %Replace with old T in case first case failed
        T(i, j) = 1; T(j, i) = 0; T = propagate(T, k, i);
        if T(1, 1) ~= 'F'
            outcat = [outcat, {T}];
        end
    
    %Inductive step
    else
        %Recursively get partial solutions
        cat1 = divideAndConquer(T, k, inds(1:floor(size(inds)/2)));
        if size(cat1, 2) == 0
            %If no way to solve part 1, fail (return empty catalog)
            return;
        end
        cat2 = divideAndConquer(T, k, inds(floor(size(inds)/2)+1:size(inds)));
        
        %Combine each pair of partial solutions, keep good ones
        for i = 1:size(cat1, 2)
            for j = 1:size(cat2, 2)
                T1 = cat1{i};
                T2 = cat2{j};
                %Check solution compatibility, fail if they disagree
                if any(T1(T1 ~= -1 & T2 ~= -1) ~= T2(T1 ~= -1 & T2 ~= -1))
                    continue;
                end
                T1(T2 ~= -1) = T2(T2 ~= -1); %Combine this pair of solutions
                T1 = massPropagate(T1, k);
                if T1(1, 1) ~= 'F'
                    outcat = [outcat, {digraph(T1)  }];
                end
            end
        end
        
    end
    disp(size(inds, 1))
end