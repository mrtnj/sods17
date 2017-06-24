
## Set up training and testing from simulated data

snps <- read.table("SimulatedData/Chip1Genotype.txt")
pheno <- read.table("SimulatedData/PedigreeAndGeneticValues.txt", header = TRUE)

training_pheno <- subset(pheno, Generation %in% 2:3)
testing_pheno <- subset(pheno, Generation == 4)

training_snps <- subset(snps, V1 %in% training_pheno$Indiv)
testing_snps <- subset(snps, V1 %in% testing_pheno$Indiv)


