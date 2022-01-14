%This looks at subtournaments of ST27. After this, look at CommonSubtournament23s.m
clc
load('ST27.mat');

%To load the subtournaments of ST27
reference23s = [];
for i = 1:22
    temp = readmatrix(strcat('TT6-Free/23-Vertex/SubST27/Mat', num2str(i), '.txt'));
    reference23s = [reference23s, {digraph(temp)}];
end

%Verify I'm removing appropriate stuff
% cat24 = [];
% for ind = [3, 4, 7, 16, 19]
%     v = [3:ind-1, ind+1:27];
%     cat24 = [cat24, {digraph(M(v, v))}];
% end
% getIsomorphismClasses(cat24)

for ind = [4, 7, 16, 19, 14, 5, 6, 11, 8]
    testcat = [];
    
    %Figure out what fourth vertices we care to remove:
    %w (index 3), and outneighbors only (to avoid double-counting)
    %And don't remove the stuff we've already removed (1, 2, ind)
    inddvec = find(ST27(ind, :));
    inddvec = [3, inddvec(inddvec > 3)];
    for indd = inddvec
        v = 1:27;
        v([1, 2, ind, indd]) = [];
        M = ST27(v, v);
        testcat = [testcat, {digraph(M)}];
    end
    temp = getIsomorphismClasses([reference23s, testcat]);
    ind
    inddvec
    temp(23:end)
end

%To remove:
%WLOG u and v (1 and 2)
%Stuff that gives us all the 24s (3, 4, 7, 16, 19)
%NOTE: 3 is w

%This covers the following classes of 23s:
%1, 6, 13, 16; 2, 18; 2, 14; 3, 17
%Sorting: 1, 2, 3, 6, 13, 16, 17, 18
%Still need these classes: 4, 5, 7, 8, 9, 10, 11, 12, 14, 15, 19, 20, 21, 22
%Must remove 14 to get class 4.
%By removing 14 second, we get: 4
%By removing 14 first, we get: 3, 12, 2, 20

%Removed so far: (3, 4, 7, 14, 16, 19)
%Still need classes: 5, 8, 9, 10, 11, 12, 15, 21, 22

%Must remove 5 to get class 5.
%By removing 5 second, we get: 5, 7, 17
%By removing 5 first, we get: 1, 11, 14

%Removed so far: (3, 4, 5, 7, 14, 16, 19)
%Still need classes: 8, 9, 10, 12, 15, 21, 22

%To get 8, remove 8, 9, or 15
%To get 9, remove 10 or 12
%To get 10, remove 11 or 10
%To get 12, remove 8 or 11
%To get 15, remove 6

%Must remove 6 to get class 15
%Removing 6 second, we get: 15, 17, 7, 5
%Removing 6 first, we get: 1, 5, 8

%Removed so far: (3, 4, 5, 6, 7, 14, 16, 19)
%Still need classes: 9, 10, 12, 21, 22

%To get 9, remove 10, 11, or 12
%To get 10, remove 11 or 10
%To get 12, remove 8 or 11
%To get 21, remove 8, 26
%To get 22, remove 8, 27

%Let's remove 11
%Removing 11 second, we get: 10, 3, 12, 9
%Removing 11 first, we get: 2, 6, 8, 13

%Removed so far: (3, 4, 5, 6, 7, 11, 14, 16, 19)
%Still need classes: 21, 22

%Remove 8 to get 21 and 22
%Removing 8 second, we get: 12, 21, 22, 8, 6
%Removing 8 first, we get: 2, 7, 11, 11

%Removed so far: (3, 4, 5, 6, 7, 8, 11, 14, 16, 19)
%Final set removed: (1:8, 11, 14, 16, 19)
%Stuff that stays: (9, 10, 12, 13, 15, 17, 18, 20:27)
%That's a 15-vertex subtournament; that's not bad