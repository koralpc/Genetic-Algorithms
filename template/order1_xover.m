% Low-level OX function for calculating an offspring

function offspring = order1_xover(Parents)
	cols=size(Parents,2);
    Parents(1,:) = adj2path(Parents(1,:));
    Parents(2,:) = adj2path(Parents(2,:));
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
        

        % Additional step: Start reinsertion from the values at the right side of the sliced part

        % This reduces performance (bad results, slow conv) by quite a lot under any circumstances,
        % so it was omitted after some experimentation:
        
        % if cp2 ~= cols 
        %     parent_slice2 = circshift(parent_slice2, find(parent_slice2 == Parents(1,cp2+1))+1);
        % end
        
        %Overwrite second parents slice
        offspring = [parent_slice2(1:cp1-1), parent_slice1, parent_slice2(cp1:end)];
        offspring = path2adj(offspring);
end
