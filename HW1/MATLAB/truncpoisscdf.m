function [prob] = truncpoisscdf(x,lambda,k)
%TRUNCPOISSCDF Calculates truncated Poisson cdf.
%   TRUNCPOISSCDF(x,lambda,k) computes the cdf of the truncated Poisson
%   distribution (mass is zero for points greater than k) at x. Its value
%   is one for all points greater than or equal to k.
if lambda <= 0
    error('lambda must be greater than 0.')
end
if k < 0
    error('k must be at least 0.')
end
zeromask = x >= 0;
kmask = x < k;
x = zeromask .* (kmask .* x);
cf = cumsum(truncpoisspdf(0:k,lambda,k));
prob = ((cf(floor(x)+1) .* zeromask) .* kmask) + ~kmask;