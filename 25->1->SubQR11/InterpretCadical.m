n = 33;
p = 25;
filenamestart = strcat('CadicalOutput/', num2str(p), '->1->', num2str(n-p-1));
%filenamestart = strcat('CadicalOutput/24->1->', 'M6');
fullfilename = strcat(filenamestart, ' Cleaned.txt');

fileID = fopen(fullfilename);
A = fscanf(fileID, '%i');

load(strcat('CNF.nosync/n', num2str(n), 'k7Edges.mat'));
N
M = zeros(size(N));
for i = 1:size(N, 1)
    for j = 1:size(N, 2)
        if N(i, j) > 0
            M(i, j) = A(N(i, j)) > 0;
        end
        if N(i, j) < 0
            M(i, j) = A(-N(i, j)) < 0;
        end
    end
end
M
if ~hasTTk(M, 7)
    writematrix(M, strcat(filenamestart, ' TT7Free.txt'), 'Delimiter', ' ');
    'Yay, no TT7!'
else
    'Something went wrong, found a TT7'
end