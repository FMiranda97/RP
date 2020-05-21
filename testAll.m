function testAll(data, n_classes)
    reductionFuncs = {@ldaReduceFeatures, @pcaReduceFeatures, @pcaReduceFeatures};
    classifierFuncs = {@Bayes, @Euclidean, @KNN, @Mahalanobis};
    
    
    file = fopen(sprintf("resultados%d.txt", n_classes), 'a');
    n_runs = 25;
    
    %%choose data set
    for i = 1:4
        setData = data(i);
        %%choose features
        for removeFirst = [0 30]
            setData.X = data(i).X(removeFirst+1:end,:);
            setData.label = data(i).label(removeFirst+1:end);
            setData.dim = size(setData.X,1);
            setData.num_data=size(setData.X,2);
            
            %%choose maximum correlation
            for correlation = [0.1 0.5 0.9 1]
                for method = ["KruskalWallis" "ROC"]
                    uncorrelatedData = autoSelectFeatures(setData, correlation, method);
                    %%choose reduction technique
                    for redIndex = 1:length(reductionFuncs)
                        redFunc = reductionFuncs{redIndex};

                        %%choose reduction parameter
                        if redIndex == 3, params = [0.95 0.75 0.5];
                        else params = [2 3 5 10]; end
                        for n = params
                            reducedData = redFunc(uncorrelatedData, n);

                            %%choose classifier
                            for clasIndex = 1:length(classifierFuncs)
                                clasFunc = classifierFuncs{clasIndex};

                                %%choose partition
                                for partition = [0.5]

                                    %%execute runs
                                    try
                                        average_error=zeros(n_runs,1);
                                        for run = 1:n_runs
                                            [~, error_rate] = clasFunc(reducedData, n_classes, partition, 1 - partition);
                                            average_error(run) = error_rate;
                                        end
                                        %%write results to file
                                        fprintf(file, "%d,%d,%d,%s,%s,%f,%s,%f,%f,%f\n",i,removeFirst, correlation, method, func2str(redFunc), n, func2str(clasFunc), partition, mean(average_error), std(average_error));
                                        fprintf("%d,%d,%d,%s,%s,%f,%s,%f,%f,%f\n",i,removeFirst, correlation, method, func2str(redFunc), n, func2str(clasFunc), partition, mean(average_error), std(average_error));
                                    catch
                                        fprintf(file, "%d,%d,%d,%s,%s,%f,%s,%f,FAILED,FAILED\n",i,removeFirst, correlation, method, func2str(redFunc), n, func2str(clasFunc), partition);
                                        fprintf("%d,%d,%d,%s,%s,%f,%s,%f,FAILED,FAILED\n",i,removeFirst, correlation, method, func2str(redFunc), n, func2str(clasFunc), partition);
                                    end
                                end
                            end
                        end
                   end
                end
            end
        end
    end
    fclose(file);
end

