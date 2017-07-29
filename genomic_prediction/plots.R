
library(coda)

source("data_preparation.R")

## Prediction plots

load("bglr_ridge_model.Rdata")
par(mfrow = c(1, 2))
plot(testing_pheno$phenoNormUnres1, ridge_testing_pred[[1]], pch = ".", xlab = "Phenotype", ylab = "Prediction")
plot(testing_pheno$bvNormUnres1, ridge_testing_pred[[1]], pch = ".", xlab = "Breeding value", ylab = "Prediction")


## MCMC plots
marker_variance_all <- lapply(system("ls bglr_ridge/*_varB.dat", intern = TRUE), scan)
ridge_chains <- lapply(marker_variance_all, mcmc)
ridge_chains <- mcmc.list(ridge_chains)
gelman.diag(ridge_chains, autoburnin = FALSE)
traceplot(ridge_chains, col = c("black", "red", "blue", "orange"), main = "Trace of marker variance")

parameters_all <- lapply(system("ls bglr_bayesb/run*_parBayesB.dat", intern = TRUE), read.table, head = TRUE)
bayesb_chains <- lapply(parameters_all, mcmc)
bayesb_chains <- mcmc.list(bayesb_chains)
gelman.diag(bayesb_chains, autoburnin = FALSE)
plot(bayesb_chains, col = c("black", "red", "blue", "orange"), main = "Trace of marker variance")
