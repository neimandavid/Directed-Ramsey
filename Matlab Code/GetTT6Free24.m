%Checks a particular set of block sizes for 23-vertex TT6-free tournaments
%Change the variable v to try different cases; it should sum to 22

addpath('helper_functions')
addpath('data')

v = [6, 6, 6, 4]; %Change this vector to whatever case you want to run
outcats = runCase(v); %Call a helper function to run this case

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