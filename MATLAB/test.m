function tests = test
tests = functiontests(localfunctions);
end

function test_corr_a(testCase)
corr_hat = estimate_corr_a(1000000);
verifyGreaterThan(testCase, corr_hat, -0.07);
verifyLessThan(testCase, corr_hat, -0.03);
end