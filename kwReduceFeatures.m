function [newData] = kwReduceFeatures(dataScaled, threshold)
   [~, I] = kwRank(dataScaled);
   selected_features_ix = chooseUncorrelated(dataScaled, threshold, I);
   newData = dataScaled;
   newData.X = newData.X(selected_features_ix,:);
   newData.label = newData.label(selected_features_ix);
   newData.dim = size(selected_features_ix,2);
   newData.num_data=size(newData.X,2);
end
