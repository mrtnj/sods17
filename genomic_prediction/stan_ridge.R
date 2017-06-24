

library(rstan)


model <- stan("ridge.stan",
              data = list(Nindividuals = nrow(training_pheno),
                Nsnps = ncol(training_snps) - 1,
                y = training_pheno$phenoNormUnres1,
                Z = training_snps[, -1]))
