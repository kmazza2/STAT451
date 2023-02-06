function [x] = nonhompoiss(T, intensity, lambda, varargin)
%NONHOMPOISS Simulate nonhomogeneous Poisson process.
%   T is the time to simulate the process until, intensity is a function,
%   lambda is an upper bound on intensity.

if nargin == 0
    varargin = num2cell(1);
end

varargin = cell2mat(varargin);
m = prod(varargin);

div = 1/lambda;
x = zeros(m,1);

for i=1:m
    t = 0;
    while true
        u = rand(2,1);
        t = t - div * log(u(1));
        if t > T
            break;
        end
        if u(2) <= intensity(t)*div
            x(i) = x(i) + 1;
        end
    end
end

if nargin > 4
    x = reshape(x,varargin);
end

end