source("data_preparation.R")

## Fit two animal models for pedigree-based prediction


## pedigree package

library(pedigree)

blup_ped <- rbind(training_pheno[, c("Indiv", "Father", "Mother", "phenoNormUnres1")],
                  transform(testing_pheno[, c("Indiv", "Father", "Mother")],
                            phenoNormUnres1 = NA))

blup <- blup(phenoNormUnres1 ~ 1, ped = blup_ped, alpha = 0.5)

blup_testing_pred <- blup[2002:3001,]

cor(blup_testing_pred, testing_pheno$phenoNormUnres1)
cor(blup_testing_pred, testing_pheno$bvNormUnres1)



## MCMCglmm

library(MCMCglmm)

glmm_ped <- read.table("SimulatedData/PedigreeAndGeneticValues.txt", header = TRUE)
glmm_ped$phenoNormUnres1[which(glmm_ped$Generation == 4)] <- NA
glmm_ped <- glmm_ped[, c("Indiv", "Mother", "Father")]
glmm_ped$Mother[which(glmm_ped$Mother == 0)] <- NA
glmm_ped$Father[which(glmm_ped$Father == 0)] <- NA

glmm_data <- blup_ped[, c("Indiv", "phenoNormUnres1")]
colnames(glmm_data)[1] <- "animal"


model <- MCMCglmm(fixed = phenoNormUnres1 ~ 1, random = ~ animal, pedigree = glmm_ped, data = glmm_data, pr = TRUE)

glmm_testing_pred <- colMeans(model$Sol)[3002:4001]

cor(glmm_testing_pred, testing_pheno$phenoNormUnres1)
cor(glmm_testing_pred, testing_pheno$bvNormUnres1)
