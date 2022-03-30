library(MicrobiomeStat)
library(tidyverse)
library(phyloseq)
setwd("~/R/VMI-diet-challenge/Virome_analysis/virome_DA_analysis")

# DA Analysis -------------------------------------------------------------


#Cohort 2
otu1 <- read_tsv("virome_genus_count_v1.txt")%>% 
  column_to_rownames(var = "Genus")
meta1 <- read_tsv("v1_meta.txt")

df <- 
v1 <- linda(otu1, meta1, formula = '~ Ethnicity + antibiotics + hormonal_birth_control + (1|day)',
           zero.handling = 'pseudo-count', feature.dat.type = 'count', 
           prev.filter = 0, is.winsor = TRUE, outlier.pct = 0.03, n.cores=3,
           p.adj.method = "BH", alpha = 0.05)
result1 <- v1$output$EthnicityCaucasian %>% arrange(padj)
# write.table(result1,'c1_virome_linda.txt',quote=F,row.names=T,col.names=T,sep='	')

#Cohort 2
otu2<- read_tsv("virome_genus_count_v2.txt")%>% 
  column_to_rownames(var = "Genus")
meta2<- read_tsv("v2_meta.txt")

v2 <- linda(otu2, meta2, formula = '~ Ethnicity + antibiotics + hormonal_birth_control + (1|day)',
            zero.handling = 'pseudo-count', feature.dat.type = 'count', 
            prev.filter = 0, is.winsor = TRUE, outlier.pct = 0.03, n.cores=3,
            p.adj.method = "BH", alpha = 0.05)
result2 <- v2$output$EthnicityCaucasian %>% arrange(padj)
# write.table(result2,'c2_virome_linda.txt',quote=F,row.names=T,col.names=T,sep='	')

#Overlap between cohorts 
resultc1 <- rownames_to_column(result1,var = "genus") 
resultc1 <- resultc1 %>% filter(padj < 0.05)

resultc2 <- result2 %>% rownames_to_column(var = "genus")
resultc2 <- resultc2 %>% filter(padj < 0.05)

x <- intersect(resultc1$genus,resultc2$genus)

# Functions ------------------------------------------------------------------

rel_abund <- function (df){
  df[-1] <- sapply(df[-1], prop.table)
  as.data.frame(df)
}

trx <- function(df){
  df %>%
    t() %>%
    as.data.frame(stringsAsFactors = FALSE) %>%
    rownames_to_column() %>%
    `colnames<-`(.[1,]) %>%
    .[-1,] %>%
    `rownames<-`(NULL)
}

# C1 ----------------------------------------------------------------------

otux1 <- read_tsv("virome_genus_count_v1.txt")
otu1 <- read_tsv("virome_genus_count_v1.txt")%>% 
  column_to_rownames(var = "Genus") %>% t() %>% as.data.frame() %>% 
  rownames_to_column(var="sample")
meta1 <- read_tsv("v1_meta.txt")

df <- left_join(meta1,otu1) %>% 
  mutate(Ethnicity = case_when(Ethnicity == "African_American" ~ "Black", 
                               Ethnicity == "Caucasian" ~ "White")) 

sig_c1 <- c("Ruminococcus","Unclassified","Veillonella","Alistipes","Subdoligranulum","Oscillibacter","Faecalibacterium","Bacteroides","Anaerobutyricum","Paraprevotella","Coprobacter")

sig_c2 <- c("Coprobacter","Parabacteroides","Bacteroides","Phascolarctobacterium","Blastocystis","Anaerotruncus")

means1 <- df %>% 
  select(Ethnicity, 9:length(.)) %>% 
  pivot_longer(2:length(.)) %>% 
  group_by(name, Ethnicity) %>% 
  type_convert() %>% 
  summarise( mean = mean(value)) %>% 
  filter( name %in% sig_c1)

means1all <- df %>% 
  select(Ethnicity, 9:length(.)) %>% 
  pivot_longer(2:length(.)) %>% 
  group_by(name) %>% 
  type_convert() %>% 
  summarise( mean = mean(value))

compared1 <- means1 %>% group_by(name)  %>% top_n(n=1)
compared_unique1 <- means1 %>% group_by(name) %>% filter(mean != 0) 
comapred_distinct1 <- compared_unique1%>% distinct_at(vars(name), .keep_all = T)

# C2 ----------------------------------------------------------------------


otux2 <- read_tsv("virome_genus_count_v2.txt")
otu2 <- read_tsv("virome_genus_count_v2.txt")%>% 
  column_to_rownames(var = "Genus") %>% t() %>% as.data.frame() %>% 
  rownames_to_column(var="sample")
  meta2 <- read_tsv("v2_meta.txt")

df <- left_join(meta2,otu2) %>% 
  mutate(Ethnicity = case_when(Ethnicity == "African_American" ~ "Black", 
                               Ethnicity == "Caucasian" ~ "White")) 

means2 <- df %>% 
  select(Ethnicity, 9:length(.)) %>% 
  pivot_longer(2:length(.)) %>% 
  group_by(name, Ethnicity) %>% 
  type_convert() %>% 
  summarise( mean = mean(value))%>% 
  filter( name %in% sig_c2)

means2all <- df %>% 
  select(Ethnicity, 9:length(.)) %>% 
  pivot_longer(2:length(.)) %>% 
  group_by(name) %>% 
  type_convert() %>% 
  summarise( mean = mean(value))

compared2 <- means2 %>% group_by(name)  %>% top_n(n=1)
compared_unique2 <- means2 %>% group_by(name)  %>% filter(mean != 0) 
comapred_distinct2 <- compared_unique2%>% distinct_at(vars(name), .keep_all = T)

total <- rbind(means1,means2) %>% distinct(name)
union(sig_c1,sig_c2)
