function [Cost,FeatIndex] = mRMR (selected, nVar,Data)

    pop =linspace(1,nVar,nVar);

    FeatIndex = pop(find(selected==2)); %Feature Index
    
    target = Data.Y;
    
    if var(selected)==0
        Cost =+inf;
        return;
    end
    
    SelectedData = Data.X(:,FeatIndex);
    
    if pop==0
        FeatIndex = round(rand(1 , nVar));
    end
    
    [~,R] = size(FeatIndex);
    
    Rel1=0;
    
    
    for i=1:R
        
        Rel1 = Rel1 + F(i, SelectedData, target);
        
    end
    
    Relevance = (1/R) *(Rel1);
    
    Red1=0;
    
    for i=1:R
        
        for j=1:R
           
            Red1 = Red1 + abs(corrlation (SelectedData,i,j));
            
        end
        
    end
    
    Redundancy = (1/(R^2))*Red1;

    QBC = Relevance/Redundancy;
    
    Cost = 1/QBC;


end

function F = F (fi, SelectedData, target)

    F1=0;
    V1=0;

    for i=1:2
       [N,~] = size(SelectedData);
        
       [Nt, ~] = size(find(target==i));
       
       mu = mean(SelectedData(:,fi));
       
       mut= mean(SelectedData(find(target==i),fi));
       
       F1 = F1 + Nt*((mut-mu)^2);
       
       V1 = V1+ (Nt-1)* var(SelectedData(find(target==i),fi));
       
    end
    
    V = V1/(N-2);
    
    F = F1/V;

end


function corr = corrlation (X, i, j)

    covariance = (cov((X(:,i)),(X(:,j))));

    corr = (covariance(1,2))/((sqrt(var(X(:,i)))) * (sqrt(var(X(:,j)))) );


end