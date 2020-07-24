%7374 (ran for regular, no tournaments (fails on ABC! Can verify with a SAT solver in about 10 minutes))
%6663 (found 11, all subtournaments of ST27)
%6654 (found 17, all subtournaments of ST27)
%6645 (found same 17 as 6654, still all subtournaments of ST27)
%6564 (found 20 (no 10 or 21).)
%6555 (found all 22 subtournaments)
%6465 (found 20 (no 9 or 22). Previously ran for regular but reran this version)
%5655 (found 20 (no 10 or 21). NOTE: Any non-DR tournament will get caught by an earlier case)
%5556 (only care about the three DR tournaments; by definition, anything else pops up in another category also)

load('myfile6564.mat'); %The file to be checked
load('ST27.mat');

% %To create the subtournaments of ST27:
% subtourncat = [];
% 
% nck = nchoosek(1:25, 2);
% for i = 1:size(nck, 1)
%     v = 3:27; v(nck(i, :)) = [];
%     temp23 = M(v, v);
%     subtourncat = [subtourncat, {digraph(temp23)}];
% end
% 
% %To save the subtournaments of ST27
% subtourncats = stripIsomorphicCopies(subtourncat);
% for i = 1:numel(subtourncats)
%     full(adjacency(subtourncats{i}))
%     strcat('23-Vertex TT6-Free Partial List/SubST27Correct/Mat', num2str(i), '.txt')
%     writematrix(full(adjacency(subtourncats{i})), strcat('23-Vertex TT6-Free Partial List/SubST27Correct/Mat', num2str(i), '.txt'), 'Delimiter', ' ');
% end
% getIsomorphismClasses([subtourncats, outcats])

%To load the subtournaments of ST27
testsubtourncat = [];

for i = 1:22
    temp = readmatrix(strcat('23-Vertex TT6-Free Partial List/SubST27/Mat', num2str(i), '.txt'));
    testsubtourncat = [testsubtourncat, {digraph(temp)}];
end
%getIsomorphismClasses(testsubtourncat) %Comes back with 1-22, as we'd expect

outclasses = getIsomorphismClasses([testsubtourncat, outcats]); %Check for stuff > 22; we know the first 22 are unique since they're our subtournament catalog
%outclasses = (outclasses(23:end))
outclasses = sort(outclasses(23:end))