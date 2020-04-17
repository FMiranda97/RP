    
    clc
    clear all
    close all
    filename = 'data.mat';
    
    if isfile(filename)
        load(filename);
    else
        data = getData();
        save data;
    end

    %%normalize data
    for i = 1:4
       data(i) = scalestd(data(i)); 
    end

    
    data_binary = data;
    for i = 1:4
       %set data to binary problem (scenario A) 
       %Jogging wil be set to 2,
       %everything else will be set to 1
       for j = 1:size(data_binary(i).y)
          if data_binary(i).y(j) ~= 2, data_binary(i).y(j) = 1; end
       end
    end

%%
testAll(data_binary);