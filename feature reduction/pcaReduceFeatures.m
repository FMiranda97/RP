function [newData, model] = pcaReduceFeatures(dataScaled, variance)
    % get sorted eigenvalues that make for 95% of the variance
    if variance > 1
        variance = min([variance size(dataScaled.X,1)]);
        model = pca(dataScaled.X, variance);
    else
        model = pca(dataScaled.X, 1-variance);
    end
    newData = dataScaled;
    newData.X = linproj(dataScaled.X, model);
    newData.dim = size(newData.X,1);
end

