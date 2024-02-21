function [pfm] = perform(data, x, L, B)

ssff = L - B * data * x;
ssff = max(ssff, 0);
pfm = mean(ssff);

end

% FS

%{
n = 100000; L = 10100; B = 10000;
tic
[obj, x] = minesf(retm, n, L, B)
toc
[pfm] = perform(retm, x, L, B)
%}

% 1. Performances with limited selectable sample size:

% 1.1. SP

%{
n = 100; L = 10100; B = 10000;
tic
[obj, x] = minesf(retm, n, L, B)
toc
[pfm] = perform(retm, x, L, B)
%}

%{
n = 1000; L = 10100; B = 10000;
tic
[obj, x] = minesf(retm, n, L, B)
toc
[pfm] = perform(retm, x, L, B)
%}

% 1.2. KM

%{
n1 = 100000; n2 = 100; L = 10100; B = 10000;
tic
[J, mu, c] = kmeans2(retm(1:n1, :), n2);
toc
tic
[obj, x] = minesf(mu, n2, L, B)
toc
[pfm] = perform(retm, x, L, B)
%}

%{
n1 = 100000; n2 = 1000; L = 10100; B = 10000;
tic
[J, mu, c] = kmeans2(retm(1:n1, :), n2);
toc
tic
[obj, x] = minesf(mu, n2, L, B)
toc
[pfm] = perform(retm, x, L, B)
%}

% 1.3. AS

%{
n1 = 100000; n2 = 100; L = 10100; B = 10000;
tic
[agg, sam] = aggsam(retm, n1, L/B);
toc
tic
[obj, x] = minesf([agg; sam(randperm(size(sam, 1), n2-1), :)], n2, L, B)
toc
[pfm] = perform(retm, x, L, B)
%}

%{
n1 = 100000; n2 = 1000; L = 10100; B = 10000;
tic
[agg, sam] = aggsam(retm, n1, L/B);
toc
tic
[obj, x] = minesf([agg; sam(randperm(size(sam, 1), n2-1), :)], n2, L, B)
toc
[pfm] = perform(retm, x, L, B)
%}

% 1.4. IR

%{
n1 = 100000; n2 = 100; L = 10100; B = 10000; Lcoef = 0.5;
tic
[itesam, x, v, inperf, outperf] = itered(retm, n2, n1, n2, L, B, Lcoef);
toc
inperf
outperf
tic
[obj, x] = minesf(itesam(randperm(size(itesam, 1), n2), :), n2, L, B)
toc
[pfm] = perform(retm, x, L, B)
%}

%{
n1 = 100000; n2 = 1000; L = 10100; B = 10000; Lcoef = 0.5;
tic
[itesam, x, v, inperf, outperf] = itered(retm, n2, n1, n2, L, B, Lcoef);
toc
inperf
outperf
tic
[obj, x] = minesf(itesam(randperm(size(itesam, 1), n2), :), n2, L, B)
toc
[pfm] = perform(retm, x, L, B)
%}

% 1.5. IS

%{
n1 = 100000; n2 = 100; L = 10100; B = 10000;
[obj, x, obj2] = impsam(retm, n1, n2, L, B)
[pfm] = perform(retm, x, L, B)
%}

%{
n1 = 100000; n2 = 1000; L = 10100; B = 10000;
[obj, x, obj2] = impsam(retm, n1, n2, L, B)
[pfm] = perform(retm, x, L, B)
%}

% 2. Performances with limited accessible sample size:

% 2.1. SP

%{
n = 1000; L = 10100; B = 10000;
tic
[obj, x] = minesf(retm, n, L, B)
toc
[pfm] = perform(retm, x, L, B)
%}

%{
n = 10000; L = 10100; B = 10000;
tic
[obj, x] = minesf(retm, n, L, B)
toc
[pfm] = perform(retm, x, L, B)
%}

% 2.2. KM

%{
n = 1000; p = 0.1; L = 10100; B = 10000;
tic
[J, mu, c] = kmeans2(retm(1:n, :), n*p);
toc
tic
[obj, x] = minesf(mu, n*p, L, B)
toc
[pfm] = perform(retm(1:n, :), x, L, B)
[pfm] = perform(retm, x, L, B)
%}

%{
n = 10000; p = 0.1; L = 10100; B = 10000;
tic
[J, mu, c] = kmeans2(retm(1:n, :), n*p);
toc
tic
[obj, x] = minesf(mu, n*p, L, B)
toc
[pfm] = perform(retm(1:n, :), x, L, B)
[pfm] = perform(retm, x, L, B)
%}

% 2.3. AS

%{
n = 1000; p = 0.1; L = 10100; B = 10000;
tic
[agg, sam] = aggsam(retm, n, L/B);
toc
tic
[obj, x] = minesf([agg; sam], size([agg; sam], 1), L, B)
toc
[pfm] = perform(retm(1:n, :), x, L, B)
[pfm] = perform(retm, x, L, B)
%}

%{
n = 10000; p = 0.1; L = 10100; B = 10000;
tic
[agg, sam] = aggsam(retm, n, L/B);
toc
tic
[obj, x] = minesf([agg; sam], size([agg; sam], 1), L, B)
toc
[pfm] = perform(retm(1:n, :), x, L, B)
[pfm] = perform(retm, x, L, B)
%}

% 2.4. IR

%{
n = 1000; p = 0.1; L = 10100; B = 10000; Lcoef = 0;
tic
[itesam, x, v, inperf, outperf] = itered(retm, n*p, n, n, L, B, Lcoef);
toc
inperf
outperf
tic
[obj, x] = minesf(itesam, size(itesam, 1), L, B)
toc
[pfm] = perform(retm(1:n, :), x, L, B)
[pfm] = perform(retm, x, L, B)
%}

%{
n = 10000; p = 0.1; L = 10100; B = 10000; Lcoef = 0;
tic
[itesam, x, v, inperf, outperf] = itered(retm, n*p, n, n, L, B, Lcoef);
toc
inperf
outperf
tic
[obj, x] = minesf(itesam, size(itesam, 1), L, B)
toc
[pfm] = perform(retm(1:n, :), x, L, B)
[pfm] = perform(retm, x, L, B)
%}

% 2.5. IS

%{
n = 1000; p = 0.1; L = 10100; B = 10000;
[obj, x] = impsam(retm, n, n*p, L, B)
[pfm] = perform(retm(1:n, :), x, L, B)
[pfm] = perform(retm, x, L, B)
%}

%{
n = 10000; p = 0.1; L = 10100; B = 10000;
[obj, x] = impsam(retm, n, n*p, L, B)
[pfm] = perform(retm(1:n, :), x, L, B)
[pfm] = perform(retm, x, L, B)
%}
