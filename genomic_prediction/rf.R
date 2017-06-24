
## Random forest regression


source("data_preparation.R")

library(randomForest)


rf <- randomForest(y = training_pheno$phenoNormUnres1, x = training_snps[, -1])


rf_testing_pred <- predict(rf, newdata = testing_snps)

cor(rf_testing_pred, testing_pheno$phenoNormUnres1)
cor(rf_testing_pred, testing_pheno$bvNormUnres1)


save(rf, rf_testing_pred, file = "rf_model.R")
