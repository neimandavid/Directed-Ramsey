Files to run:
- AnalyzeTT7Free53.m (for non-existence of a TT7-free 53-vertex tournament)
- GetTT6Free24.m (for TT6-free 24-vertex tournaments of different structures; change the first line's vector to try different cases; to do 23-vertex cases, add one to the size of the D block to get a decomposition for a 24-vertex tournament, run this, and then run finish6465.m if anything's left to check, which only happens in the [6, 4, 6, 5] case)
- ReadDR23.m (to check for TT6-free 23-vertex doubly-regular tournaments)
- GetTT6Free23OneShot.m for particular cases of 23-vertex TT6-free tournaments. Then run the output file through CheckDuplicate23s to verify that all resulting tournaments are either doubly-regular or subtournaments of ST27. (Don't try [7, 3, 7, 4]; it'll take months.)
- WriteCNFc.mat to generate CNF files (NOTE: each author used slightly different encodings)
- 7374_CNF/WriteCNFn19k6c737.m makes n19k6c7374.cnf, corresponding to the 23-vertex [7, 3, 7, 4] case; the CNF should return UNSAT with Cadical in a few minutes

Possibly useful data:
- T27TT6.mat has ST27 (can truncate to get ST26 or ST25)
- metacatalogtt<k>.mat, where k is some number, is a catalog of small TTk-free tournaments. Each is a nested cell array, with a cell array containing the empty tournament as the first element, a cell array containing the 1-element tournament as the second element, and so on; the cell array of n-vertex tournaments are the n+1st element. For k<=5, the catalogs are complete; for k>=6, the larger tournaments are missing.
- drtourn23 is a catalog of 23-vertex doubly-regular tournaments downloaded from McKay's database (https://users.cecs.anu.edu.au/~bdm/data/digraphs.html)

Pretty much everything else in this folder should be helper functions
