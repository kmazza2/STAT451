function tests = test
tests = functiontests(localfunctions);
end

function test_corr_a(testCase)
corr_hat = estimate_corr_a(1000000);
verifyGreaterThan(testCase, corr_hat, -0.07);
verifyLessThan(testCase, corr_hat, -0.03);
end

function test_corr_b(testCase)
corr_hat = estimate_corr_b(1000000);
verifyGreaterThan(testCase, corr_hat, -0.08);
verifyLessThan(testCase, corr_hat, -0.04);
end

function test_prodrandom(testCase)
mu_hat = mean(prodrandom(exp(-3),1000000));
verifyGreaterThan(testCase, mu_hat, 2.5);
verifyLessThan(testCase, mu_hat, 3.5);
end