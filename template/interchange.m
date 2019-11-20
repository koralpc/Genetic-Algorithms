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
%NewChrom() = NewChrom(rndi(2):-1:rndi(1));
%buffer=NewChrom(rndi(1));
%NewChrom(rndi(1))=NewChrom(rndi(2));
%NewChrom(rndi(2))=buffer;

if Representation==1
	NewChrom=path2adj(NewChrom);
end