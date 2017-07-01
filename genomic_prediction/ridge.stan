data {
    int Nindividuals;
    int Nsnps;
    real y[Nindividuals];
    matrix[Nindividuals, Nsnps] Z;
}
parameters {
    real mu;
    vector[Nsnps] u;
    real<lower = 0> sigma;
    real<lower = 0> sigma_snp;
}
model {
    u ~ normal(0, sigma_snp);
    y ~ normal(mu + Z * u, sigma);
    sigma ~ cauchy(0,2);
    sigma_snp ~ cauchy(0,2);
}
