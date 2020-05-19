function [avg_error, std_error] = multiModelClassifier(data, models, checks)
    if checks(1), index = 1; else, index = 3; end
    if ~checks(2), index = index + 1; end
    data = data(index);
    ypred = zeros(length(models), length(data.y));
    for i = 1:length(models)
        X = data.X(models{i}.indices, :);
        %%linha abaixo funciona para os classificadores da meta1, como
        %%fazer para os novos classificadores?
        if models{i}.name == "bayes_model"
            ypred(i,:) = bayescls(X,models{i});
        elseif models{i}.name == "svm_model"
            ypred(i,:) = svmclass(X,models{i});
        else
            ypred(i,:) = linclass(X,models{i});
        end
    end
    ypred = mode(ypred);
     % classify testing data
    avg_error = cerror(ypred,data.y);
    std_error = 0;
end