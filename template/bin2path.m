% Binary to Path representation conversion function

function Path = bin2path(Binary,Bitstring_length)	
	Path=zeros(1,size(Binary,2)/Bitstring_length);
	for t=1:size(Path,2)
		Path(t)= 1 + bin2dec(Binary((t-1)*Bitstring_length + 1:t*Bitstring_length));
	end