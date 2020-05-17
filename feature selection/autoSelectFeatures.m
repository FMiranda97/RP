function [newData] = autoSelectFeatures(dataScaled, threshold, method)
    if(strcmp(method, 'KruskalWallis'))
        [~, I] = kwRank(dataScaled);
    else
        [~, I] = aucRank(dataScaled);
    end
    selected_features_ix = chooseUncorrelated(dataScaled, threshold, I);
    newData = dataScaled;
    newData.X = newData.X(selected_features_ix,:);
    newData.label = newData.label(selected_features_ix);
    newData.dim = size(selected_features_ix,2);
    newData.num_data=size(newData.X,2);
end
