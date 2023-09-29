function Out = ClassifyFunction(pop,nVar,Data)

    FeatIndex = pop; %Feature Index
    X1 = Data.X;% Features Set
    Y1 = Data.Y;% Class Information
    if pop==0
        FeatIndex = round(rand(1 , nVar));
    end
    X1 = X1(:,FeatIndex);
    
    PredClass=knnclassify(X1(round(0.6*size(X1 , 1))+ 1:end  , :), X1(1:round(0.6*size(X1 , 1)) , :)  , Y1(1:round(0.6*size(X1 , 1)) , :) , 5);
    
    [Precision,Recall,FeatureReduction,ConfusionMat]=PrecisionRecall(Y1,PredClass,pop);
    
    fitnesses=-(sum(PredClass == Y1(round(0.6*size(Data.X , 1))+ 1:end  , :))/length(round(0.6*size(X1 , 1))+ 1:size(Data.X , 1) ));
      
    Out.FeatIndex=FeatIndex;
    Out.fitnesses=-fitnesses;
    Out.Precision=Precision;
    Out.Recall=Recall;
    Out.Fr=FeatureReduction;
    Out.ConfusionMat=ConfusionMat;
    Out.output=PredClass';
    Out.target=(Y1(round(0.6*size(Data.X , 1))+ 1:end  , :))';
    Out.target(Out.target==1)=0;
    Out.target(Out.target==2)=1;
    Out.output(Out.output==1)=0;
    Out.output(Out.output==2)=1;
    
    
    Out
figure
plotconfusion(Out.target,Out.output);

function [p , r , fr , cm] = PrecisionRecall(target , output , x)

    target=target(round(.6 * size(target,1))+1 : size(target,1) , :);
    
    numClass = length(unique(target));
    
    cm = confusionmat(target, output);
    
    for i = 1 : numClass
        tp = cm(i , i);
        precision(i) =  tp / sum(cm(: , i));%#ok
        recall(i) = tp / sum(cm(i , :));%#ok
    end
    
    p = mean(precision);
    r = mean(recall);
    fr=(size(x,2)-sum(x))/size(x,2);
    