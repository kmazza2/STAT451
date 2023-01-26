function [mass] = truncbinompdf(x,n,p,k)
%TRUNCBINOMPDF Calculates truncated Binomial pmf.
%   TRUNCBINOMPDF(x,n,p,k) calculates the mass of the truncated
%   Binomial distribution (mass is zero for points less than k) at x.
if n < 1
    error('n must be at least 1.')
end
if k > n
    error('k cannot be larger than n.')
end
mask = isfloat(x) * ((x >= k) .* (x <= n) .* (round(x) - x == zeros(1, length(x))));
x = mask .* double(x);
coeff = arrayfun(@(x) nchoosek(n,x),x);
num = coeff .* (p .^ x) .* ((1-p) .^ (n-x));
denom = sum( ...
    arrayfun(@(x) nchoosek(n,x), (k:n)) .* ...
    (p .^ (k:n)) .* ...
    ((1-p) .^ (n-(k:n))) ...
);
mass = (num ./ denom) .* mask;