function  [rank, I] = kwRank(data)

    rank = cell(data.dim,2);

    % for each feature
    for i=1:size(data.X,1)
        % atab is the anova table

        [p, atab, stats] = kruskalwallis(data.X(i,:), data.y, 'off');
        rank{i,1} = data.label(i);
        rank{i,2} = atab{2,5};
    end

    % feature ranking
    [Y,I] = sort([rank{:,2}],2,'descend');
    % get a string with the rankings
    sorted = rank;
    for i=1:data.dim
        sorted{i,1} = rank{I(i),1};
        sorted{i,2} = rank{I(i),2};
    end
    rank = sorted;
end
