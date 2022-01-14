load('ST27.mat');
v = [9, 10, 12, 13, 15, 17, 18, 20:27]; %See AnalyzeTT6Free23Subtournaments for how I picked this
v = [9, 10, 12, 13, 15, 17, 20, 23, 25]; %See AnalyzeTT6Free23Subtournaments for how I picked this
testsubtourn = digraph(ST27(v, v)); %15-vertex common subtournament of all subtournaments of ST27 (I hope)

DRtourns = cell(1, 25);
for i = 1:3
    DRtourns(i) = {readmatrix(strcat('../../TT6-Free/23-Vertex/Doubly-Regular/23', char('W'+i-1), '.txt'))};
end
for i = 1:22
    DRtourns(i+3) = {readmatrix(strcat('../../TT6-Free/23-Vertex/SubST27/23', char('A'+i-1), '.txt'))};
end

subsets = nchoosek(1:23, numel(v));
subtourncat = cell(1, 3);
success = zeros(1, 3);
for i = 1:numel(DRtourns)
    cat = {};
    T = DRtourns{i};
    for j = 1:size(subsets, 1)
        disp(strcat("i = ", num2str(i), " of ", num2str(numel(DRtourns)), "; j = ", num2str(j), " of ", num2str(size(subsets, 1))));
        if isisomorphic(testsubtourn, digraph(T(subsets(j, :), subsets(j, :))) )
            success(i) = 1; %Found a matching subtournament
            break;
        end
    end
    if success(i) == 0
        'Failed'
        break;
    end
end
success %Hope it's all ones


% Y9 = readmatrix('TT6-Free/23-Vertex/Subtourn.txt');
% %Hand-copied from paper; couldn't find code that generated these
% Y7 = [0 0 1 1 1 1 1; 1 0 0 0 1 1 1; 0 1 0 1 0 1 1; 0 1 0 0 1 0 1; 0 0 1 0 0 1 0; 0 0 0 1 0 0 1; 0 0 0 0 1 0 0];
% Y8 = [0 0 1 1 1 1 1 1 ; 1 0 0 0 1 0 1 1 ; 0 1 0 0 1 1 0 1; 0 1 1 0 0 1 1 0; 0 0 0 1 0 1 0 1; 0 1 0 0 0 0 1 1 ; 0 0 1 0 1 0 0 0; 0 0 0 1 0 0 1 0 ];

%isSubtournament(Y9, successes{1})