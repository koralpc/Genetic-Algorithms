function NewChrom = scramble(OldChrom,Representation)

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

if chp1 > chp2
    temp_chp1 = chp2;
    chp2 = chp1;
    chp1 = temp_chp1;
end  

subset = NewChrom(chp1:chp2);
subset = subset(randperm(length(subset)));
NewChrom(chp1:chp2) = subset;

%NewChrom() = NewChrom(rndi(2):-1:rndi(1));
%buffer=NewChrom(rndi(1));
%NewChrom(rndi(1))=NewChrom(rndi(2));
%NewChrom(rndi(2))=buffer;

if Representation==1
	NewChrom=path2adj(NewChrom);
end