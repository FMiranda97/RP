function [newData] = ldaReduceFeatures(dataScaled, n)
    n = min([n size(dataScaled.X,1)]);
    %% reduce to n features
    model = lda(dataScaled, n);
    newData = dataScaled;
    newData.X = linproj(dataScaled.X, model);
    newData.dim = size(newData.X,1);
end

