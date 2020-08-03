%Strips identical copies of tournaments from catalog
%Works very similarly to stripIsomorphicCopies
function catalog = stripIdenticalCopies(catalog)
    i = 1;
    while i <= size(catalog, 2)
        j = i+1;    
        while j <= size(catalog, 2)
            if isequal(catalog{i}, catalog{j})
                catalog(j) = []; %Delete element
            else
                j = j + 1;
            end
        end
        i = i+1;
    end
end