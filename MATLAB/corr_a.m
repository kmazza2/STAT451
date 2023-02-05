samples = 100000;

corr_hat_a = estimate_corr_a(samples);

disp(corr_hat_a);



function corr_hat = estimate_corr_a(samples)
    mu_hat_prod_a = estimate_mu_prod_a(samples);
    mu_hat_fac1_a = estimate_mu_fac1_a(samples);
    mu_hat_fac2_a = estimate_mu_fac2_a(samples);
    corr_hat = mu_hat_prod_a - mu_hat_fac1_a * mu_hat_fac2_a;
end

function mu_hat = estimate_mu_prod_a(samples)
    u = rand(samples, 1);
    prod = u .* sqrt(1 - u .^ 2);
    mu_hat = mean(prod);
end

function mu_hat = estimate_mu_fac1_a(samples)
    u = rand(samples, 1);
    mu_hat = mean(u);
end

function mu_hat = estimate_mu_fac2_a(samples)
    u = rand(samples, 1);
    mu_hat = mean(sqrt(1 - u .^ 2));
end