
library(assertthat)

geno <- read.table("fish_data/TableS6_genotypes.txt", header = TRUE, stringsAsFactors = FALSE)

ped <- read.table("fish_data/TableS2_pedigree.txt", header = TRUE, stringsAsFactors = FALSE)

map <- read.table("fish_data/TableS5_map.txt", header = TRUE, stringsAsFactors = FALSE)



## Should probably ask the authors about line 650 -- but it sure looks like a typo
ped$Id[650] <- "Sa05E05"
assert_that(identical(ped$id, geno$id))


## Prepare AlphaImpute files

write.table(ped, file = "AlphaImpute_ped.txt", row.names = FALSE, col.names = FALSE, quote = FALSE)

chrs <- unique(map$chr)
for (i in 1:length(chrs)) {
    ## Genotype file for chromosome
    chr_map <- subset(map, chr == chrs[i])
    n_snp <- nrow(chr_map)
    geno_ai <- cbind(geno$Id, geno[, na.exclude(match(chr_map$id, colnames(geno)))])
    assert_that(identical(colnames(geno_ai)[-1], chr_map$id))

    ## Folder
    folder_name <- paste("impute_fish", i, sep = "")
    system(paste("mkdir", folder_name))
    write.table(geno_ai, file = paste(folder_name, "/AlphaImpute_geno.txt", sep = ""),
                row.names = FALSE, col.names = FALSE, quote = FALSE, na = "9")
    
    ## Spec file and pedigree
    system(paste("cp AlphaImputeSpecTemplate.txt", folder_name))
    system(paste("sed -e 's/NSNP/", n_snp, "/' ", folder_name, "/AlphaImputeSpecTemplate.txt > ",
                 folder_name, "/AlphaImputeSpec.txt", sep = ""))
    system(paste("cp AlphaImpute_ped.txt", folder_name))    
    
    ## Copy binaries
    system(paste("cp AlphaImputev1.5.5", folder_name))
    system(paste("cp AlphaPhase1.1", folder_name))
    system(paste("cp GeneProbForAlphaImpute", folder_name))
}



## Masked datasets

for (i in 1:3) {
    ## Genotype file for chromosome
    chr_map <- subset(map, chr == 1)
    n_snp <- nrow(chr_map)
    geno_ai <- cbind(geno$Id, geno[, na.exclude(match(chr_map$id, colnames(geno)))])
    assert_that(identical(colnames(geno_ai)[-1], chr_map$id))

    geno_masked <- geno_ai
    mask_individuals <- sample(1:nrow(geno_ai), 100)
    for (j in 1:length(mask_individuals)) {
        mask_genotypes <- sample(2:ncol(geno_ai), round(ncol(geno_ai) * 0.1))
        geno_masked[mask_individuals[j], mask_genotypes] <- NA
    }
    
    ## Folder
    folder_name <- paste("impute_test_fish", i, sep = "")
    system(paste("mkdir", folder_name))
    write.table(geno_ai, file = paste(folder_name, "/AlphaImpute_TrueGeno.txt", sep = ""),
                row.names = FALSE, col.names = FALSE, quote = FALSE, na = "9")
    write.table(geno_masked, file = paste(folder_name, "/AlphaImpute_geno.txt", sep = ""),
                row.names = FALSE, col.names = FALSE, quote = FALSE, na = "9")
    
    ## Spec file and pedigree
    system(paste("cp AlphaImputeSpecTemplate.txt", folder_name))
    system(paste("sed -e 's/NSNP/", n_snp, "/' ", folder_name, "/AlphaImputeSpecTemplate.txt > ",
                 folder_name, "/AlphaImputeSpec.txt", sep = ""))
    system(paste("cp AlphaImpute_ped.txt", folder_name))    
    
    ## Copy binaries
    system(paste("cp AlphaImputev1.5.5", folder_name))
    system(paste("cp AlphaPhase1.1", folder_name))
    system(paste("cp GeneProbForAlphaImpute", folder_name))
}
