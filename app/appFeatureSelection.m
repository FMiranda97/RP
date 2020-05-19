function [newData, items, indices] = appFeatureSelection(data, raw, autoSelect, autoSelectMethod, correlation_threshold, checks)
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
    if strcmp(autoSelect,'On')
        newData = autoSelectFeatures(newData, correlation_threshold, autoSelectMethod);
    end
    items = cellstr(newData.label);
    indices = zeros(size(items));
    for i = 1:length(indices)
        indices(i) = find(strcmp([data.label], items{i}),1);
    end
end
