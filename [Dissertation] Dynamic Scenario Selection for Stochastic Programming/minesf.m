function [obj, x] = minesf(data0, s, L, B)

cvx_clear;
data = data0(1:s, :);
n = size(data, 2);
cvx_begin quiet
    variables x(n) ssff(s)
    minimize( sum(ssff) / s )
    subject to
        ssff >= L - B * data * x
        ssff >= 0
        sum(x) == 1
        x >= 0
cvx_end;
obj = cvx_optval;
