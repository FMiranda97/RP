function [euclidean_model, average_error, standard_dev]= appEuclideanA(app, data, n_runs, training, testing, n_classes)
    
    close all
    %%Euclidean MDC classifier
    average_error=zeros(n_runs,1);
    
    for i = 1:n_runs
        [temp_model(i), error_rate] = Euclidean(data, n_classes, training, testing);
        average_error(i) = error_rate;
    end
    
    standard_dev = std(average_error);
    average_error = mean(average_error);
    
    euclidean_model.W=temp_model(1).W;
    euclidean_model.b=temp_model(1).b;
    euclidean_model.fun=temp_model(1).fun;
    
    for i = 2:n_runs
        euclidean_model.W=euclidean_model.W+temp_model(i).W;
        euclidean_model.b=euclidean_model.b+temp_model(i).b;
    end
    
    euclidean_model.W=euclidean_model.W/n_runs;
    euclidean_model.b=euclidean_model.b/n_runs;
    
end
