
function Binary = path2bin(Path,Bitstring_len)
    %Bitstring_len = ceil(log2(size(Path,2)));
	%Binary=zeros(1,size(Path,2));
    Binary = [];
    Path = Path - 1 ;
	for t=1:size(Path,2)
		%Binary(t)=dec2bin(Path(t),Bitstring_len);
        Binary = [Binary,dec2bin(Path(t),Bitstring_len)];
	end

