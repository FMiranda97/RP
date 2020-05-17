function  [rank, I] = aucRank(data)
    rank = cell(data.dim,2);
    for i = 1:data.dim
        [FPR, FNR] = roc(data.X(i,:), data.y);
        rank{i,1}=data.label(i);

        SS=1-FNR;
        SP=1-FPR;

        AUC = 0;
        for j=2:numel(FPR)
           AUC = AUC+ SS(j)*(FPR(j-1)-FPR(j));
        end
        rank{i,2} = AUC;
    end
    [~,I] = sort([rank{:,2}],2,'descend');
    sorted = rank;
    for i=1:data.dim
        sorted{i,1} = rank{I(i),1};
        sorted{i,2} = rank{I(i),2};
    end
    rank = sorted;
end
