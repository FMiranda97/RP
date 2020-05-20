function [selected_features_ix] = chooseUncorrelated(dataScaled, threshold, orderI)
   C = corr(dataScaled);
   selected_features_ix = [];
   for i = orderI
       isCorrelated = false;
       for j = selected_features_ix
           if abs(C(i, j)) > threshold
               isCorrelated = true;
           end
       end
       if ~isCorrelated && ~isnan(C(i, 1))
           selected_features_ix = [selected_features_ix i];
       end
   end
end

