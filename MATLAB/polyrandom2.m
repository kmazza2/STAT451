function [x] = polyrandom2(varargin)
%POLYRANDOM2 Randomly samples from pdf 30*(x^2-2*x^3+x^4) on [0,1].
%   POLYRANDOM2(varargin) returns a random sample from the distribution with
%   pdf 30*(x^2-2*x^3+x^4) on [0,1]; the result is a matrix of numbers
%   between 0 and 1 inclusive.
if nargin == 0
    varargin = num2cell(1);
end
varargin = cell2mat(varargin);
n = prod(varargin);
% rejection sampling begin
x = zeros(1,n);
for i = 1:n
    while true
        y = rand();
        u = rand();
        if u < 8 * 30*(y^2 - 2 * y^3 + y^4) / 15
            x(i) = y;
            break;
        end
    end
end
% rejection sampling end
if nargin > 1
    x = reshape(x,varargin);
end