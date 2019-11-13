% low level function for calculating an offspring
% given 2 parent in the Parents - agrument
% Parents is a matrix with 2 rows, each row
% represent the genocode of the parent
%
%

function offspring = partially_mapped_crossover(Parents)
	cols=size(Parents,2);
    
    Parents(1,:) = adj2path(Parents(1,:));
    Parents(2,:) = adj2path(Parents(2,:));
    
    %Create cutting points
    cp1 = 0;
    cp2 = 0;
    while cp1 == cp2
        cp1 = randi(cols+1,1)-1; %Random number in the range of 0:cols
        cp2 = randi(cols+1,1)-1;
    end
    
    if cp1 > cp2
        temp_cp1 = cp2;
        cp2 = cp1;
        cp1 = temp_cp1;
    end  
    
    %These are the sliced parts of the parents
    %Parent slice 1 is overwriting slice 2
    parent_slice1 = Parents(1,cp1+1:cp2);
    parent_slice2 = Parents(2,cp1+1:cp2);
       
    %Overwrite second parents slice
    offspring = [Parents(2,1:cp1) , parent_slice1, Parents(2,cp2+1:end)];
    count = 0;
    while size(unique(offspring,'stable'),2) ~= size(offspring,2)
        for i = 1:cp1
            overlap_idx = find(parent_slice1 == offspring(i));
            [ans,valid] = size(overlap_idx);
            if valid > 0
                offspring(i) = parent_slice2(overlap_idx(1));
            end
        end
        for i = cp2+1:cols
            overlap_idx = find(parent_slice1 == offspring(i));
            [ans,valid] = size(overlap_idx);
            if valid > 0
                offspring(i) = parent_slice2(overlap_idx(1));
            end
        end
        offspring;
        count = count + 1;
    end
    offspring = path2adj(offspring);
end
