% rankbased.m          (Rank Based Selection)
%
% This function performs selection with Rank Based Selection.
%
% Syntax:  NewChrIx = sus(FitnV, Nsel)
%
% Input parameters:
%    FitnV     - Column vector containing the fitness values of the
%                individuals in the population.
%    Nsel      - number of individuals to be selected
%
% Output parameters:
%    NewChrIx  - column vector containing the indexes of the selected
%                individuals relative to the original population, shuffled.
%                The new population, ready for mating, can be obtained
%                by calculating OldChrom(NewChrIx,:).


function NewChrIx = rankbased(FitnV,Nsel)

% Identify the population size (Nind)
   [Nind,ans] = size(FitnV);
   [FitnV,original_idx] = sort(FitnV);
   NewChrIx = zeros(Nsel,1);
   rankV = linspace(1,Nind,Nind);
   cumfit = cumsum(rankV);
   upper_lim = cumfit(Nind);
% Perform rank based selection
    for i = 1:Nsel
       rand_number = upper_lim * rand(1);
       selected_idx = find(cumfit > rand_number);
       selected_idx = selected_idx(1);
       NewChrIx(i) = original_idx(selected_idx);
    end

% Shuffle new population
   [ans, shuf] = sort(rand(Nsel, 1));
   NewChrIx = NewChrIx(shuf);


% End of function
