function  normalizedA = NormData( Data )

    normData = max(Data.X) - min(Data.X);               % this is a vector
    
    normData = repmat(normData, [length(Data.X) 1]);    % this makes it a matrix
    
    minmatrix= repmat(min(Data.X), [length(Data.X) 1]); % of the same size as A
                                                         
    normalizedA = (Data.X-minmatrix)./normData;         % your normalized matrix


end

