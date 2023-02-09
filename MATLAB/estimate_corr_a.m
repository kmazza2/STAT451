function corr_hat = estimate_corr_a(samples)
%ESTIMATE_CORR_A Estimates the correlation coefficient of U, Sqrt(1-U^2).
%   Expectations are estimated by sample means.
    mu_hat_prod = estimate_mu_prod(samples);
    mu_hat_fac1 = estimate_mu_fac1(samples);
    mu_hat_sq_fac1 = estimate_mu_sq_fac1(samples);
    mu_hat_fac2 = estimate_mu_fac2(samples);
    corr_hat = (mu_hat_prod - mu_hat_fac1 * mu_hat_fac2) / ...
        sqrt( ...
            (mu_hat_sq_fac1 - (mu_hat_fac1)^2) * ...
            (1-mu_hat_sq_fac1-(mu_hat_fac2)^2) ...
        );
end

function mu_hat = estimate_mu_prod(samples)
    u = rand(samples, 1);
    prod = u .* sqrt(1 - u .^ 2);
    mu_hat = mean(prod);
end

function mu_hat = estimate_mu_fac1(samples)
    u = rand(samples, 1);
    mu_hat = mean(u);
end

function mu_hat = estimate_mu_sq_fac1(samples)
    u = rand(samples, 1);
    mu_hat = mean(u .* u);
end

function mu_hat = estimate_mu_fac2(samples)
    u = rand(samples, 1);
    mu_hat = mean(sqrt(1 - u .^ 2));
end