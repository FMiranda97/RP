function [C] = corr(data)
%%display correlation
    C=abs(corrcoef(data.X'));
%     xvalues = cell(size(data.X,1),1);
%     for i = 1:size(data.X,1)
%         xvalues{i} = data.label(i);
%     end
%     %%%
%     yvalues = xvalues;
%     figure();
%     heatmap(xvalues,yvalues,C); 
%     title(data.name);
end