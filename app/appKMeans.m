function [kmeans_model, average_error, standard_dev] = appKMeans (app, data, n_runs, training, testing, n_classes)

    close all
    %%Kmeans classifier
    
    average_error=zeros(n_runs,1);
    for i = 1:n_runs
        [temp_model(i), error_rate] = KMeans(data, n_classes, training, testing);
        average_error(i) = error_rate;
    end
    
    standard_dev = std(average_error);
    average_error = mean(average_error);
    
    kmeans_model=temp_model(1);
    
end