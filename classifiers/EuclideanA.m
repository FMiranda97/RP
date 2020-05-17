function [euclidean_model, error_rate] = EuclideanA(data, training, testing)

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
    mu1=mean(data_tr.X(:,data_tr.y~=2),2);
    mu2=mean(data_tr.X(:,data_tr.y==2),2);

    %euclidean hyperplane
    w1 = mu1;
    w2 = mu2;
    b1 = -(w1'*w1)/2;
    b2 = -(w2'*w2)/2;

    
    %remove and replace by actual weights
    %dif_mu = (w1-w2)';
    %avg_mu = (w1+w2)/2;
    %b = ((avg_mu(1)*dif_mu(1)) + (avg_mu(2)*dif_mu(2)))/dif_mu(2);
    
    
    euclidean_model.W=[w1 w2];
    euclidean_model.b=[b1 b2];
    
	%TODO error
    ypred = linclass (data_te.X,euclidean_model); % classify testing data
    error_rate = cerror(ypred,data_te.y); % evaluate testing error
end



