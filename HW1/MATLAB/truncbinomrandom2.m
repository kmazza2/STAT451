function [x] = truncbinomrandom2(n,p,k,varargin)
%TRUNCBINOMRANDOM2 Randomly samples truncated Binomial distribution.
%   TRUNCBINOMRANDOM2(n,p,k,varargin) returns a random sample from the truncated
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
% rejection sampling begin
x = zeros(1,m);
c = n - k + 1;
for i = 1:m
    while true
        y = unidrnd(n-k+1) + (k-1);
        u = rand();
        if u < truncbinompdf(y,n,p,k) * (n-k+1) / c
            x(i) = y;
            break;
        end
    end
end
% rejection sampling end
if nargin > 4
    x = reshape(x,varargin);
end