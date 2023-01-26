function [x] = truncbinomrandom1(n,p,k,varargin)
%TRUNCBINOMRANDOM1 Randomly samples truncated Binomial distribution.
%   TRUNCBINOMRANDOM1(n,p,k,varargin) returns a random sample from the truncated
%   (below k) Binomial(n,p) distribution; the result is a matrix of numbers between
%   k and n inclusive.
if n < 1
    error('n must be at least 1.')
end
if k > n
    error('k cannot be larger than n.')
end
if nargin == 3
    varargin = num2cell(1);
end
varargin = cell2mat(varargin);
m = prod(varargin);
% discrete inverse transform begin
u = rand(1,m);
cf = truncbinomcdf(k:n,n,p,k);
x = zeros(1,m);
for i = 1:m
    mask = u(i) < cf;
    x(i) = find(mask,1) + (k - 1);
end
% discrete inverse transform end
if nargin > 4
    x = reshape(x,varargin);
end