function [x] = server_break(varargin)
%SERVER_BREAK Calculate expectation of single server queue in HW 2 Problem 4.
%   SERVER_BREAK begins with the server on break.

    function [x] = rand_service()
        x = exprnd(1/25);
    end

    function [x] = rand_break()
        x = 0.3 * rand();
    end

    function intensity = intensity_function(t)
        while t >= 10
            t = t - 10;
        end
        if t <= 5
            intensity = 3 * t + 4;
        else
            intensity = -3 * t + 34;
        end
    end

    function time = rand_interarrival(t)
        time = exprnd(1/intensity_function(t));
    end

if nargin == 0
    varargin = num2cell(1);
end

varargin = cell2mat(varargin);
m = prod(varargin);

x = zeros(m,1);


for i = 1:m
    x(i) = server_break1(@(t) rand_interarrival(t), @() rand_service(), @() rand_break(), 100);
end

if nargin > 1
    x = reshape(x,varargin);
end
end