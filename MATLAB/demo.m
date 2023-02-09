clear
% Problem 1
samples = 1000000;
tic; corr_a_hat = estimate_corr_a(samples); toc;
tic; corr_b_hat = estimate_corr_b(samples); toc;
disp(['Estimate for (a): ' num2str(corr_a_hat)]);
disp(['Estimate for (b): ' num2str(corr_b_hat)]);
clear
% Problem 2
samples = 1000000;
c = exp(-3);
tic; mu_hat = mean(prodrandom(c,samples)); toc;
tic; den0_hat = estimate_prodrandom_den(0, c, samples); toc;
tic; den1_hat = estimate_prodrandom_den(1, c, samples); toc;
tic; den2_hat = estimate_prodrandom_den(2, c, samples); toc;
tic; den3_hat = estimate_prodrandom_den(3, c, samples); toc;
tic; den4_hat = estimate_prodrandom_den(4, c, samples); toc;
tic; den5_hat = estimate_prodrandom_den(5, c, samples); toc;
tic; den6_hat = estimate_prodrandom_den(6, c, samples); toc;
disp(['Estimate of expectation: ' num2str(mu_hat)]);
disp(['Estimate of density at 0: ' num2str(den0_hat)]);
disp(['Estimate of density at 1: ' num2str(den1_hat)]);
disp(['Estimate of density at 2: ' num2str(den2_hat)]);
disp(['Estimate of density at 3: ' num2str(den3_hat)]);
disp(['Estimate of density at 4: ' num2str(den4_hat)]);
disp(['Estimate of density at 5: ' num2str(den5_hat)]);
disp(['Estimate of density at 6: ' num2str(den6_hat)]);
clear
% Problem 3
samples = 1000000;
tic; x = mean(nonhompoiss(10, @(t) (3 + 4/(t+1)), 7, samples)); toc;
disp(['Estimate of expectation: ' num2str(x)]);
clear
% Problem 4
samples = 500;
tic; mu_hat = mean(server_break(samples)); toc;
disp(['Estimate of expectation: ' num2str(mu_hat)]);
clear