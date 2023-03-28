global A b;

warning("off");

pkg load optim;

A = dlmread('/Users/kevin/Desktop/A.txt');
b = dlmread('/Users/kevin/Desktop/b.txt');

x0 = ones(1,13);
A2 = [];
b2 = [];
Aeq = [];
beq = [];
lb = [0 0 0 0 0 0 0 0 0 0 -Inf -Inf -Inf];
ub = [Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf];



function result = la(x)
result = x(1:10);
end

function result = nu(x)
result = x(11:13);
end


function result = x_star(x)
global A;
nu_arr = nu(x);
la_arr = la(x);
result = zeros(1,10);
for i = 1:10
    sum = 0;
    for j = 1:3
        sum = sum + nu_arr(j)*A(j,i);
    end
    result(i) = exp(-1 + la_arr(i) - sum);
end

end

function y = obj(x)
global A b;

y = -( ...
    x_star(x) * log(x_star(x))' - ...
    la(x) * x_star(x)' + ...
    nu(x) * (A * x_star(x)' - b') ...
    );

end

result = fmincon(@obj, x0, A2, b2, Aeq, beq, lb, ub);

fprintf('%s',sprintf('%.16f ',result));
