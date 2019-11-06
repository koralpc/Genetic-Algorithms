%%% Select - Tournament Selection

function NewChrIx = tournament(FitnV,Nsel);
   % Identify the population size (Nind)
   [Nind,ans] = size(FitnV);
    
    k = round(Nind / 10); %%Can be also added to gui for better testing
    NewChrIx = zeros(Nsel,1);
    
    for i = 1:Nsel
        indexes = randi(Nind,k,1);
        [best_fitness_el,ans] = max(FitnV(indexes));
        best_idx = find(FitnV == best_fitness_el);
        NewChrIx(i) = best_idx(1);
    end
end