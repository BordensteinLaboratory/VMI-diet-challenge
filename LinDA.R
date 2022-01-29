
library(MicrobiomeStat)
load("c1_readcounts_taxon0.01_fecal.RData")

f <- linda(otu, meta, formula = '~ Ethnicity + antibiotics + hormonal_birth_control + (1|day)',
            zero.handling = 'pseudo-count', feature.dat.type = 'count', 
            prev.filter = 0, is.winsor = TRUE, outlier.pct = 0.03, n.cores=3,
            p.adj.method = "BH", alpha = 0.05)

write.table(f$output$EthnicityCaucasian,'c1_fecal_ethnicity.txt',quote=F,row.names=T,col.names=T,sep='	')



rm(list=ls())

load("c1_readcounts_taxon0.01_oral.RData")

o <- linda(otu, meta, formula = '~ Ethnicity + antibiotics + hormonal_birth_control + (1|day)',
            zero.handling = 'pseudo-count', feature.dat.type = 'count', 
            prev.filter = 0, is.winsor = TRUE, outlier.pct = 0.03, n.cores=3,
            p.adj.method = "BH", alpha = 0.05)

write.table(o$output$EthnicityCaucasian,'c1_oral_ethnicity.txt',quote=F,row.names=T,col.names=T,sep='	')




