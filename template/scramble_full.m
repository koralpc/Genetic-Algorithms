function NewChrom = scramble_full(OldChrom,Representation)
% Scramble mutation affecting the entire chromosome

cols=size(OldChrom,2);

NewChrom=OldChrom;

if Representation==1 
	NewChrom=adj2path(NewChrom);
end

% select the two endpositions in the tour
chp1 = 1;
chp2 = cols;

subset = NewChrom(chp1:chp2);
subset = subset(randperm(length(subset)));
NewChrom(chp1:chp2) = subset;

if Representation==1
	NewChrom=path2adj(NewChrom);
end