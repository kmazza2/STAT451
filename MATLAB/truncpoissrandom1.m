function [x] = truncpoissrandom1(lambda,k,varargin)
%TRUNCPOISSRANDOM1 Randomly samples truncated Poisson distribution.
%   TRUNCPOISSRANDOM1(lambda,k,varargin) returns a random sample from the truncated
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
% discrete inverse transform begin
u = rand(1,n);
cf = truncpoisscdf(0:k,lambda,k);
x = zeros(1,n);
for i = 1:n
    mask = u(i) < cf;
    x(i) = find(mask,1) - 1;
end
% discrete inverse transform end
if nargin > 3
    x = reshape(x,varargin);
end