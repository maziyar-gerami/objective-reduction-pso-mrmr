function [y1, y2]=Crossover(x1,x2, Data)

    alpha=randi([1 2],size(x1));
    
	y1=alpha.*x2+(1-alpha).*x1;
	y2=alpha.*x2+(1-alpha).*x1;


end