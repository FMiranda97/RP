function [fisher_model, error_rate] = fisherLDA(data, training, testing)

    %Generate random training and test sets
    ix=randperm(data.num_data);
    ixtr=ix(1:floor(data.num_data*training));
    ixte=ix(floor(data.num_data*training)+1:end);
    
    data_tr.X = data.X(:,ixtr);
    data_tr.y = data.y(ixtr);
    data_tr.dim = size(data_tr.X,1);
    data_tr.num_data = size(data_tr.X,2);
    data_tr.name = 'Traning set';

    data_te.X = data.X(:,ixte);
    data_te.y = data.y(ixte);
    data_te.dim = size(data_te.X,1);
    data_te.num_data = size(data_te.X,2);
    data_te.name = 'Testing set';

    fisher_model = fld(data_tr); % train FLD classifier
    ypred = linclass (data_te.X,fisher_model);% classify testing data
    error_rate = cerror(ypred,data_te.y); % evaluate testing error

end