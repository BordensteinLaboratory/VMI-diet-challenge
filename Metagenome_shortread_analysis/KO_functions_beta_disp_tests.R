library(tidyverse)
library(vegan)
library(ggtext)
library(ggpubr)
library(gridExtra)
library(cowplot)
set.seed(999)

#Cohort1 Short read PERMANOVA modeling of KOs 
dir <- "/Users/goblinking/Desktop/pd/short_read/"
data <- read.table(paste(dir,"ko1.tsv",sep=""), sep='\t',header=T)
meta <- read.table(paste(dir,"year1_meta.txt",sep=""), sep='\t', header=T)
#Jaccard 
distance <- "jaccard"
run<- left_join(meta,data) %>% 
  filter(source == "fecal" & UNMAPPED != "NA")
met <- run[,1:10] 
dat <- run[,11:length(run)]
pdisp_eth <- anova(betadisper(vegdist(dat, method = distance), group = met$ethnicity))
pdisp_stage <- anova(betadisper(vegdist(dat, method = distance), group = met$stage))
pdisp_Abx <- anova(betadisper(vegdist(dat, method = distance), group = met$antibiotic))
pdisp_hormone <- anova(betadisper(vegdist(dat, method = distance), group = met$contraceptive))
pdisp_subject <- anova(betadisper(vegdist(dat, method = distance), group = met$subject_id))
sr_c1_fecalko_jac <- adonis2(dat~ethnicity + stage + antibiotic+ contraceptive+subject_id, data = met, permutations = 999, method = distance,na.rm = T)

#Bray Curtis 
distance <- "bray"
run<- left_join(meta,data) %>% 
  filter(source == "fecal" & UNMAPPED != "NA")
met <- run[,1:10] 
dat <- run[,11:length(run)]
pdisp_eth <- anova(betadisper(vegdist(dat, method = distance), group = met$ethnicity))
pdisp_stage <- anova(betadisper(vegdist(dat, method = distance), group = met$stage))
pdisp_Abx <- anova(betadisper(vegdist(dat, method = distance), group = met$antibiotic))
pdisp_hormone <- anova(betadisper(vegdist(dat, method = distance), group = met$contraceptive))
pdisp_subject <- anova(betadisper(vegdist(dat, method = distance), group = met$subject_id))
sr_c1_fecalko_bray <- adonis2(dat~ethnicity + stage + antibiotic+ contraceptive+subject_id, data = met, permutations = 999, method = distance,na.rm = T)


#Cohort2

#Jaccard 
dir <- "/Users/goblinking/Desktop/pd/short_read/"
data <- read.table(paste(dir,"ko2.tsv",sep=""), sep='\t',header=T)
meta <- read.table(paste(dir,"year2_meta.txt",sep=""), sep='\t', header=T)
distance <- "jaccard"
run<- left_join(meta,data) %>% 
  filter(source == "fecal" & UNMAPPED != "NA")
met <- run[,1:10] 
dat <- run[,11:length(run)]
pdisp_eth <- anova(betadisper(vegdist(dat, method = distance), group = met$ethnicity))
pdisp_stage <- anova(betadisper(vegdist(dat, method = distance), group = met$stage))
pdisp_Abx <- anova(betadisper(vegdist(dat, method = distance), group = met$antibiotic))
pdisp_hormone <- anova(betadisper(vegdist(dat, method = distance), group = met$contraceptive))
pdisp_subject <- anova(betadisper(vegdist(dat, method = distance), group = met$subject_id))

sr_c2_fecalko_jac <- adonis2(dat~ethnicity + stage + antibiotic+ contraceptive+subject_id, data = met, permutations = 999, method = distance,na.rm = T)

#Bray Curtis 
distance <- "bray"
run<- left_join(meta,data) %>% 
  filter(source == "fecal" & UNMAPPED != "NA")
met <- run[,1:10] 
dat <- run[,11:length(run)]
pdisp_eth <- anova(betadisper(vegdist(dat, method = distance), group = met$ethnicity))
pdisp_stage <- anova(betadisper(vegdist(dat, method = distance), group = met$stage))
pdisp_Abx <- anova(betadisper(vegdist(dat, method = distance), group = met$antibiotic))
pdisp_hormone <- anova(betadisper(vegdist(dat, method = distance), group = met$contraceptive))
pdisp_subject <- anova(betadisper(vegdist(dat, method = distance), group = met$subject_id))

sr_c2_fecalko_bray <- adonis2(dat~ethnicity + stage + antibiotic+ contraceptive+subject_id, data = met, permutations = 999, method = distance,na.rm = T)
