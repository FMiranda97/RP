function [models, error_rate] = SVM (data, n_classes, training, testing, n_runs, C)
    %% Model evaluation
    error_rate = zeros(n_runs, numel(C));
    models = cell(n_runs, numel(C));

    for n=1:n_runs
        ix=randperm(data.num_data);
        ixtr=ix(1:floor(data.num_data*training));
        ixte=ix(floor(data.num_data*training)+1:end);

        %training dataset
        data_tr.X = data.X(:,ixtr);
        data_tr.y = data.y(ixtr);
        data_tr.dim = size(data_tr.X,1);
        data_tr.num_data = size(data_tr.X,2);
        data_tr.name = 'Traning set';
        %testing dataset
        data_te.X = data.X(:,ixte);
        data_te.y = data.y(ixte);
        data_te.dim = size(data_te.X,1);
        data_te.num_data = size(data_te.X,2);
        data_te.name = 'Testing set';

        for co=1:numel(C)
            fprintf("======\nrun=%d\nCost=%f\n======\n",n,C(co));
            disp("Let's train");
            model = oaasvm(data_tr, struct('solver','smo','ker', 'linear','C',C(co)));
            ypred = svmclass(data_te.X, model);
            error_rate(n, co) = cerror(ypred, data_te.y)*100;
            models{n, co} = model;
        end
    end

end



