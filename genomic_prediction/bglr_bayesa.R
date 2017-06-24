
## BayesA

source("data_preparation.R")

library(BGLR)

system("mkdir bglr_bayesa")

bglr_training_pheno <- c(training_pheno$phenoNormUnres1, rep(NA, nrow(testing_pheno)))
bglr_snps <- rbind(training_snps, testing_snps)

bglr_bayesa <- BGLR(y = bglr_training_pheno,
                    ETA = list(list(X = bglr_snps[, -1], model = "BayesA")),
                    saveAt = paste("bglr_bayesa/", sep = ""),
                    nIter = 1000, burnIn = 500,
                    thin = 1)


bayesa_testing_pred <- predict(bglr_bayesa)[2001:3000]

cor(bayesa_testing_pred, testing_pheno$phenoNormUnres1)
cor(bayesa_testing_pred, testing_pheno$bvNormUnres1)


save(blgr_bayesa, bayesa_testing_pred, file = "blgr_bayesa_model.Rdata")
