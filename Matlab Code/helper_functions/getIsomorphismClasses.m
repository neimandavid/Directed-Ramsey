%Returns a vector of labels for the different isomorphism classes in
%catalog
%First isomorphism class found is 1, second is 2, etc.
%Works similarly to stripIsomorphicCopies, except that this labels future
%instances of isomorphism classes instead of deleting them
function classes = getIsomorphismClasses(catalog)
    nextClass = 1;
    classes = zeros(size(catalog));
    for i = 1:size(catalog, 2)
        if classes(i) > 0
            %Skip stuff with known isomorphism classes
            continue;
        end
        classes(i) = nextClass;
        nextClass = nextClass + 1;  
        for j = i+1:size(catalog, 2)
            if classes(j) > 0
                %Skip stuff with known isomorphism classes
                continue;
            end
            %Label anything in i's isomorphism class
            if isisomorphic(catalog{i}, catalog{j})
                classes(j) = classes(i);
            end
        end
    end
end