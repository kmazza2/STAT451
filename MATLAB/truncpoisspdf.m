function [mass] = truncpoisspdf(x,lambda,k)
%TRUNCPOISSPDF Calculates truncated Poisson pmf.
%   TRUNCPOISSPDF(x,lambda,k) calculates the mass of the truncated
%   Poisson distribution (mass is zero for points greater than k) at x.
if lambda <= 0
    error('lambda must be greater than 0.')
end
if k < 0
    error('k must be at least 0.')
end
mask = isfloat(x) * ((x >= 0) .* (x <= k) .* (round(x) - x == zeros(1, length(x))));
x = mask .* double(x);
num = (lambda .^ x) ./ double(factorial(x));
p = 1.0 ./ factorial(k:-1:0);
denom = polyval(p,lambda);
mass = (num / denom) .* mask;