function [prob] = truncbinomcdf(x,n,p,k)
%TRUNCBINOMCDF Calculates truncated Binomial cdf.
%   TRUNCBINOMCDF(x,n,p,k) computes the cdf of the truncated Binomial
%   distribution (mass is zero for points less than k) at x. Its value
%   is one for all points greater than or equal to n.
if n < 1
    error('n must be at least 1.')
end
if k > n
    error('k cannot be larger than n.')
end
kmask = x >= k;
nmask = x <= n;
x = floor(kmask .* (nmask .* x)) + k*(~kmask) + n*(~nmask) - (k-1);
cf = cumsum(truncbinompdf(k:n,n,p,k));
prob = cf(x) .* kmask;