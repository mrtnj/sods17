
## BayesB with BGLR

source("data_preparation.R")

library(BGLR)
library(coda)

n_chains <- 4

system("mkdir bglr_bayesb")

bglr_training_pheno <- c(training_pheno$phenoNormUnres1, rep(NA, nrow(testing_pheno)))
bglr_snps <- rbind(training_snps, testing_snps)


bglr_bayesb <- vector(mode = "list", length = n_chains)

for (i in 1:n_chains) {
    bglr_bayesb[[i]] <- BGLR(y = bglr_training_pheno,
                             ETA = list(list(X = bglr_snps[, -1], model = "BayesB")),
                             saveAt = paste("bglr_bayesb/run", i, "_", sep = ""),
                             nIter = 10000, burnIn = 500,
                             thin = 1)
}


bayesb_testing_pred <- lapply(bglr_bayesb, function(x) predict(x)[2001:3000])
lapply(bayesb_testing_pred, function(x) cor(x, testing_pheno$phenoNormUnres1))
lapply(bayesb_testing_pred, function(x) cor(x, testing_pheno$bvNormUnres1))



save(bglr_bayesb, bayesb_testing_pred, file = "bglr_bayesb_model.Rdata")
