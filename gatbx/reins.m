% REINS.M        (RE-INSertion of offspring in population replacing parents)
%
% This function reinserts offspring in the population.
%
% Syntax: [Chrom, ObjVCh] = reins(Chrom, SelCh, SUBPOP, InsOpt, ObjVCh, ObjVSel)
%
% Input parameters:
%    Chrom     - Matrix containing the individuals (parents) of the current
%                population. Each row corresponds to one individual.
%    SelCh     - Matrix containing the offspring of the current
%                population. Each row corresponds to one individual.
%    SUBPOP    - (optional) Number of subpopulations
%                if omitted or NaN, 1 subpopulation is assumed
%    InsOpt    - (optional) Vector containing the insertion method parameters
%                ExOpt(1): Select - number indicating kind of insertion
%                          0 - uniform insertion
%                          1 - fitness-based insertion
%                          if omitted or NaN, 0 is assumed
%                ExOpt(2): INSR - Rate of offspring to be inserted per
%                          subpopulation (% of subpopulation)
%                          if omitted or NaN, 1.0 (100%) is assumed
%    ObjVCh    - (optional) Column vector containing the objective values
%                of the individuals (parents - Chrom) in the current 
%                population, needed for fitness-based insertion
%                saves recalculation of objective values for population
%    ObjVSel   - (optional) Column vector containing the objective values
%                of the offspring (SelCh) in the current population, needed for
%                partial insertion of offspring,
%                saves recalculation of objective values for population
%
% Output parameters:
%    Chrom     - Matrix containing the individuals of the current
%                population after reinsertion.
%    ObjVCh    - if ObjVCh and ObjVSel are input parameter, than column 
%                vector containing the objective values of the individuals
%                of the current generation after reinsertion.
           
% Author:     Hartmut Pohlheim
% History:    10.03.94     file created
%             19.03.94     parameter checking improved

function [Chrom, ObjVCh] = reins(Chrom, SelCh, SUBPOP, InsOpt, ObjVCh, ObjVSel);


% Check parameter consistency
   if nargin < 2, error('Not enough input parameter'); end
   if (nargout == 2 & nargin < 6), error('Input parameter missing: ObjVCh and/or ObjVSel'); end

   [NindP, NvarP] = size(Chrom);
   [NindO, NvarO] = size(SelCh);

   if nargin == 2, SUBPOP = 1; end
   if nargin > 2,
      if isempty(SUBPOP), SUBPOP = 1;
      elseif isnan(SUBPOP), SUBPOP = 1;
      elseif length(SUBPOP) ~= 1, error('SUBPOP must be a scalar'); end
   end

   if (NindP/SUBPOP) ~= fix(NindP/SUBPOP), error('Chrom and SUBPOP disagree'); end
   if (NindO/SUBPOP) ~= fix(NindO/SUBPOP), error('SelCh and SUBPOP disagree'); end
   NIND = NindP/SUBPOP;  % Compute number of individuals per subpopulation
   NSEL = NindO/SUBPOP;  % Compute number of offspring per subpopulation

   IsObjVCh = 0; IsObjVSel = 0;
   if nargin > 4, 
      [mO, nO] = size(ObjVCh);
      if nO ~= 1, error('ObjVCh must be a column vector'); end
      if NindP ~= mO, error('Chrom and ObjVCh disagree'); end
      IsObjVCh = 1;
   end
   if nargin > 5, 
      [mO, nO] = size(ObjVSel);
      if nO ~= 1, error('ObjVSel must be a column vector'); end
      if NindO ~= mO, error('SelCh and ObjVSel disagree'); end
      IsObjVSel = 1;
   end
       
   if nargin < 4, INSR = 1.0; Select = 0; end   
   if nargin >= 4,
      if isempty(InsOpt), INSR = 1.0; Select = 0;   
      elseif isnan(InsOpt), INSR = 1.0; Select = 0;   
      else
         INSR = NaN; Select = NaN;
         if (length(InsOpt) > 2), error('Parameter InsOpt too long'); end
         if (length(InsOpt) >= 1), Select = InsOpt(1); end
         if (length(InsOpt) >= 2), INSR = InsOpt(2); end
         if isnan(Select), Select = 0; end
         if isnan(INSR), INSR =1.0; end
      end
   end
   
   if (INSR < 0 | INSR > 1), error('Parameter for insertion rate must be a scalar in [0, 1]'); end
   if (INSR < 1 & IsObjVSel ~= 1), error('For selection of offspring ObjVSel is needed'); end 
   if (Select ~= 0 & Select ~= 1 & Select ~= 2 & Select ~= 3), error('Parameter for selection method must be 0 or 1'); end
   if (Select == 1 & IsObjVCh == 0), error('ObjVCh for fitness-based exchange needed'); end

   if INSR == 0, return; end
   NIns = min(max(floor(INSR*NSEL+.5),1),NIND);   % Number of offspring to insert   

% perform insertion for each subpopulation
   for irun = 1:SUBPOP,
      % Calculate positions in old subpopulation, where offspring are inserted
         if Select == 1    % fitness-based reinsertion
            [Dummy, ChIx] = sort(-ObjVCh((irun-1)*NIND+1:irun*NIND));
            
         elseif Select == 2 % Mu + Lambda Selection
             ObjT = [ObjVCh;ObjVSel];
             [ObjT,Objidx] = sort(ObjT);
             selected_idx = Objidx(1:NIND);
             selected_parent = selected_idx(selected_idx <= NIND);
             selected_child = selected_idx(selected_idx > NIND) - NIND;
             
             Chrom = [Chrom(selected_parent,:) ; SelCh(selected_child,:)];
             ObjVCh = [ObjVCh(selected_parent) ; ObjVSel(selected_child)];
             return
             
         elseif Select == 3 % Round-Robin Tournament Selection
             ObjT = [ObjVCh;ObjVSel];
             Total_participants = size(ObjT,1);
             Win_count = zeros(1,Total_participants); 
             for i = 1:length(ObjT)
                 participant_array = randi(Total_participants,10,1);
                 Win_count(i) = length(find(ObjT(i) > ObjT(participant_array)));
             end
             [Winners,Winneridx] = sort(Win_count);
             
             selected_idx = Winneridx(1:NIND);
             
             selected_parent = selected_idx(selected_idx <= NIND);
             selected_child = selected_idx(selected_idx > NIND) - NIND;
             
             Chrom = [Chrom(selected_parent,:) ; SelCh(selected_child,:)];
             ObjVCh = [ObjVCh(selected_parent) ; ObjVSel(selected_child)];
             return
         else               % Uniform reinsertion
            [Dummy, ChIx] = sort(rand(NIND,1));
         end
         PopIx = ChIx((1:NIns)')+ (irun-1)*NIND;
      % Calculate position of Nins-% best offspring
         if (NIns < NSEL),  % select best offspring
            [Dummy,OffIx] = sort(ObjVSel((irun-1)*NSEL+1:irun*NSEL));
         else              
            OffIx = (1:NIns)';
         end
         SelIx = OffIx((1:NIns)')+(irun-1)*NSEL;
      % Insert offspring in subpopulation -> new subpopulation
         Chrom(PopIx,:) = SelCh(SelIx,:);
         if (IsObjVCh == 1 & IsObjVSel == 1), ObjVCh(PopIx) = ObjVSel(SelIx); end
   end


% End of function
