Files to run:
- AnalyzeTT7Free53.m
- GetTT6Free24.m (change the first line's vector to try different cases)

Possibly useful data:
- T27TT6.mat has ST27 (can truncate to get ST26 or ST25)
- metacatalogtt<k>.mat, where k is some number, is a catalog of TTk-free tournaments. Each is a nested cell array, with a cell array containing the empty tournament as the first element, a cell array containing the 1-element tournament as the second element, and so on; the cell array of n-vertex tournaments are the n+1st element. For k<=5, the catalogs are complete; for k>=6, some sizes are missing.

Pretty much everything else should be helper functions
