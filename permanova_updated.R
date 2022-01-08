library(vegan)
library(BiodiversityR)
library(MASS)

m <-read.table('fecal_abudance_meta.txt', head=T, sep="\t", row.names=1, check.names = F)
m.matrix<-as.matrix(m[,9:ncol(m)]) #exclude metadata

perm <- with(m, how(nperm = 999, blocks = day))


### Ethnicity, antibiotics, and hormonal_birth_control ###
set.seed(36)
adonis2(m.matrix ~ m$Ethnicity+m$antibiotics+m$hormonal_birth_control, permutations=perm, method="bray", by="margin")

set.seed(36)
adonis2(m.matrix ~ m$Ethnicity+m$antibiotics+m$hormonal_birth_control, permutations=perm, method="jaccard", binary = TRUE, by="margin")


### Subject ###
set.seed(36)
adonis2(m.matrix ~ m$Subject, permutations = perm, method="bray")

set.seed(36)
adonis2(m.matrix ~ m$Subject, permutations = perm, method="jaccard", binary = TRUE)


