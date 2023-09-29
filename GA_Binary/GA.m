clc;
clear;
close all;
global Data nVar
%% Problem Definition

Data  = load('myDataR.mat');                       % Load Data

Data.X = Data.A;                        % Normalize Data

Data.Y = linspace(1,1,100);


nVar=size(Data.X,2);                            % Number of Decision Variables

CostFunction=@(x)mRMR(x,nVar,Data);             % Cost Function

%% GA Parameters

MaxIt=20;      % Maximum Number of Iterations

nPop=50;        % Population Size

pc=0.8;                 % Crossover Percentage
nc=2*round(pc*nPop/2);  % Number of Offsprings (Parnets)

pm=0.02;                 % Mutation Percentage
nm=round(pm*nPop);      % Number of Mutants

mu=0.2;         % Mutation Rate

%% Initialization

empty_individual.Position=[];
empty_individual.Features=[];
empty_individual.Cost=[];

pop=repmat(empty_individual,nPop,1);

for i=1:nPop
    
    pop(i).Position = randi([1,2] ,1, nVar);
    pop(i).Features = find(pop(i).Position>1);
    pop(i).Cost = CostFunction(pop(i).Position);
    if isnan(pop(i).Cost)
        
        pop(i).Cost = rand;
        
    end
    
end

% Sort Population
Costs=[pop.Cost];
[Costs, SortOrder]=sort(Costs);
pop=pop(SortOrder);

% Store Best Solution
BestSol=pop(1);

% Array to Hold Best Cost Values
BestCost=zeros(MaxIt,1);

% Store Cost
WorstCost=pop(end).Cost;


popGlobal =[];

%% Main Loop
tic
for it=1:MaxIt
    
    
    P=Costs/sum(Costs);
    
    % Crossover
    popc=repmat(empty_individual,nc/2,2);
    for k=1:nc/2
        
        %  Select Parents Indices
        i1=RouletteWheelSelection(P);
        i2=RouletteWheelSelection(P);

        % Select Parents
        p1=pop(i1);
        p2=pop(i2);
        
        % Apply Crossover
        flag = true;
            
        [popc(k,1).Position, popc(k,2).Position]=Crossover(p1.Position,p2.Position, Data);
            
        % Evaluate Offsprings
        popc(k,1).Features = find(popc(k,1).Position>1);
        popc(k,1).Cost = CostFunction(popc(k,1).Position);
        
        if isnan(popc(k,1).Cost)
        
            popc(k,1).Cost = rand;
        
        end
        
        popc(k,2).Features = find(popc(k,2).Position>1);
        popc(k,2).Cost = CostFunction(popc(k,2).Position);
        
        if isnan(popc(k,2).Cost)
        
            popc(k,2).Cost = rand;
        
        end
        
        
    end
    popc=popc(:);
    
    % Mutation
    popm=repmat(empty_individual,nm,1);
    for k=1:nm
        
        % Select Parent
        i=randi([1 nPop]);
        p=pop(i);
        
        % Apply Mutation    
    
        popm(k).Position=Mutate(p.Position,mu);
        popm(k).Features = find(popm(k).Position>1);
        
        % Evaluate Mutant
        popm(k).Cost=CostFunction(popm(k).Position);
        
        if isnan(popm(k).Cost)
        
            popm(k).Cost = rand;
        
        end
        
    end
    
    % Create Merged Population
    pop=[pop
         popc
         popm];
    
    popGlobal = [pop; popc;popm]; 
    % Sort Population
    Costs=[pop.Cost];
    [Costs, SortOrder]=sort(Costs, 'Ascend');
    pop=pop(SortOrder);
    
    % Update Worst Cost
    WorstCost=max(WorstCost,pop(end).Cost);
    
    % Truncation
    pop=pop(1:nPop);
    Costs=Costs(1:nPop);
    
    % Store Best Solution Ever Found
    BestSol=pop(1);
    
    % Store Best Cost Ever Found
    BestCost(it)=BestSol.Cost;
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
    if (it==1)
        TimeOfEachIteration = toc;
        
    end
    
end
 

%% Results
TimeOfEachIteration
figure;
plot (BestCost, 'LineWidth', 2);
xlabel ('Iteration');
ylabel ('Best Cost');
BestSol = [1,2]
