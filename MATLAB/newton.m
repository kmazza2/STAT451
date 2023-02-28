function [x, iter] = newton(f, fp, p0, tol, n)
%NEWTON Use Newton's method to find zero of function f with derivative fp.
%   Initial guess is p0, tolerance is tol, max iterations is n.
for i = 1:n
    p1 = p0 - f(p0)/fp(p0);
    if abs(p1-p0) < tol
        x = p1;
        iter = i;
        return;
    end
    p0 = p1;
end
error('Failed to converge');
end