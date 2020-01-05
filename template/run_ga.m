function min_fit = run_ga(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER,MUTATION,SELECTION,SURVIVOR_STR,STOP_THRESHOLD, LOCALLOOP, ah1, ah2, ah3)
% usage: run_ga(x, y, 
%               NIND, MAXGEN, NVAR, 
%               ELITIST, STOP_PERCENTAGE, 
%               PR_CROSS, PR_MUT, CROSSOVER, 
%               ah1, ah2, ah3)
%
%
% x, y: coordinates of the cities
% NIND: number of individuals
% MAXGEN: maximal number of generations
% ELITIST: percentage of elite population
% STOP_PERCENTAGE: percentage of equal fitness (stop criterium)
% PR_CROSS: probability for crossover
% PR_MUT: probability for mutation
% CROSSOVER: the crossover operator
% MUTATION: the mutation operator
% SELECTION : the selection operator
% SURVIVOR_STR : Survivor selection strategy
% STOP_THRESHOLD : fitness threshold value for stopping criterion
% calculate distance matrix between each pair of cities
% ah1, ah2, ah3: axes handles to visualise tsp
%{NIND MAXGEN NVAR ELITIST STOP_PERCENTAGE PR_CROSS PR_MUT CROSSOVER STOP_THRESHOLD LOCALLOOP}


        GGAP = 1 - ELITIST;
        BIT_STR_LEN = ceil(log2(NVAR));
        mean_fits=zeros(1,MAXGEN+1);
        worst=zeros(1,MAXGEN+1);
        Dist=zeros(NVAR,NVAR);
        for i=1:size(x,1)
            for j=1:size(y,1)
                Dist(i,j)=sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);
            end
        end
        % initialize population
        Chrom=zeros(NIND,NVAR);
        Chrom_binary =[];
        for row=1:NIND
            %First line : Adjacency representation
            %Second line : Path representation
        	Chrom(row,:)=path2adj(randperm(NVAR));
            %Chrom(row,:)=randperm(NVAR);
        end
        Chrom1 = Chrom;
        gen=0;
        % number of individuals of equal fitness needed to stop
        stopN=ceil(STOP_PERCENTAGE*NIND);
        % evaluate initial population
        ObjV = tspfun(Chrom,Dist);
      for row=1:NIND
            %First line : Adjacency representation
            %Second line : Path representation
        	Chrom(row,:)=adj2path(Chrom(row,:));
            Chrom_binary = [Chrom_binary;path2bin(Chrom(row,:),BIT_STR_LEN)];
            %Chrom(row,:)=randperm(NVAR);
        end
        best=zeros(1,MAXGEN);
        
        %%%%STOPPING CRITERION%%%%
        stopping_gen_threshold = MAXGEN/5;
        if stopping_gen_threshold > 100
           stopping_gen_threshold = 100; 
        end
        stop_counter = 0;
        prev_fitness = 0;
        % generational loop
        while gen<MAXGEN
            sObjV=sort(ObjV);
          	best(gen+1)=min(ObjV);
        	minimum=best(gen+1);
            
            %Stopping criterion 3 in book is implemented here!
            if abs(minimum - prev_fitness) < STOP_THRESHOLD
                stop_counter = stop_counter + 1;
                if stop_counter >= stopping_gen_threshold
                    break;
                end
            
            else
                stop_counter = 0;
            end
            prev_fitness = minimum;
            %%%%%%%%%%%%%%%%%%
            
            mean_fits(gen+1)=mean(ObjV);
            worst(gen+1)=max(ObjV);
            for t=1:size(ObjV,1)
                if (ObjV(t)==minimum)
                    break;
                end
            end
            
            
            visualizeTSP(x,y,bin2path(Chrom_binary(t,:),BIT_STR_LEN), minimum, ah1, gen, best, mean_fits, worst, ah2, ObjV, NIND, ah3);

            if (sObjV(stopN)-sObjV(1) <= 1e-15)
                  break;
            end
            
            for row=1:NIND
                %First line : Adjacency representation
                %Second line : Path representation
                Chrom(row,:)=bin2path(Chrom_binary(row,:),BIT_STR_LEN);
                Chrom(row,:)=path2adj(Chrom(row,:));
                %Chrom(row,:)=randperm(NVAR);
            end
            
        	%assign fitness values to entire population
        	FitnV=ranking(ObjV);
        	%select individuals for breeding
        	SelCh=select(SELECTION, Chrom, FitnV, GGAP);
        	%recombine individuals (crossover)
            SelCh = recombin(CROSSOVER,SelCh,PR_CROSS);
            SelCh=mutateTSP(MUTATION,SelCh,PR_MUT);
            %evaluate offspring, call objective function
        	ObjVSel = tspfun(SelCh,Dist);
            %reinsert offspring into population
        	[Chrom ObjV]=reins(Chrom,SelCh,1,SURVIVOR_STR,ObjV,ObjVSel);
            
            Chrom = tsp_ImprovePopulation(NIND, NVAR, Chrom,LOCALLOOP,Dist);
            
            Chrom_binary = [];
            for row=1:NIND
                Chrom_path(row,:)=adj2path(Chrom(row,:));
                Chrom_binary = [Chrom_binary;path2bin(Chrom_path(row,:),BIT_STR_LEN)];
            
            %Chrom(row,:)=randperm(NVAR);
            end
        	%increment generation counter
        	gen=gen+1;
        end
        min_fit = minimum;
end
