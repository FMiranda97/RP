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
    
    for i = 2:n_runs
        fisher_model.W=temp_model(i).W;
        fisher_model.b=temp_model(i).b;
    end
    
    fisher_model.W=fisher_model.W/n_runs;
    fisher_model.b=fisher_model.b/n_runs;
    
    
    %plotting 
    app.UIAxes.cla
    
    if ((size (data.X, 1)>1) &  (data.X(1,:)==real(data.X(1,:))) & (data.X(2,:)==real(data.X(2,:))))
        plot(app.UIAxes,data.X(1,(data.y==2)),data.X(2,(data.y==2)),'o');
        hold (app.UIAxes,'on')
        plot(app.UIAxes,data.X(1,(data.y~=2)),data.X(2,(data.y~=2)),'+');
        xlabel(app.UIAxes,'f1');
        ylabel(app.UIAxes,'f2');
        title(app.UIAxes,'Fisher LDA');
        %legend(app.UIAxes,'\omega_1','\omega_2')

        hold (app.UIAxes,'on')
        app.UIAxes
        %discriminant hyperplane
        %r= fisher_model.W(1:2)'*data.X(1:2,:)+fisher_model.b;
        [x1,y1,x2,y2,~]=clipline(fisher_model.W,fisher_model.b,[min(data.X(1,:)) max(data.X(1,:)) min(data.X(2,:)) max(data.X(2,:))]);

        plot(app.UIAxes,[x1,x2],[y1,y2],'linewidth',3)

        axis(app.UIAxes,[min(data.X(1,:)) max(data.X(1,:)) min(data.X(2,:)) max(data.X(2,:))]);
    end