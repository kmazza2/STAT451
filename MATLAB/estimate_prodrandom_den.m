function [x] = estimate_prodrandom_den(i, c, samples)
%ESTIMATE_PRODRANDOM_DEN Estimates density of prodrandom distribution at i.
%   The first argument is the parameter c of the prodrandom distribution.
%   The second argument is the value of the distribution whose density is
%   to be estimated.
%   The third argument is the number of samples to be used in estimating
%   the density.

if c <= 0 || c > 1
    error('c must be in (0,1]');
end

x = mean(prodrandom(c, samples) == i);

end