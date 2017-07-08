## Test imputation accuracy on the masked data

filled <- numeric(3)
correlation <- numeric(3)
for (i in 1:3) {
    true <- read.table(paste("impute_test_fish", i, "/AlphaImpute_TrueGeno.txt", sep = ""), na.strings = "9")
    imp <- read.table(paste("impute_test_fish", i, "/Results/ImputeGenotypes.txt", sep = ""), na.strings = "9")
    masked <- read.table(paste("impute_test_fish", i, "/AlphaImpute_geno.txt", sep = ""), na.strings = "9")

    ## Extract the masked
    masked_l <- is.na(masked) & !is.na(true)
    imps <- imp[match(masked[,1], imp[,1]),]

    filled[i] <- 1 - sum(is.na(imps[masked_l]))/sum(masked_l)
    correlation[i] <- cor(as.numeric(imps[masked_l]), as.numeric(true[masked_l]), use = "p")
}









