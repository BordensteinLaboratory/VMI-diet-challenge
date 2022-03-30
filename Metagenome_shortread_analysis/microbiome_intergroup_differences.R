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
if(str_detect(i, "oral") == TRUE){
df<- read_tsv(i) %>% 
  mutate(Ethnicity = case_when(Ethnicity == "African_American" ~ "Black", 
                               Ethnicity == "Caucasian" ~ "White")) 
df$stage <- str_to_title(df$stage)
df$group <- paste(df$stage, df$Ethnicity)
df2 <- df %>% select(group, everything()) 
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
update <- c(i,x)
results_oral<- rbind(results_oral,update)
}
else{
df<- read_tsv(i) %>% 
  mutate(Ethnicity = case_when(Ethnicity == "African_American" ~ "Black", 
                               Ethnicity == "Caucasian" ~ "White")) 
df$stage <- str_to_title(df$stage)
df$group <- paste(df$stage, df$Ethnicity)
df2 <- df %>% select(group, everything())
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
update <- c(i,x)
results_gut<- rbind(results_gut,update)
}
}


#FDR adjusted p-values 
t_gut <- results_gut %>% as.data.frame() %>% select(2:length(.))
x=NULL
for ( i in c(1:3)){
  x[[i]] <- t_gut[i,] %>% 
    t() %>% 
    p.adjust(., method="fdr")
}
adjusted_result <- do.call("rbind",x)

t_oral <- results_oral%>% as.data.frame() %>% select(3:length(.))
x=NULL
for ( i in c(1:2)){
  x[[i]] <- t_oral[i,] %>% 
    t() %>% 
    p.adjust(., method="fdr")
}

