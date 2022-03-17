TT5 = [0 1 1 1 1; 0 0 1 1 1; 0 0 0 1 1; 0 0 0 0 1; 0 0 0 0 0];
H5 = [0 1 1 1 1; 0 0 1 1 1; 0 0 0 1 0; 0 0 0 0 1; 0 0 1 0 0];

nsuccesses = 0
successes = []

%Adapted from: https://www.mathworks.com/matlabcentral/answers/29837-processing-files-using-a-for-loop
myDir = '../../TT5-Free/10-Vertex/'; %Change 10 to 11, 12, or 13 to check other sizes
myFiles = dir(fullfile(myDir,'*.txt'));
%Note: This is lexicographic ordering. Mat300.txt comes before Mat99.txt
for k = 1:length(myFiles)
    baseFileName = myFiles(k).name;
    fullFileName = fullfile(myDir, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    M = readmatrix(strcat(fullFileName));
    if(~isSubtournament(H5, M))
        nsuccesses = nsuccesses+1;
        successes = [successes, {M}];
    end
    nsuccesses
end
%So there's a single TT5-free H5-free tournament on each of 10 and 11
%vertices (QR_11 and its subtournament)

M = successes{1};
writematrix(M, 'H5Free.txt', 'Delimiter', ' ')
%v = [6, 2, 3, 4, 9, 10, 1, 5, 7, 8]; M(v, v)
v = [6, 2, 3, 4, 9, 10]; M(v, v) %Grab a subtournament consisting of one vertex and its 5 outneighbors. Built v by hand
writematrix(M(v, v), 'SubH5Free.txt', 'Delimiter', ' ')
isSubtournament(M(v, v), M) %Make sure I really did grab a subtournament
return;

%Verify that QR_{11} is indeed TT5-free and H5-free
% qr11 = [0, 1, 0, 1, 1, 1, 0, 0, 0, 1, 0];
% QR11 = zeros(11, 11);
% for i = 0:10
%     QR11(i+1, :) = circshift(qr11, i);
% end
% QR11 = makeQR(11)
% 
% isSubtournament(TT5, QR11)
% isSubtournament(H5, QR11)

function QR = makeQR(n)
    qr = zeros(1, n);
    for i = 1:n-1
        if mod(i^2, n) > 0
            qr( mod(i^2, n) + 1) = 1;
        end
    end
    QR = zeros(n, n);
    for i = 0:n-1
        QR(i+1, :) = circshift(qr, i);
    end
end