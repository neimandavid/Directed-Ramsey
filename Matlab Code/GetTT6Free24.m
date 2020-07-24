v = [6, 6, 6, 4]; %Change this vector to whatever case you want to run
outcats = runCase(v);

%Check isomorphism classes against stuff that extends to the 27.

%Concatenate the output catalog with the 5 isomorphism classes of
%subtournaments of ST27
load('T27TT6.mat'); %Get the ST27 (permuted nicely)
knownoutcat = {};
for i = 3:27
   v = [3:i-1, i+1:27];
   T = M(v, v);
   knownoutcat = [knownoutcat, {digraph(T)}];
end
knownoutcats = stripIsomorphicCopies(knownoutcat);

%Get a list of the isomorphism classes. There should only be 5 unique
%numbers here, each appearing twice.
getIsomorphismClasses([knownoutcats, outcats])