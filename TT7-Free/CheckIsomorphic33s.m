mkdir txtfolder
filenames = dir(fullfile(pwd, 'sol-*'))
for i = 1:numel(filenames)
    filename = filenames(i).name
    copyfile(filename, strcat('txtfolder/', filename, '.txt'))
end

filenames = dir(fullfile(strcat(pwd,'/txtfolder'), '*.txt'))
matcat = []
for i = 1:numel(filenames)
    filename = strcat(pwd,'/txtfolder/',filenames(i).name)
    matcat = [matcat, {digraph(readmatrix(filename))}]
end
matcat = stripIsomorphicCopies(matcat)

%Matcat to txtdump
mkdir catdump
for i = 1:numel(matcat)
    writematrix(adjacency(matcat{i}), strcat('catdump/sol', num2str(i), '.txt'), 'Delimiter', ' ')
end