library(vegan)
library(dplyr)
library(tidyverse)
library(pvclust)
library(adegenet)
library(reshape2)
library(extrafont)
library(magrittr)
library(plyr)
set.seed(36)

setwd("~/Dropbox/Rob/vmi_revision/mb/data")
datafiles <- list.files()
ethnicities<- c("White","Black")  
results_oral <- NULL
results_gut <- NULL

# df<- read_tsv(datafiles[1]) %>% 
#   mutate(Ethnicity = case_when(Ethnicity == "African_American" ~ "Black", 
#                                Ethnicity == "Caucasian" ~ "White")) 

for (i in datafiles){
if(str_detect(i, "oral") == TRUE){
df<- read_tsv(i) %>% 
  mutate(Ethnicity = case_when(Ethnicity == "African_American" ~ "Black", 
                               Ethnicity == "Caucasian" ~ "White")) 
df$day <- str_to_title(df$day)
df$group <- paste(df$day,df$Ethnicity)
df2 <- df %>% select(group, everything())
data.env <- df2[1:10]
data <- df2[11:length(df)]
tmod <- vegdist(data, method='bray', na.rm = T) %>% 
  betadisper(group = data.env$day) %>% TukeyHSD()
pmod <- vegdist(data, method='bray', na.rm = T) %>% 
  betadisper(group = data.env$day) %>% permutest(pairwise = T)
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
df$day <- str_to_title(df$day)
df$group <- paste(df$day, df$Ethnicity)
df2 <- df %>% select(group, everything()) 
data.env <- df2[1:10]
data <- df2[11:length(df)]
tmod <- vegdist(data, method='bray', na.rm = T) %>% 
  betadisper(group = data.env$day) %>% TukeyHSD()
pmod <- vegdist(data, method='bray', na.rm = T) %>% 
  betadisper(group = data.env$day) %>% permutest(pairwise = T)
pstat <- permustats(pmod)
# densityplot(pstat, scales = list(x = list(relation = "free")))
# qqmath(pstat, scales = list(relation = "free"))
x <- pmod$pairwise$observed
update <- c(i,x)
results_gut<- rbind(results_gut,update)
}
}


#FDR adjusted p-values 
t_gut <- results_gut %>% as.data.frame() %>% select(2:length(.))%>% 
  write_csv("~/Desktop/intergroup22.txt")
x=NULL
for ( i in c(1:2)){
x[[i]] <- t_gut[i,] %>% 
  t() %>% 
  p.adjust(., method="fdr")
}
adjusted_result_gut <- do.call("rbind",x) %>% 
  as.data.frame() %>% 
  write_csv("~/Desktop/intergroup.txt")
adjusted_result_gut <- colnames(results_gut)

t_oral <- results_oral%>% as.data.frame() %>% select(2:length(.))
x=NULL
for ( i in c(1:2)){
  x[[i]] <- t_oral[i,] %>% 
    t() %>% 
    p.adjust(., method="fdr")
}
adjusted_result_oral <- do.call("rbind",x)


