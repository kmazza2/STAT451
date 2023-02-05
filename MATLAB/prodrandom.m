function [x] = prodrandom(c, varargin)
%PRODRANDOM Randomly samples from  max {n: U1...Un >= c}, where Ui are iid.
%   The result is a matrix of nonnegative integers.

if c <= 0 || c > 1
    error('c must be in (0,1]');
end

if nargin == 0
    varargin = num2cell(1);
end

varargin = cell2mat(varargin);
m = prod(varargin);

x = zeros(m,1);
for i = 1:m
    n = -1;
    product = 1;
    while product >= c
        n = n + 1;
        product = product * rand();
    end
    x(i) = n;
end

if nargin > 2
    x = reshape(x,varargin);
end

end