function [raw] = getRaw(prefix,suffix)
    raw = [];
    for i = 0:50
        if i ~= 14
            filename = sprintf("%s%02d%s",prefix, i, suffix);
            fprintf("loading %s\n", filename);
            new_raw = importdata(filename);
            new_raw.label = new_raw.textdata(3:93);
            new_raw.textdata = new_raw.textdata(96:end);
            new_raw.data = new_raw.data(:,1:end-1);
            raw = [raw; new_raw];
        end
    end
end

