function [fisher_model, average_error, standard_dev] = appFisherLDA (app, data, n_runs, training, testing)
    
    close all
    %%fisher LDA classifier
    
    average_error=zeros(n_runs,1);
    for i = 1:n_runs
        [temp_model(i), error_rate] = fisherLDA(data, training, testing);
        average_error(i) = error_rate;
    end
    
    standard_dev = std(average_error);
    average_error = mean(average_error);
    
    fisher_model.W=temp_model(1).W;
    fisher_model.b=temp_model(1).b;
    fisher_model.fun=temp_model(1).fun;
    
    for i = 2:n_runs
        fisher_model.W=fisher_model.W+temp_model(i).W;
        fisher_model.b=fisher_model.b+temp_model(i).b;
    end
    
    fisher_model.W=fisher_model.W/n_runs;
    fisher_model.b=fisher_model.b/n_runs;
    
 end