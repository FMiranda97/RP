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
    
    for i = 2:n_runs
        euclidean_model.W=temp_model(i).W;
        euclidean_model.b=temp_model(i).b;
    end
    
    euclidean_model.W=euclidean_model.W/n_runs;
    euclidean_model.b=euclidean_model.b/n_runs;
    
    
    %plotting
    app.UIAxes.cla
    
    if ((size (data.X, 1)>1) &  (data.X(1,:)==real(data.X(1,:))) & (data.X(2,:)==real(data.X(2,:))))
        plot(app.UIAxes,data.X(1,(data.y==2)),data.X(2,(data.y==2)),'o');
        hold (app.UIAxes,'on')
        plot(app.UIAxes,data.X(1,(data.y~=2)),data.X(2,(data.y~=2)),'+');
        xlabel(app.UIAxes,'f1');
        ylabel(app.UIAxes,'f2');
        title(app.UIAxes,'Euclidean Minimum Distance Classifier');
        plot(app.UIAxes,euclidean_model.W(1,1), euclidean_model.W(2,1),'ro','markersize',10,'linewidth',2);
        plot(app.UIAxes,euclidean_model.W(1,2), euclidean_model.W(2,2),'r+','markersize',10,'linewidth',2);
        line(app.UIAxes,[euclidean_model.W(1,1),euclidean_model.W(1,2)], [euclidean_model.W(2,1),euclidean_model.W(2,2)], 'linestyle','--',['color'], 'k','linewidth',3);
        legend(app.UIAxes,'\omega1','\omega2','Mean \omega1','Mean \omega2', 'Line between means');

        %euclidean hyperplane
        dif_w = (euclidean_model.W(:,1)-euclidean_model.W(:,2))';
        avg_w = (euclidean_model.W(:,1)+euclidean_model.W(:,2))/2;
        b = ((avg_w(1)*dif_w(1)) + (avg_w(2)*dif_w(2)))/dif_w(2);
        
        plot(app.UIAxes,avg_w(1),avg_w(2), 'rs', 'markersize',10,'linewidth',2);
        text(app.UIAxes, 1.7,10, sprintf('g1(x)=%s%.2f %.2f%sx-%.2f\n', '[', euclidean_model.W(1,1),euclidean_model.W(2,1),']', (euclidean_model.W(1,1)^2+euclidean_model.W(2,1)^2)/2), 'fontsize',10,'fontweight','bold');
        text(app.UIAxes, 1.7,9.5, sprintf('g2(x)=%s%.2f %.2f%sx-%.2f\n', '[', euclidean_model.W(1,2),euclidean_model.W(2,2),']', (euclidean_model.W(1,2)^2+euclidean_model.W(2,2)^2)/2), 'fontsize',10,'fontweight','bold');

        r = (-dif_w(1)/dif_w(2)).*data.X(1,:) + b;

        plot(app.UIAxes,data.X(1,:),r,'r','linewidth',2);
        set(app.UIAxes, 'fontweight','bold','fontsize',14);
        legend(app.UIAxes,'\omega1', '\omega2','Mean \omega1', 'Mean \omega2', 'Line between means', 'Average Means', 'Hyperplane');
        text(app.UIAxes,2,6,sprintf('Decision hyperplane ==> g1(x)=g2(x) ==> y=%.2f+%.2f',-dif_w(1)/dif_w(2),b), 'fontsize',10,'fontweight','bold');
        axis(app.UIAxes,[min(data.X(1,:)) max(data.X(1,:)) min(data.X(2,:)) max(data.X(2,:))]);
    end
end



