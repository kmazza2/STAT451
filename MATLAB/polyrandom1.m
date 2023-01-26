function [x] = polyrandom1(varargin)
%POLYRANDOM1 Randomly samples from pdf 30*(x^2-2*x^3+x^4) on [0,1].
%   POLYRANDOM1(varargin) returns a random sample from the distribution with
%   pdf 30*(x^2-2*x^3+x^4) on [0,1]; the result is a matrix of numbers
%   between 0 and 1 inclusive.
if nargin == 0
    varargin = num2cell(1);
end
varargin = cell2mat(varargin);
n = prod(varargin);
% inverse transform begin
x = zeros(1,n);
for i = 1:n
    u = rand();
    y = fzero(@(x) 10*x^3 - 15*x^4 + 6*x^5 - u, 0.5);
    x(i) = y;
end
% inverse transform end
if nargin > 1
    x = reshape(x,varargin);
end