function [itesam, x, v, inperf, outperf] = itered(data0, M, N, M2, L, B, Lcoef)

stepleng = 0.5; % as recommended
data = data0(1:N, :);
inperf = 0;
outperf = 0;
% step 1 (initialization)
b = 2; % as recommended
v = 1;
numN = 0;
rng(2032451);
Nas = data(randperm(N, M), :);
while true
    % step 2 (sequential procedure)
    L2 = L - (L - B) * Lcoef;
    [obj, x] = minesf(Nas, M, L2, B);
    inperf = [inperf, obj];
    outperf = [outperf, perform(data0, x, L, B)];
    sfM = L2 - B * Nas * x;
    sfN = L2 - B * data * x;
    [sfodM, sfidM] = sort(sfM);
    [sfodN, sfidN] = sort(sfN);
    for i = 1 : M
        if sfodM(i) > 0
            numM = M - i + 1;
            threscen = Nas(sfidM(i), :);
            break;
        end
    end
    for i = 1 : N
        if N - i + 1 > numN(end) && all(threscen == data(sfidN(i), :))
            progress = true;
            numN = [numN, N - i + 1];
            break;
        else
            progress = false;
        end
    end
    % step 3 (convergence checking)
    if (numM / M == numN(end) / N && v > 1 && M >= M2) || (M == N && M >= M2) || M >= 2 * M2
        % step 5 (output)
        itesam = data(sfidN(N-numN(end)+1):sfidN(end), :);
        break;
    else
        if progress == false
            b = b + stepleng;
        end
        % step 4 (update the subset of active scenarios)
        v = v + 1;
        Nas = data(sfidN(max((end-ceil(b*numN(end))+1),1):end), :);
        M = size(Nas, 1);
    end
end
end

% [itesam, x, v] = itered(retm, 100, 1000, 10100, 10000, 0.5)