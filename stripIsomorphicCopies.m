%Strips isomorphic copies of digraphs from catalog
%Each time it sees a new isomorphism class, it goes through and deletes all
%future instances of that isomorphism class (think Sieve of Eratosthenes)
function catalog = stripIsomorphicCopies(catalog)
    i = 1;
    while i <= size(catalog, 2)
        j = i+1;    
        while j <= size(catalog, 2)
            if isisomorphic(catalog{i}, catalog{j})
                catalog(j) = []; %Delete element
            else
                j = j + 1;
            end
        end
        i = i+1;
    end
end