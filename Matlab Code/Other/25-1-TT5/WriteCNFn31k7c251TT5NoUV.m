% load('metacatalogtt4.mat')
% ST6 = full(adjacency(metacatalog{7}{1}));
load('T27TT6.mat')
ST27 = M;

n = 31; %Size of tournament
k = 7; %Size of transitive to avoid
p = 26; %Location of pivot
%Now set some edges
M = eye(n, n)-ones(n, n);
M(1:p-1, 1:p-1) = ST27(27-p+2:27, 27-p+2:27);
M(1:p-1, p) = 1; M(p, 1:p-1) = 0;
M(p+1:n, p) = 0; M(p, p+1:n) = 1;
M(p+1:n, p+1:n) = makeTTk(5);

%Use smaller Ramsey numbers for diagonal transitive autofill
% R = [1, 2, 4, 8, 14, 28];
% nfree = n-p;
% while nfree > 0
%     for i = k-1:-1:1
%         if nfree >= R(i)
%             v = n-nfree+1:n-nfree+i;
%             M(v, v) = makeTTk(i);
%             nfree = nfree - i;
%             break;
%         end
%     end
% end
M
'test';

fcat = {}; %Catalog of forbidden matrices. -1s for don't care. We requre that the output differ in one of the spots each matrix in fcat has a 0 or 1
extraclausecount = 0; %One per edge, plus two per new variable (one for iff, one for actually using it)
for i = 1:5
    %No u
    fmat = eye(n, n) - ones(n, n);
    fmat(1:19, p+i) = ST27(3:21, 1);
    fmat(p+i, 1:19) = ST27(1, 3:21);
    extraclausecount = extraclausecount + sum(fmat(:)==1) + 2;
    fcat = [fcat, {fmat}];
    %No v
    fmat = eye(n, n) - ones(n, n);
    fmat(1:19, p+i) = ST27(3:21, 2);
    fmat(p+i, 1:19) = ST27(2, 3:21);
    extraclausecount = extraclausecount + sum(fmat(:)==1) + 2;
    fcat = [fcat, {fmat}];
end

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

%Forbidden matrix labels
fcatvars = zeros(1, size(fcat, 2)); 
for i = 1:size(fcat, 2)
    nedges = nedges + 1;
    fcatvars(i) = nedges;
end

%Make CNF file
filename = strcat('CNF.nosync/', extractBetween(mfilename, 9, length(mfilename)), '.cnf');
myfile = fopen(filename{1}, 'wt');

%Header: p cnf #vars #clauses
nvars = nedges; %This stays since I kept incrementing nedges anyway
%nclauses = nchoosek(n, k)*factorial(k) + sum(M(:) == 1);
nclauses = nchoosek(n, k) + 8*nchoosek(n, 3) + sum(M(:) == 1) + extraclausecount;
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
            fprintf(myfile, '%i %i %i %i 0\n', N(j, i), N(jj, j), N(i, jj), P(i, j, jj));
            fprintf(myfile, '%i %i 0\n', N(j, i), -Q(i, j, jj));
            fprintf(myfile, '%i %i 0\n', N(jj, j), -Q(i, j, jj));
            fprintf(myfile, '%i %i 0\n', N(i, jj), -Q(i, j, jj));
            fprintf(myfile, '%i %i %i %i 0\n', N(i, j), N(j, jj), N(jj, i), Q(i, j, jj));
        end
    end
end

%Add TTk-free constraints
for v = nchoosek(1:n, k)' %Pick 7 vertices, hopefully increasing order???
    for w = nchoosek(v, 3)' %Loop over 3-cycles, hopefully increasing order???
        fprintf(myfile, '%i %i ', P(w(1), w(2), w(3)), Q(w(1), w(2), w(3)) );
    end
    fprintf(myfile, '0\n');
    v
end

%Add forbidden variable constraints
for h = 1:size(fcat, 2)
    fmat = fcat{h};
    %Define the variable
    iffclause = strcat(num2str(fcatvars(h)), " "); %Setting up: Either output matches the fcat matrix, or...
    for i = 1:n
        for j = 1:n
            if fmat(i, j) == 1 %Tournaments are anti-symmetric, so each edge shows up as a 1 somewhere. Not checking 0s prevents duplicate clauses
                fprintf(myfile, '%i %i 0\n', N(i, j), -fcatvars(h)); %Either the output has a 1 like fcat does, or the output differs from fcat
                iffclause = strcat(iffclause, num2str(-N(i, j)), " "); %If the output doesn't match fcat, there must be a difference. If the output doesn't have a 1 here, that's a difference.
            end
        end
    end
    iffclause = strcat(iffclause, '0\n');
    fprintf(myfile, iffclause);
    fprintf(myfile, '%i 0\n', -fcatvars(h)); %Require that the output matrix is different from the fcat matrix somewhere
end

fclose(myfile);
toc