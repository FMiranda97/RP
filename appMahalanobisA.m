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
    
    for i = 2:n_runs
        mahalanobis_model.W=mahalanobis_model.W+temp_model(i).W;
        mahalanobis_model.b=mahalanobis_model.b+temp_model(i).b;
        mahalanobis_model.mu=mahalanobis_model.mu+temp_model(i).mu;
    end
    
    mahalanobis_model.W=mahalanobis_model.W/n_runs;
    mahalanobis_model.b=mahalanobis_model.b/n_runs;
    mahalanobis_model.mu=mahalanobis_model.mu/n_runs;
    
    %plot
    app.UIAxes.cla    
    
    if ((size (data.X, 1)>1) &  (data.X(1,:)==real(data.X(1,:))) & (data.X(2,:)==real(data.X(2,:))))
        plot(app.UIAxes,data.X(1,(data.y==2)),data.X(2,(data.y==2)),'o');
        hold (app.UIAxes,'on')
        plot(app.UIAxes,data.X(1,(data.y~=2)),data.X(2,(data.y~=2)),'+');
        xlabel(app.UIAxes,'f1');
        ylabel(app.UIAxes,'f2');
        title(app.UIAxes,'Mahalanobis');
        plot(app.UIAxes,mahalanobis_model.mu(1,1), mahalanobis_model.mu(2,1),'ro','markersize',10,'linewidth',2);
        plot(app.UIAxes,mahalanobis_model.mu(1,2), mahalanobis_model.mu(2,2),'r+','markersize',10,'linewidth',2);
        line(app.UIAxes,[mahalanobis_model.mu(1,1),mahalanobis_model.mu(1,2)], [mahalanobis_model.mu(2,1),mahalanobis_model.mu(2,2)], 'linestyle','--',['color'], 'k','linewidth',3);
        legend(app.UIAxes,'\omega1','\omega2','Mean \omega1','Mean \omega2', 'Line between means');

        avg_mu=(mahalanobis_model.mu(:,1)+mahalanobis_model.mu(:,2))/2;
        plot(app.UIAxes, avg_mu(1),avg_mu(2),'rs','markersize',10,'linewidth',2)%Plot middle point between means

        %displaying discriminant equations
        text(app.UIAxes,1.7,10, sprintf('g1(x)=%s%.2f %.2f%sx-%.2f\n', '[', mahalanobis_model.W(1,1),mahalanobis_model.W(2,1),']', mahalanobis_model.b(:,1)), 'fontsize',10,'fontweight','bold');
        text(app.UIAxes,1.7,9.5, sprintf('g2(x)=%s%.2f %.2f%sx-%.2f\n', '[', mahalanobis_model.W(1,2),mahalanobis_model.W(2,2),']', mahalanobis_model.b(:,2)), 'fontsize',10,'fontweight','bold');

        dif_mu=(mahalanobis_model.W(:,1)-mahalanobis_model.W(:,2))';

        b=(mahalanobis_model.b(:,2)-mahalanobis_model.b(:,1))/(mahalanobis_model.W(2,1)-mahalanobis_model.W(2,2));
        r=(-dif_mu(1)/dif_mu(2)).*data.X(1,:)'+b;
        %hyperplane equation
        plot(app.UIAxes,data.X(1,:),r,'r','linewidth',2);
        set(app.UIAxes, 'fontweight','bold','fontsize',14);
        legend(app.UIAxes,'\omega1', '\omega2','Mean \omega1', 'Mean \omega2', 'Line between means', 'Average Means', 'Hyperplane');
        text(app.UIAxes,2,6,sprintf('Decision hyperplane ==> g1(x)=g2(x) ==> PRT10=%.2fN+%.2f',-dif_mu(1)/dif_mu(2),mahalanobis_model.b), 'fontsize',10,'fontweight','bold');
        axis(app.UIAxes,[min(data.X(1,:)) max(data.X(1,:)) min(data.X(2,:)) max(data.X(2,:))]);
    end
end