% Path to Binary representation conversion function

function Binary = path2bin(Path,Bitstring_len)
    Binary = [];
    Path = Path - 1 ;
	for t=1:size(Path,2)
        Binary = [Binary,dec2bin(Path(t),Bitstring_len)];
	end

