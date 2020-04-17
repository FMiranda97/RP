function [data] = getData()
    raw = [];
    for i = 1:4
        if i < 3 gadget = "phone"; else gadget = "watch"; end
        if rem(i,2) == 1 sensor = "accel"; else sensor = "gyro"; end
        prefix = sprintf("wisdm-dataset/arff_files/%s/%s/data_16", gadget, sensor);
        suffix = sprintf("_%s_%s.arff",sensor,gadget);
        raw = getRaw(prefix, suffix);
        for j = 1:91
            raw(1).label{j} = sscanf(raw(1).label{j}, '@attribute "%s"');
            raw(1).label{j} = raw(1).label{j}(1:end-1);
        end
        data(i).X = [];
        data(i).y = [];
        for k = 1:size(raw,1)
            data(i).X = [data(i).X; raw(k).data];
            data(i).y = [data(i).y; (char(raw(k).textdata)-char('A')+1)];
        end
        data(i).X = data(i).X';
        data(i).y = data(i).y;
        data(i).label = string(raw(1).label)';
        data(i).dim=size(data(i).X,1); 
        data(i).num_data=size(data(i).X,2); 
        data(i).name = sprintf("%s-%s", gadget, sensor);
    end
end

