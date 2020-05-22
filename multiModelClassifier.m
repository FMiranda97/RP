function [avg_error, std_error] = multiModelClassifier(data, models, checks)
    if checks(1), index = 1; else, index = 3; end
    if ~checks(2), index = index + 1; end
    data = data(index);
    fun = @(x) models{x}.set == index; % useful for complicated fields
    tf2 = arrayfun(fun, 1:numel(models));
    n_models = sum(tf2);
    ypred = zeros(n_models, length(data.y));
    j = 1;
    for i = 1:length(models)
        if models{i}.set ~= index
            continue;
        end
        X = data.X(models{i}.indices, :);
        if ~isempty(models{i}.reduction_model)
            X = linproj(X, models{i}.reduction_model);
        end
        if models{i}.name == "bayes_model"
            ypred(j,:) = bayescls(X,models{i});
        elseif models{i}.name == "svm_model"
            ypred(j,:) = svmclass(X,models{i});
        elseif models{i}.name == "knn_model"
            ypred(j,:) = knnclass(X,models{i});
        else
            ypred(j,:) = linclass(X,models{i});
        end
        j = j + 1;
    end
    if n_models > 1
        ypred = mode(ypred);
    end
    % classify testing data
    std_error = 0;
    if n_models > 0
        avg_error = cerror(ypred,data.y);
        if max(ypred) > 3
            old = string([11:28]);
            labels = ["Walking", "Jogging", "Stairs", "Sitting", "Standing", "Typing", "Brushing Teeth", "Eating Soup", "Eating Chips", "Eating Pasta", "Drinking from Cup", "Eating Sandwich", "Kicking", "Playing Catch", "Dribbling", "Writing", "Clapping", "Folding Clothes"];
            ypred = replace(string(ypred+10), old, labels);
            data.y = replace(string(data.y+10), old, labels);
        elseif max(ypred) == 3
            old = string([1:3]);
            labels = ["Non - Hand Oriented", "Hand Oriented", "Eating"];
            ypred = replace(string(ypred), old, labels);
            data.y = replace(string(data.y), old, labels);
        elseif max(ypred) == 2
            old = string([1:2]);
            labels = ["Jogging", "Non Jogging"];
            ypred = replace(string(ypred), old, labels);
            data.y = replace(string(data.y), old, labels);
        else
            return;
        end
        figure();
        c_mat = confusionchart(data.y, ypred, 'Title','Confusion Matrix', 'RowSummary','row-normalized', 'ColumnSummary','column-normalized');
    else
        avg_error = -1;
    end
end