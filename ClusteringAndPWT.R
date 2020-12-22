###Clustering & Pairwise testing###
#######PairTest####################
#＜￣｀ヽ、　　　　　　　／￣＞
#ゝ、　　＼　／⌒ヽ,ノ 　/´
#   ゝ、　`（ ( ͡° ͜ʖ ͡°) ／
#        >　 　 ,ノ 　
##################################
library(vegan)
library(dplyr)
library(tidyverse)
library(pvclust)
library(adegenet)
set.seed(36)
setwd("~/Projects/VMI/VMI/VMI_val/data/clean_data")


#####UNUSED_FILTERING####
# df_edit<- df_edit[which (df_edit$Ethnicity == AA),]
# df_x<- within(df, rm(Ethnicity))

####PERMANOVA####
df<- read.csv(temp, stringsAsFactors = FALSE, check.names = F) 
meta <- df[c(1:3)]
dat<-df[c(4:length(df))]
adonis2(dat~Time+Ethnicity+(Time*Ethnicity), data = meta, permutations = 999, method = "euclidian",na.rm = T) 

####BETADISP#####
df$Ethnicity <- as.factor(df$Ethnicity)
df$Time <- as.factor(df$Time)
# df$ID <- as.factor(df$Subjects)
df$Group <- paste(df$Ethnicity, df$Time)
dat <- as.data.frame(df[5:length(df)-1],)
disp<-betadisper(dist, group=df$Group,type= "centroid")
permutest(disp, permutations = 999)
anova(disp)
plot(disp)
boxplot(disp)
plot(TukeyHSD(disp))
plot(disp, hull=FALSE, ellipse=TRUE) 
dist <- as.matrix(dist)
####Pairwise_Testing#####
df<- read.csv('plasmaYr2.csv', stringsAsFactors = FALSE, check.names = F) 
df <- column_to_rownames(df,"Subjects")
dat <- df[4:length(df)]
dist<-as.matrix(vegdist(dat, method='euclidian'))
df$group <- paste(df$Time, df$Ethnicity)
temp <- pairDistPlot(dist, df$group, within = T, data= T)
# temp <- pairDistPlot(dist, df$Time, within = T, data= T)
distframe <- temp$data
# temp$violin
# temp$jitter
temp$boxplot
pairwise.t.test(distframe$distance, distframe$groups, pool.sd=F, p.adjust.method = "none")

####PVCLUST####
df_t <- as.data.frame(t(df))
names(df_t) <- lapply(df_t[1, ], as.character)
dat_t <- as.matrix(df_t[-c(1:3),])


result_pv <- pvclust(dat_t, method.hclust = "ward.D",
                     method.dist = "euclidean", nboot = 1000)
plot(result_pv, hang = -1, cex = 0.5)
pvrect(result_pv)
