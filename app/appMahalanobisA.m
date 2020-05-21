function [mahalanobis_model, average_error, standard_dev] = appMahalanobisA (app, data, n_runs, training, testing, n_classes)

    close all
    %%Mahalanobis MDC classifier
    average_error=zeros(n_runs,1);

    for i = 1:n_runs
        [temp_model(i), error_rate] = Mahalanobis(data, n_classes, training, testing);
        average_error(i) = error_rate;
    end    


    standard_dev = std(average_error);
    average_error = mean(average_error);
    
    mahalanobis_model.W=temp_model(1).W;
    mahalanobis_model.b=temp_model(1).b;
    mahalanobis_model.mu=temp_model(1).mu;
    mahalanobis_model.fun=temp_model(1).fun;
    
    for i = 2:n_runs
        mahalanobis_model.W=mahalanobis_model.W+temp_model(i).W;
        mahalanobis_model.b=mahalanobis_model.b+temp_model(i).b;
        mahalanobis_model.mu=mahalanobis_model.mu+temp_model(i).mu;
    end
    
    mahalanobis_model.W=mahalanobis_model.W/n_runs;
    mahalanobis_model.b=mahalanobis_model.b/n_runs;
    mahalanobis_model.mu=mahalanobis_model.mu/n_runs;
    
end