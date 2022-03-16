library(vegan)
library(dplyr)
library(tidyverse)
library(pvclust)
library(adegenet)
library(reshape2)
library(extrafont)
library(magrittr)
set.seed(36)

setwd("~/Dropbox/Rob/vmi_revision/mb/data")
datafiles <- list.files()
ethnicities<- c("White","Black")  
results_oral <- NULL
results_gut <- NULL


for (i in datafiles){
for (e in ethnicities){
if(str_detect(i, "oral") == TRUE){
df<- read_tsv(i) %>% 
  mutate(Ethnicity = case_when(Ethnicity == "African_American" ~ "Black", 
                               Ethnicity == "Caucasian" ~ "White")) 
df$stage <- str_to_title(df$stage)
df$group <- paste(df$stage, df$Ethnicity)
df2 <- df %>% select(group, everything()) %>% filter(Ethnicity == e)
data.env <- df2[1:10]
data <- df2[11:length(df)]
tmod <- vegdist(data, method='bray', na.rm = T) %>% 
  betadisper(group = data.env$stage) %>% TukeyHSD()
pmod <- vegdist(data, method='bray', na.rm = T) %>% 
  betadisper(group = data.env$stage) %>% permutest(pairwise = T)
pstat <- permustats(pmod)
# densityplot(pstat, scales = list(x = list(relation = "free")))
# qqmath(pstat, scales = list(relation = "free"))
x <- pmod$pairwise$observed
update <- c(i,e,x)
results_oral<- rbind(results_oral,update)
}
else{
df<- read_tsv(i) %>% 
  mutate(Ethnicity = case_when(Ethnicity == "African_American" ~ "Black", 
                               Ethnicity == "Caucasian" ~ "White")) 
df$stage <- str_to_title(df$stage)
df$group <- paste(df$stage, df$Ethnicity)
df2 <- df %>% select(group, everything()) %>% filter(Ethnicity == e)
data.env <- df2[1:10]
data <- df2[11:length(df)]
tmod <- vegdist(data, method='bray', na.rm = T) %>% 
  betadisper(group = data.env$stage) %>% TukeyHSD()
pmod <- vegdist(data, method='bray', na.rm = T) %>% 
  betadisper(group = data.env$stage) %>% permutest(pairwise = T)
pstat <- permustats(pmod)
# densityplot(pstat, scales = list(x = list(relation = "free")))
# qqmath(pstat, scales = list(relation = "free"))
x <- pmod$pairwise$observed
update <- c(i,e,x)
results_gut<- rbind(results_gut,update)
}
}
}



