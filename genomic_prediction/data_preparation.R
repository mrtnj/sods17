
## Set up training and testing from simulated data

snps_raw <- read.table("SimulatedData/Chip1Genotype.txt")
pheno <- read.table("SimulatedData/PedigreeAndGeneticValues.txt", header = TRUE)

## Centre SNPs
p <- colSums(snps_raw[,-1])/nrow(snps_raw)
P <- matrix(rep(p, nrow(snps_raw)), ncol = ncol(snps_raw) - 1, nrow = nrow(snps_raw), byrow = TRUE)
snps <- snps_raw
snps[,-1] <- snps_raw[,-1] - P

training_pheno <- subset(pheno, Generation %in% 2:3)
testing_pheno <- subset(pheno, Generation == 4)

training_snps <- subset(snps, V1 %in% training_pheno$Indiv)
testing_snps <- subset(snps, V1 %in% testing_pheno$Indiv)

