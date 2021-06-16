library(tidyverse)
library(vegan)
library(ggtext)
library(ggpubr)
library(gridExtra)
library(cowplot)
set.seed(999)

#Testing dispersion of variances (betadisp) of contig based KOs 
dir <- "contig/"

#Cohort1 
data <- read.table(paste(dir,"ko_c1_contig.txt",sep=""), sep='\t',header=T)
data = data %>%
  mutate(total = rowSums(data[,2:length(data)])) %>%
  filter(total > 0) %>%
  select_if(~ !is.numeric(.) || sum(.) != 0) 
meta <- read.table(paste(dir,"year1_meta.txt",sep=""), sep='\t', header=T)

#Jaccard 
distance <- "jaccard"
run<- left_join(meta,data) %>% 
  filter(source == "fecal") %>% 
  drop_na()
met <- run[,1:8] 
dat <- run[,9:length(run)]
pdisp_eth <- anova(betadisper(vegdist(dat, method = distance), group = met$ethnicity))
pdisp_stage <- anova(betadisper(vegdist(dat, method = distance), group = met$stage))
pdisp_Abx <- anova(betadisper(vegdist(dat, method = distance), group = met$antibiotic))
pdisp_hormone <- anova(betadisper(vegdist(dat, method = distance), group = met$contraceptive))
pdisp_subject <- anova(betadisper(vegdist(dat, method = distance), group = met$subject_id))
con_c1_fecalko_jac <- adonis2(dat~ethnicity + stage + antibiotic+ contraceptive+subject_id, data = met, permutations = 999, method = distance,na.rm = T)

#Bray Curtis 
distance <- "bray"
run<- left_join(meta,data) %>% 
  filter(source == "fecal") %>% 
  drop_na()
met <- run[,1:8] 
dat <- run[,9:length(run)]
pdisp_eth <- anova(betadisper(vegdist(dat, method = distance), group = met$ethnicity))
pdisp_stage <- anova(betadisper(vegdist(dat, method = distance), group = met$stage))
pdisp_Abx <- anova(betadisper(vegdist(dat, method = distance), group = met$antibiotic))
pdisp_hormone <- anova(betadisper(vegdist(dat, method = distance), group = met$contraceptive))
pdisp_subject <- anova(betadisper(vegdist(dat, method = distance), group = met$subject_id))
con_c1_fecalko_bray <- adonis2(dat~ethnicity + stage + antibiotic+ contraceptive+subject_id, data = met, permutations = 999, method = distance,na.rm = T)


#Cohort2

data <- read.table(paste(dir,"ko_c2_contig.txt",sep=""), sep='\t',header=T)
data = data %>%
  mutate(total = rowSums(data[,2:length(data)])) %>%
  filter(total > 0) %>%
  select_if(~ !is.numeric(.) || sum(.) != 0) 
meta <- read.table(paste(dir,"year2_meta.txt",sep=""), sep='\t', header=T)

#Jaccard 
distance <- "jaccard"
run<- left_join(meta,data) %>% 
  filter(source == "fecal") %>% 
  drop_na()
met <- run[,1:8] 
dat <- run[,9:length(run)]
pdisp_eth <- anova(betadisper(vegdist(dat, method = distance, na.rm = T), group = met$ethnicity))
pdisp_stage <- anova(betadisper(vegdist(dat, method = distance), group = met$stage))
pdisp_Abx <- anova(betadisper(vegdist(dat, method = distance), group = met$antibiotic))
pdisp_hormone <- anova(betadisper(vegdist(dat, method = distance), group = met$contraceptive))
pdisp_subject <- anova(betadisper(vegdist(dat, method = distance), group = met$subject_id))
con_c2_fecalko_jac <- adonis2(dat~ethnicity + stage + antibiotic+ contraceptive+subject_id, data = met, permutations = 999, method = distance,na.rm = T)

#Bray Curtis 
distance <- "bray"
run<- left_join(meta,data) %>% 
  filter(source == "fecal") %>% 
  drop_na()
met <- run[,1:8] 
dat <- run[,9:length(run)]
pdisp_eth <- anova(betadisper(vegdist(dat, method = distance), group = met$ethnicity))
pdisp_stage <- anova(betadisper(vegdist(dat, method = distance), group = met$stage))
pdisp_Abx <- anova(betadisper(vegdist(dat, method = distance), group = met$antibiotic))
pdisp_hormone <- anova(betadisper(vegdist(dat, method = distance), group = met$contraceptive))
pdisp_subject <- anova(betadisper(vegdist(dat, method = distance), group = met$subject_id))

con_c2_fecalko_bray <- adonis2(dat~ethnicity + stage + antibiotic+ contraceptive+subject_id, data = met, permutations = 999, method = distance,na.rm = T)
