
## Prediction with BART and the bartMachine package.

source("data_preparation.R")

options(java.parameters = "-Xmx8g")

library(bartMachine)

bart <- bartMachine(training_snps[, -1], training_pheno$phenoNormUnres1,
                    k = 4, q = 0.9, num_trees = 200)

##check_bart_error_assumptions(bart)
##plot_convergence_diagnostics(bart)

bart_testing_pred <- predict(bart, new_data = testing_snps[, -1])

cor(bart_testing_pred, testing_pheno$phenoNormUnres1)
cor(bart_testing_pred, testing_pheno$bvNormUnres1)


save(bart, bart_testing_pred, file = "bart_model.Rdata")
