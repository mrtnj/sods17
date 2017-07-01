
## BayesA

source("data_preparation.R")

library(BGLR)

system("mkdir bglr_bayesb")

bglr_training_pheno <- c(training_pheno$phenoNormUnres1, rep(NA, nrow(testing_pheno)))
bglr_snps <- rbind(training_snps, testing_snps)

bglr_bayesb <- BGLR(y = bglr_training_pheno,
                    ETA = list(list(X = bglr_snps[, -1], model = "BayesB")),
                    saveAt = paste("bglr_bayesb/", sep = ""),
                    nIter = 10000, burnIn = 500,
                    thin = 1)


bayesb_testing_pred <- predict(bglr_bayesb)[2001:3000]

cor(bayesb_testing_pred, testing_pheno$phenoNormUnres1)
cor(bayesb_testing_pred, testing_pheno$bvNormUnres1)


save(bglr_bayesb, bayesb_testing_pred, file = "bglr_bayesb_model.Rdata")
