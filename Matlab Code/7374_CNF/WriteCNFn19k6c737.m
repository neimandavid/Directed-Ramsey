load('metacatalogtt4.mat')
ST7 = full(adjacency(metacatalog{8}{1}));
generic3 = [0, 1, -1; 0, 0, 1; -1, 0, 0]; %Completes to either C3 or TT3

n = 19; k = 6;
%Now set some edges
M = eye(n, n)-ones(n, n);

M(1, :) = [0, 1, ones(1, 10), zeros(1, 7)];
M(2:end, 1) = 1-M(1, 2:end)';

M(2, 3:end) = [ones(1, 7), zeros(1, 10)];
M(3:end, 2) = 1-M(2, 3:end)';
M(3:9, 3:9) = ST7;
M(10:12, 10:12) = generic3;
M(13:19, 13:19) = ST7;
M
'test';
%End set edges

tic
%Save edge label matrix
filename = strcat('CNF.nosync/n', num2str(n), 'k', num2str(k), 'Edges');
myfile = fopen(strcat(filename, '.txt'), 'wt');

%Build matrix of edge labels
N = zeros(n, n);
nedges = 0;
for i = 1:n
    for j = i+1:n
        nedges = nedges + 1;
        N(i, j) = nedges; N(j, i) = -nedges;
    end
    fprintf(myfile, '%i\t', N(i, :));
    fprintf(myfile, '\n');
end
fclose(myfile); %Close edge label matrix file
save(filename, 'N')
toc

%Build matrices of cycle labels
P = zeros(n, n, n); Q = P;
for i = 1:n
    for j = i+1:n
        for jj = j+1:n %Overloaded k...
            nedges = nedges + 1;
            P(i, j, jj) = nedges;
            nedges = nedges + 1;
            Q(i, j, jj) = nedges;
        end
    end
end

%Make CNF file
temp = extractBetween(mfilename, 9, length(mfilename));
filename = strcat('CNF.nosync/', temp{1}, '.cnf');
myfile = fopen(filename, 'Wt');

%Header: p cnf #vars #clauses
nvars = nedges; %This stays since I kept incrementing nedges anyway
%nclauses = nchoosek(n, k)*factorial(k) + sum(M(:) == 1);
nclauses = nchoosek(n, k) + 6*nchoosek(n, 3) + sum(M(:) == 1);
fprintf(myfile, 'p cnf %i %i\n', nvars, nclauses);

%Add known edges
for i = 1:n
    for j = 1:n
        if M(i, j) == 1
            fprintf(myfile, '%i 0\n', N(i, j));
        end
    end
end

%Add cycle variables
for i = 1:n
    for j = i+1:n
        for jj = j+1:n
            fprintf(myfile, '%i %i 0\n', N(i, j), -P(i, j, jj));
            fprintf(myfile, '%i %i 0\n', N(j, jj), -P(i, j, jj));
            fprintf(myfile, '%i %i 0\n', N(jj, i), -P(i, j, jj));
            fprintf(myfile, '%i %i 0\n', N(j, i), -Q(i, j, jj));
            fprintf(myfile, '%i %i 0\n', N(jj, j), -Q(i, j, jj));
            fprintf(myfile, '%i %i 0\n', N(i, jj), -Q(i, j, jj));
        end
    end
end

%Add TTk-free constraints
for v = nchoosek(1:n, k)' %Pick 7 vertices, hopefully increasing order???
    for w = nchoosek(v, 3)' %Loop over 3-cycles, hopefully increasing order???
        fprintf(myfile, '%i %i ', P(w(1), w(2), w(3)), Q(w(1), w(2), w(3)) );
    end
    fprintf(myfile, '0\n');
end

fclose(myfile);
toc