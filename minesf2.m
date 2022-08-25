function [obj, x] = minesf2(Omegas, N, L, B, pis)

cvx_clear;
n = size(Omegas, 2);
cvx_begin quiet
    variables x(n) ssff(N)
    minimize( sum(ssff) / N )
    subject to
        ssff >= (L - B * Omegas * x) .* pis
        ssff >= 0
        sum(x) == 1
        x >= 0
cvx_end;
obj = cvx_optval;

end