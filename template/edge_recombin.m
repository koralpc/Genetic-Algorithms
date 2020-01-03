% Low-level Edge Recombination Xover function for calculating an offspring

function offspring = edge_recombin(Parents)
	cols=size(Parents,2);
    Parents(1,:) = adj2path(Parents(1,:));
    Parents(2,:) = adj2path(Parents(2,:));
    
    % Generate list of all neighbors from Parent1
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
    
    % Append neighbors to the list from Parent2
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
    
    % Remove neighbor duplicates
    for i = 1:size(neighbor_list)
        nn = neighbor_list(i,:);
        unique_neighbors = zeros(size(nn));
        [~,j] = unique(nn,'first');
        unique_neighbors(j) = nn(j);
        neighbor_list(i,:) = unique_neighbors;
    end
    
    % Generate offspring
    x = Parents(randi(2),1);
    %offspring = [x];
    offspring = [x];
    lin = linspace(1,cols,cols);
    while size(offspring,2) < cols
        %offspring = [offspring,x];
        [~,idx] = find(Parents(1,:) == x);
        neighbor_list(neighbor_list == x) = 0;
        if isequal(neighbor_list(idx,:),[0,0,0,0])
            lin = setdiff(lin,offspring);
            z = lin(randi(size(lin,2)));
        else
            neighbor_counts = [];
            x_neighbors = neighbor_list(idx,:);
            %for k = 1:size(find(neighbor_list(i,:)),2)
            for k = 1:size(neighbor_list(i,:),2)
                if x_neighbors(k) ~= 0
                    neighbor_counts = [neighbor_counts,size(find(neighbor_list(find(Parents(1,:)==x_neighbors(k)),:)),2)];
                else
                    neighbor_counts = [neighbor_counts,-1];
                end
            end
            min_nb_cnt = min(neighbor_counts(neighbor_counts > -1));
            [~,min_nb_cnt_idx] = find(neighbor_counts == min_nb_cnt);
            chosen_nb_idx = randi(size(min_nb_cnt_idx,2));
            z = x_neighbors(min_nb_cnt_idx(chosen_nb_idx));
        end
        x = z;
        offspring = [offspring,x];
    end    
    %offspring
    offspring = path2adj(offspring);
end
