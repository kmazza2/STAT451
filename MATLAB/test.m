function tests = test
tests = functiontests(localfunctions);
end

function test_polyrandom1(testCase)
r1 = polyrandom1(100000);
verifyGreaterThan(testCase,sum(r1 > 0.4 & r1 < 0.6), 30000);
verifyLessThan(testCase,sum(r1 > 0.4 & r1 < 0.6), 50000);
verifyLessThan(testCase,abs(mean(r1) - 0.5),0.01);
end

function test_polyrandom2(testCase)
r2 = polyrandom2(100000);
verifyGreaterThan(testCase,sum(r2 > 0.4 & r2 < 0.6), 30000);
verifyLessThan(testCase,sum(r2 > 0.4 & r2 < 0.6), 50000);
verifyLessThan(testCase,abs(mean(r2) - 0.5),0.01);
end

function test_all(testCase)
r1 = polyrandom1(100000);
r2 = polyrandom2(100000);
verifyLessThan(testCase, abs(sum(r1 > 0.4 & r1 < 0.6) - sum(r2 > 0.4 & r2 < 0.6)), 1000);
end