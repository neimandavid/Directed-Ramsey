load('T27TT6.mat')
M = M(1:26, 1:26); %Original M is ST27, cut it down to ST26

%Get ST12, ST13
catout = {};
for i = 1:size(M, 1)
   u = M(i, :) == 0;
   u(i) = 0;
   v = M(i, :) == 1;
   catout = [catout, {digraph(M(u, u))}, {digraph(M(v, v))}];
end
catout = stripIsomorphicCopies(catout);
T12 = full(adjacency(catout{1}));
T13 = full(adjacency(catout{2}));

% Brute-force valid ways to glue these as 12->1->13
T = -ones(26, 26);
T(2:14, 2:14) = T13;
T(15:26, 15:26) = T12;
T(1, 1) = 0;
T(2:14, 1) = 0;
T(15:26, 1) = 1;
T(1, 2:14) = 1;
T(1, 15:26) = 0;

%Generate the column catalog by hand to take advantage of our knowledge
%about connections between the 12 and 13 tournament
%Also, the column options don't depend on the column, since I don't use
%any part of the lower-right matrix except the 0 on the main diagonal, so
%I only need to compute a catalog for a single column and copy it over
i = 1;
v = [1:14, 14+i];
tempcat = bruteForceEdges(T(v, v), 6);
colcat = {};
for j = 1:size(tempcat, 2)
    Mtemp = full(adjacency(tempcat{j}));
    v = inneighbors(Mtemp, 15);
    if size(v, 2) == 7 && isequal(sort(sum(Mtemp(v, v))), [2,2,2,3,4,4,4])
        colcat = [colcat, Mtemp(1:14, 15)];
    end
end
colcats = {};
for i = 1:12
    colcats = [colcats, {colcat}]; %13 of these
end
gluings12113 = bruteForceColumns(T, 6, 14, colcats);
%39 of these (for a fixed T12, T13, and single vertex)

%Now flip these to get gluings 13->1->12
gluings13112 = {};
D12 = digraph(T12);
D13 = digraph(T13);
for i = 1:size(gluings12113, 2)
    temp = gluings12113{i};
    temp = full(adjacency(temp))';
    %isomorphism tells you what to do to the second graph to get the first
    %one back, but apparently these are all just involutions anyway?
    u1 = 1+isomorphism(D13, digraph(temp(2:14, 2:14)));
    u2 = 14+isomorphism(D12, digraph(temp(15:26, 15:26)));
    v = [1, u1', u2'];
    temp = temp(v, v);
    gluings13112 = [gluings13112, {digraph(temp)}];
end

%We're now ready to start setting up 39x39s
T = -ones(39, 39) + eye(39);
%Fill in 0s and 1s
%A = outneighbors, B = other TT3s, C = inneighbors, D = cycles. u->v
%Upper left: 12 -> 1 -> 13 is C -> u -> B (with u first)
%Lower right: 13 -> 1 -> 12 is B -> v -> A (with v last)
%So overall order is uBCAv. Still need that u->A, B->v, u->v
T(1, 27:39) = 1; %u->A, u->v
T(27:39, 1) = 0;
T(2:13, 39) = 1; %B->v
T(39, 2:13) = 0;
cat39 = {};
oldoldT = T;
for i = 1:size(gluings12113, 2) %Loop over ways to fill the upper left
    T = oldoldT; %Reset (in case of fail or meaningful constraint propagation
    temp = full(adjacency(gluings12113{i}));
    %Sequence is 1 13 12; want to flip it to 1 12 13
    v = [1, 15:26, 2:14];
    temp = temp(v, v);
    T(1:26, 1:26) = temp;
    oldT = T;
    for j = 1:size(gluings13112, 2) %Loop over ways to fill the lower right
        colcats = {};
        T = oldT; %Reset (in case of fail or constraint propagation information)
        temp = full(adjacency(gluings13112{j}));
        %Sequence is 1 13 12; want to flip it to 13 12 1
        v = [2:14, 15:26, 1];
        temp = temp(v, v);
        T(14:39, 14:39) = temp;
        T = massPropagate(T, 7);
        if T(1, 1) == 'F'
            disp('Outright fail');
            disp(strcat("Finished case: (", num2str(i), ", ", num2str(j), ")"));
            continue; %Fail early if propagation says it's impossible
        end
        cat39 = [cat39, divideAndConquer(T, 7)];
        disp(strcat("Finished case: (", num2str(i), ", ", num2str(j), ")"));
    end
end
%Note: No 39-vertex TT7-free tournaments found, so no need to try to extend
%those to 53-vertex TT7-free