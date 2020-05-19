function [mahalanobis_model, error_rate] = Mahalanobis (data, nClass, training, testing)

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

    %calculate feature means for each class
    
    for i = 1:nClass
        means(:,i)=mean(data_tr.X(:,data_tr.y==i),2);
    end
    
    %calculate covariances

    for i = 1:nClass
        C(:,:,i)=cov(data_tr.X(:,data_tr.y==i)');
    end

    %pooled covariance and it's inversa
    pC=C(:,:,1);
    for i = 2:nClass
        pC=pC+C(:,:,i);
    end
    pC=pC./nClass;
    C_inv = pC^-1;
    
    %Computing discriminant weights
    
    for i = 1:nClass
        weights(:,i) = C_inv*means(:,i);
        bias(i) = -0.5*means(:,i)'*C_inv*means(:,i);
    end

    mahalanobis_model.W=weights;
    mahalanobis_model.b=bias;
    mahalanobis_model.mu=means;
    mahalanobis_model.fun='linclass';

    %TODO error
    ypred = linclass (data_te.X,mahalanobis_model); % classify testing data
    error_rate = cerror(ypred,data_te.y); % evaluate testing error
    
end