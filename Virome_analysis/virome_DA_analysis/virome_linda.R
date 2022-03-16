library(MicrobiomeStat)
library(tidyverse)
library(phyloseq)
setwd("~/Desktop/genus_count")

#Cohort 2
otu1 <- read_tsv("virome_genus_count_v1.txt")%>% 
  column_to_rownames(var = "Genus")
meta1 <- read_tsv("v1_meta.txt")
  
v1 <- linda(otu1, meta1, formula = '~ Ethnicity + antibiotics + hormonal_birth_control + (1|day)',
           zero.handling = 'pseudo-count', feature.dat.type = 'count', 
           prev.filter = 0, is.winsor = TRUE, outlier.pct = 0.03, n.cores=3,
           p.adj.method = "BH", alpha = 0.05)
result1 <- v1$output$EthnicityCaucasian %>% arrange(padj)
write.table(result1,'c1_virome_linda.txt',quote=F,row.names=T,col.names=T,sep='	')

#Cohort 2
otu2<- read_tsv("virome_genus_count_v2.txt")%>% 
  column_to_rownames(var = "Genus")
meta2<- read_tsv("v2_meta.txt")

v2 <- linda(otu2, meta2, formula = '~ Ethnicity + antibiotics + hormonal_birth_control + (1|day)',
            zero.handling = 'pseudo-count', feature.dat.type = 'count', 
            prev.filter = 0, is.winsor = TRUE, outlier.pct = 0.03, n.cores=3,
            p.adj.method = "BH", alpha = 0.05)
result2 <- v2$output$EthnicityCaucasian %>% arrange(padj)
write.table(result2,'c2_virome_linda.txt',quote=F,row.names=T,col.names=T,sep='	')