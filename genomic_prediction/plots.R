
source("data_preparation.R")

## Prediction plots

load("bglr_ridge_model.Rdata")
par(mfrow = c(1, 2))
plot(testing_pheno$phenoNormUnres1, ridge_testing_pred[[1]], pch = ".", xlab = "Phenotype", ylab = "Prediction")
plot(testing_pheno$bvNormUnres1, ridge_testing_pred[[1]], pch = ".", xlab = "Breeding value", ylab = "Prediction")


## MCMC plots

genetic_variance <- scan("bglr_ridge/run1_ETA_1_varB.dat")
intercept <- scan("bglr_ridge/run1_mu.dat")
par(mfrow = c(1, 2))
plot(genetic_variance, pch = ".")
plot(intercept, pch = ".")
