function [newData, items] = appFeatureSelection(data, raw, kw, correlation_threshold, checks)
    if checks(1), index = 1; else, index = 3; end
    if ~checks(2), index = index + 1; end
    newData = data(index);
    if strcmp(raw,'On')
        %%remove raw measurements
        newData.X = newData.X(31:end,:);
        newData.label = newData.label(31:end);
        newData.dim = size(newData.X,1);
        newData.num_data=size(newData.X,2); 
    end
    if strcmp(kw,'On')
        newData = kwReduceFeatures(newData, correlation_threshold);
    end
    items = cellstr(newData.label);
end
