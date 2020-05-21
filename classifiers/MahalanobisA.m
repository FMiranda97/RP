function [mahalanobis_model, error_rate] = MahalanobisA (data, training, testing)

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

    %calculate feature means for each class
    mu1=mean(data_tr.X(:,data_tr.y~=2),2);
    mu2=mean(data_tr.X(:,data_tr.y==2),2);
    %calculate covariances
    C1=cov(data_tr.X(:,data_tr.y~=2)');
    C2=cov(data_tr.X(:,data_tr.y==2)');

    %pooled covariance and it's inversa
    C=(C1+C2)./2;
    C_inv = C^-1;
    
    %Computing discriminant weights
    w1 = C_inv*mu1;
    w2 = C_inv*mu2;
    b1 =-0.5*mu1'*C_inv*mu1;
    b2 =-0.5*mu2'*C_inv*mu2;
    
    mahalanobis_model.W=[w1 w2];
    mahalanobis_model.b=[b1 b2];
    mahalanobis_model.mu=[mu1 mu2];

    %TODO error
    ypred = linclass (data_te.X,mahalanobis_model); % classify testing data
    error_rate = cerror(ypred,data_te.y); % evaluate testing error
    
end