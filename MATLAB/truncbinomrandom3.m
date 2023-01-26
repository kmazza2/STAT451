function [x] = truncbinomrandom3(n,p,k,varargin)
%TRUNCBINOMRANDOM3 Randomly samples truncated Binomial distribution.
%   TRUNCBINOMRANDOM3(n,p,k,varargin) returns a random sample from the truncated
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
% Bernoulli trials begin
x = zeros(1,m);
for i = 1:m
    while true
        y = sum(rand(1,n) < p);
        if y >= k
            x(i) = y;
            break;
        end
    end
end
% Bernoulli trials end
if nargin > 4
    x = reshape(x,varargin);
end
