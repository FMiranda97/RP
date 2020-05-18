function [bayes_model, error_rate] = Bayes(data, nClass, training, testing)

    ix=randperm(data.num_data);
    ixtr=ix(1:floor(data.num_data*training));
    ixte=ix(floor(data.num_data*testing)+1:end);
    
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

    
    for i = 1:nClass
        indx=find(data_tr.y==i);
        % Estimation of class-conditional distributions by EM
        bayes_model.Pclass{i} = emgmm(data_tr.X(:,indx),struct('ncomp',nClass));
        n(i)=length(indx);
    end
    
    % Estimation of priors
    bayes_model.Prior = n./sum(n);
    % Evaluation on testing data
    ypred = bayescls(data_te.X,bayes_model);
    error_rate=cerror(ypred,data_te.y);
    
end