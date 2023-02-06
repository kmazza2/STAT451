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