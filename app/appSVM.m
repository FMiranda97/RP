function [svm_model, average_error, standard_dev] = appSVM (app, data, n_runs, training, testing, n_classes)
    close all

%% SVM parameter tuning
    c_pot = [-2:1];
    C=2.^c_pot;

    %% Model evaluation

    [models, error_rate] = SVM (data, n_classes, training, testing, n_runs);

    if n_runs > 1
        average_err = mean(error_rate);
        standard_dev = std(error_rate);
    else
        average_err = error_rate;
        standard_dev = zeros(1,numel(error_rate));
    end
    
    %plotting 
    app.UIAxes.cla;
    
%     plot(c_pot, average_err, 'o');
%     ylabel('Testing Error (%)');
%     set(gca, 'xtick', c_pot);
%     set(gca,'xticklabel', strcat('2^', cellfun(@num2str,num2cell(c_pot), 'UniformOutput',0)));
%     hold on;
%     errorbar(c_pot, average_err, standard_dev);
%     axis([c_pot(1) c_pot(end) 0 100]);

    %%Inspect for a svm_model Classifier
    ix=find(average_err==min(average_err));
    ix=ix(1);
    fprintf("\nAverage svm_model C value = 2^%d\n", c_pot(ix));
    ix_min_err = find(error_rate(:,ix) == min(error_rate(:,ix)));
    if numel(ix_min_err)>1
        sel_class=models(ix_min_err,ix);
        nsvs=zeros(1,numel(ix_min_err));
        for m=1:numel(ix_min_err)
            nsvs(m) = sel_class{m}.nsv;
        end
        ix_min_nsv = find(nsvs==min(nsvs));
        svm_model=sel_class{ix_min_nsv};
    else
        svm_model=models{ix_min_err,ix};
    end

    %[ypred, dfce] = svmclass(data_te.X, svm_model)
    %[FPR, FNR] = roc(dfce, data_te.y);
    %figure(); plot(FPR,1-FNR);
    %figure;ppatterns(data_tr); psvm(svm_model, struct('background',1));

end



