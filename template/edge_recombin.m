% low level function for calculating an offspring
% given 2 parent in the Parents - agrument
% Parents is a matrix with 2 rows, each row
% represent the genocode of the parent
%
function offspring = edge_recombin(Parents)
	cols=size(Parents,2);
    %Parents(1,:) = adj2path(Parents(1,:));
    %Parents(2,:) = adj2path(Parents(2,:));
    neighbor_list = zeros(cols,4);
    
    for i = 1:cols
       if i == 1
           neighbor_list(i,1:2) = [Parents(1,i+1),Parents(1,cols)] ; 
       elseif i == cols
           neighbor_list(i,1:2) = [Parents(1,i-1),Parents(1,1)]  ;
       else
           neighbor_list(i,1:2) = [Parents(1,i+1),Parents(1,(i-1))];  
       end      
    end
    
   for i = 1:cols
       [ans,idx] = find(Parents(2,:) == i);
       if idx == 1
           neighbor_list(i,3:4) = [Parents(2,idx +1),Parents(2,cols)];  
       elseif idx == cols
           neighbor_list(i,3:4) = [Parents(2,idx -1),Parents(2,1)];  
       else
           neighbor_list(i,3:4) = [Parents(2,idx +1),Parents(2,idx-1)];  
       end      
    end 
    
    x = Parents(1,1);
    child = [];
    lin = linspace(1,cols,cols);
    while size(lin) > 0
        %child = [child,x];
        [ans,idx] = find(Parents(1,:) == x);
        neighbor_list(neighbor_list == x) = 0;
        if neighbor_list(idx,:) ~= [0,0,0,0]
            lin = lin(lin ~= x);
            rand_neighbor = lin(randi(size(lin,1)));
        else
            
        end
        x = rand_neighbor;
    end    
        %Create cutting points
        cp1 = 0;
        cp2 = 0;
        while cp1 == cp2
            cp1 = randi(cols,1); %Random number in the range of 0:cols
            cp2 = randi(cols,1);
        end

        if cp1 > cp2
            temp_cp1 = cp2;
            cp2 = cp1;
            cp1 = temp_cp1;
        end  

        %These are the sliced parts of the parents
        %Parent slice 1 is overwriting slice 2
        parent_slice1 = Parents(1,cp1:cp2);
        parent_slice2 = Parents(2,(~ismember(Parents(2,:),parent_slice1)));

        %Overwrite second parents slice
        offspring = [parent_slice2(1:cp1-1), parent_slice1, parent_slice2(cp1:end)];
        offspring = path2adj(offspring);
end
