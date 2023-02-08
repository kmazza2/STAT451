function tests = test
tests = functiontests(localfunctions);
end

function test_corr_a(testCase)
corr_hat = estimate_corr_a(1000000);
verifyEqual(testCase, corr_hat, -0.05, "AbsTol", 0.02);
end

function test_corr_b(testCase)
corr_hat = estimate_corr_b(1000000);
verifyEqual(testCase, corr_hat, -0.06, "AbsTol", 0.02);
end

function test_prodrandom(testCase)
mu_hat = mean(prodrandom(exp(-3),1000000));
verifyEqual(testCase, mu_hat, 3, "AbsTol", 0.5);
end

function test_estimate_prodrandom_den(testCase)
samples = 1000000;
den0 = estimate_prodrandom_den(0, exp(-3), samples);
den1 = estimate_prodrandom_den(1, exp(-3), samples);
den2 = estimate_prodrandom_den(2, exp(-3), samples);
den3 = estimate_prodrandom_den(3, exp(-3), samples);
den4 = estimate_prodrandom_den(4, exp(-3), samples);
den5 = estimate_prodrandom_den(5, exp(-3), samples);
den6 = estimate_prodrandom_den(6, exp(-3), samples);
verifyEqual(testCase, den0, 0.050005, "AbsTol", 0.01);
verifyEqual(testCase, den1, 0.149539, "AbsTol", 0.01);
verifyEqual(testCase, den2, 0.224508, "AbsTol", 0.01);
verifyEqual(testCase, den3, 0.223615, "AbsTol", 0.01);
verifyEqual(testCase, den4, 0.167357, "AbsTol", 0.01);
verifyEqual(testCase, den5, 0.101147, "AbsTol", 0.01);
verifyEqual(testCase, den6, 0.05046, "AbsTol", 0.01);
end

function test_nonhompoiss(testCase)
samples = 1000000;
sample = nonhompoiss(1, @(x) 23, 23, samples);
mu_hat = mean(sample);
sigma_sq_hat = var(sample);
verifyEqual(testCase, mu_hat, 23, "AbsTol", 0.03);
verifyEqual(testCase, sigma_sq_hat, 23, "AbsTol", 0.1);
end

function test_serverbreak(testCase)

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

% x = linspace(0,100,1000000);
% y = arrayfun(@(x) intensity_function(x), x);
% subplot(1,2,1);
% plot(x,y);
% 
% t = 0;
% z = zeros(1000,1);
% for i = 1:1000
%     t = t + rand_interarrival(t);
%     z(i) = t;
% end
% 
% subplot(1,2,2);
% scatter(z,0.005*rand(1000,1)+zeros(1000,1));
% xlim([-10 110]);
% ylim([-0.1 0.1]);

simulation = arrayfun( ...
    @(x) server_break( ...
    @(t) rand_interarrival(t), ...
    @() rand_service(), ...
    @() rand_break(), ...
    100) ...
    , 1:500 ...
    );
mu_hat = mean(simulation);
verifyGreaterThan(testCase, mu_hat, 0);
verifyLessThan(testCase, mu_hat, 100);

% disp('');
% disp('Expected number of hours on break:');
% disp(mu_hat);

end