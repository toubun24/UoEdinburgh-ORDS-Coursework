function [obj, x, obj2] = impsam(data0, M, N, L, B)

tic
% step b
data = data0(1:M, :);
cvx_clear;
[C, x0] = minesf(data, M, L, B);
Cd = L - B * data * x0;
% step c
for i = 1:M
    if Cd(i) < 0
        Cd(i) = Cd(i) / 1000;
    end
end
Cd = (Cd - min(Cd)) / (max(Cd) - min(Cd));
sumCd = sum(Cd);
pickprob = Cd / sumCd;
rng(2032451);
index = randsrc(N, 1, [1:M; pickprob']);
Omegas = data(index, :);
% step d
pis = 1 ./ Cd;
pis = pis(index);
toc
% sp
cvx_clear;
tic
[obj, x] = minesf2(Omegas, N, L, B, pis);
toc
obj2 = perform(Omegas, x, L, B);

end

% [obj, x, obj2] = impsam(retm, 1000, 100, 10100, 10000)