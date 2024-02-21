function [agg, sam] = aggsam(data0, M, coef)

data = data0(1:M, :);
S = data / coef - 1;
S = max(data, 0);
projnorm = zeros(M, 1);
for i = 1 : M
    projnorm(i, 1) = norm(S(i, :));
end
[S2, indexS] = sort(projnorm);
colnum = size(data, 2);
aggnum = floor(M / 2);
samnum = 0;
agg = zeros(1, colnum);
sam = zeros(M - aggnum, colnum);
for i = 1 : M
    if(indexS(i) <= aggnum)
        agg = agg + data(i, :);
    else
        samnum = samnum + 1;
        sam(samnum, :) = data(i, :);
    end
end
agg = agg / aggnum;
