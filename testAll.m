function testAll(data)
    reductionFuncs = {@ldaReduceFeatures, @pcaReduceFeatures, @pcaReduceFeatures};
    classifierFuncs = {@fisherLDA, @EuclideanA, @MahalanobisA};
    file = fopen("resultados.txt", 'a');
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
                uncorrelatedData = kwReduceFeatures(setData, correlation);
                
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
                            for partition = [0.25 0.5 0.75]
                                
                                %%execute runs
                                average_error=zeros(n_runs,1);
                                for run = 1:n_runs
                                    [~, error_rate] = clasFunc(reducedData, partition, 1 - partition);
                                    average_error(run) = error_rate;
                                end
                                %%write results to file
                                fprintf(file, "%d,%d,%d,%s,%f,%s,%f,%f,%f\n",i,removeFirst, correlation, func2str(redFunc), n, func2str(clasFunc), partition, mean(average_error), std(average_error));
                                fprintf("%d,%d,%d,%s,%f,%s,%f,%f,%f\n",i,removeFirst, correlation, func2str(redFunc), n, func2str(clasFunc), partition, mean(average_error), std(average_error));
                            end
                        end
                    end
               end
            end
        end
    end
    fclose(file);
end

