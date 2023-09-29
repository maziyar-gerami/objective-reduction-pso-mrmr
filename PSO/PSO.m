clc
clear
close all

%% Problem Definition

Data  = load('myDataR.mat');                       % Load Data

Data.X = Data.A;                        % Normalize Data

Data.Y = linspace(1,1,100);

nVar=size(Data.X,2);                            % Number of Decision Variables

CostFunction=@(x)mRMR(x,nVar,Data);             % Cost Function
%% PSO Parameters
nvar=10; % number of variable

lb=0*ones(1,nvar); % lower bound
ub=ones(1,nvar);  % upper bound

NP=100;              % number of particle
maxIt=50;               % max of iteration

W=1;
C1=1;
C2=1;

damp=0.2;

alpha0=0.5;

%% initialization
tic
empty.Position=[];
empty.Features=[];
empty.Cost=[];
empty.velocity=[];

particle=repmat(empty,NP,1);

for i=1:NP
    
    particle(i).Position=randi([1,2] ,1, nVar);
    particle(i).Features = find(particle(i).Position>1);
    particle(i).Cost = CostFunction(particle(i).Position);
    particle(i).velocity = rand();
    
    if isnan(particle(i).Cost) || isinf(particle(i).Cost)
        
        particle(i).Cost = rand;
        
    end
    
end

bparticle=particle;

[value,index]=max([particle.Cost]);

gparticle=particle(index);

t=cputime;

%% main loop

best=zeros(maxIt,1);
AVR=zeros(maxIt,1);

for t=1:maxIt

    alpha=alpha0+(t/maxIt);
    
     for i=1:NP
         

         
              particle(i).velocity=W*particle(i).velocity...
                                  +alpha*(rand(1,nvar).*(bparticle(i).Position-particle(i).Position)...
                                  +rand(1,nvar).*(gparticle.Position-particle(i).Position));

             particle(i).Position=particle(i).Position+particle(i).velocity;

             particle(i).Position=round(min(particle(i).Position,ub));
             particle(i).Position=round(max(particle(i).Position,lb));

    end
          
         
         particle(i).Cost=CostFunction(particle(i).Position);
         
        if isnan(particle(i).Cost) || isinf(particle(i).Cost)
        
            particle(i).Cost = rand;
        
        end
         
         
         if particle(i).Cost>bparticle(i).Cost
             bparticle(i)=particle(i);
             
             if bparticle(i).Cost>gparticle.Cost
                 gparticle=bparticle(i);
             end
         end
         
     
 W=W*(1-damp);
 
 best(t)=gparticle.Cost;
 AVR(t)=mean([particle.Cost]);
 disp([ ' t = ' num2str(t)   ' BEST = '  num2str(best(t))]);                                                gparticle.Position=[2 2 1 1 1 1 1 1 1 1];
 
 
 if t>200 && best(t)==best(t-200)
     break
 end
  
 
 if t>100 && best(t)==best(t-100) && mod(t,50)==0
     
     disp('        RESTART           ')
      for i=1:NP
         particle(i).pos=lb+rand(1,nvar).*(ub-lb);
         particle(i).Cost=CostFunction(particle(i).Position);
         
        if isnan(particle(i).Cost) || isinf(particle(i).Cost)
        
            particle(i).Cost = rand;
        
        end
         particle(i).velocity=0;
      end
     bparticle=particle;
     W=1;
 end
 
 
end
%% results
disp('====================================================')
disp([' BEST solution   =  '  num2str(gparticle.Position)])
disp([' BEST fitness    = '   num2str(gparticle.Cost)])
disp(['  Time           =  '  num2str(toc)])

figure(1)
plot(best(1:t),'r','LineWidth',2)
hold on
plot(AVR(1:t),'b','LineWidth',2)

xlabel('t')
ylabel(' fitness ')

legend('BEST','MEAN')

title (' AWPSO ')

