function dt = scalestd(data)
    dt = data;
    media = mean(data.X,2);
    desvio = std(data.X,[],2);
    media = repmat(media,1,data.num_data);
    desvio = repmat(desvio,1,data.num_data);
    
    z=(data.X-media);
    z = z./desvio;
    dt.X = z;
    dt.y = data.y;
end