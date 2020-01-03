% low level interchange function for TSP mutation
% reciprocal exchange : two random cities in a tour are swapped
% Representation is an integer specifying which encoding is used
%	1 : adjacency representation
%	2 : path representation
%

function NewChrom = interchange(OldChrom,Representation)

cols=size(OldChrom,2);

NewChrom=OldChrom;

if Representation==1 
	NewChrom=adj2path(NewChrom);
end

% select two positions in the tour
chp1 = 0;
chp2 = 0;
while chp1 == chp2
    chp1 = randi(cols,1); %Random number in the range of 0:cols
    chp2 = randi(cols,1);
end

TempChrom = NewChrom(chp1);
NewChrom(chp1) = NewChrom(chp2);
NewChrom(chp2) = TempChrom;

if Representation==1
	NewChrom=path2adj(NewChrom);
end