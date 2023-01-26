function [x] = truncpoissrandom2(lambda,k,varargin)
%TRUNCPOISSRANDOM2 Randomly samples truncated Poisson distribution.
%   TRUNCPOISSRANDOM2(lambda,k,varargin) returns a random sample from the truncated
%   (at k) Poisson distribution; the result is a matrix of numbers between
%   0 and k inclusive.
if lambda <= 0
    error('lambda must be greater than 0.')
end
if k < 0
    error('k must be at least 0.')
end
if nargin == 2
    varargin = num2cell(1);
end
varargin = cell2mat(varargin);
n = prod(varargin);
% rejection sampling begin
x = zeros(1,n);
for i = 1:n
    while true
        y = unidrnd(k);
        u = rand();
        if u < truncpoisspdf(y,lambda,k)
            x(i) = y;
            break;
        end
    end
end
% rejection sampling end
if nargin > 3
    x = reshape(x,varargin);
end