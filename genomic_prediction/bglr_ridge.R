
## Bayesian ridge regression, four chains

source("data_preparation.R")

library(BGLR)
library(coda)

n_chains <- 4

system("mkdir bglr_ridge")

bglr_training_pheno <- c(training_pheno$phenoNormUnres1, rep(NA, nrow(testing_pheno)))
bglr_snps <- rbind(training_snps, testing_snps)

bglr_ridge <- vector(mode = "list", length = n_chains)

for (i in 1:n_chains) {
    bglr_ridge[[i]] <- BGLR(y = bglr_training_pheno,
                            ETA = list(list(X = bglr_snps[, -1], model = "BRR")),
                            saveAt = paste("bglr_ridge/run", i, "_", sep = ""),
                            nIter = 10000, burnIn = 500,
                            thin = 1)
}


genetic_variance_all <- lapply(system("ls bglr_ridge/*_varB.dat", intern = TRUE), scan)
chains <- lapply(genetic_variance_all, mcmc)
chains <- mcmc.list(chains)
gelman.diag(chains, autoburnin = FALSE)

ridge_testing_pred <- lapply(bglr_ridge, function(x) predict(x)[2001:3000])
lapply(ridge_testing_pred, function(x) cor(x, testing_pheno$phenoNormUnres1))
lapply(ridge_testing_pred, function(x) cor(x, testing_pheno$bvNormUnres1))


save(bglr_ridge, ridge_testing_pred, file = "bglr_ridge_model.Rdata")
