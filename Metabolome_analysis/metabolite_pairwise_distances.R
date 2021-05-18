library(vegan)
library(dplyr)
library(tidyverse)
library(pvclust)
library(adegenet)
library(reshape2)
library(extrafont)
set.seed(36)

setwd("Path/to/metabolite/data")

###Data Cleanup####
df<- read.csv('plasma_or_urine_metabolite_data_file.csv', stringsAsFactors = FALSE, check.names = F) 
df <- column_to_rownames(df,"Subjects")
dat <- df[4:length(df)]
dist<-as.matrix(vegdist(dat, method='bray', na.rm = T))
pair_list <- subset(melt(dist), value!=0)

#Ethnicity
df$group <- paste(df$Time, df$Ethnicity)
temp <- pairDistPlot(dist, df$group, within = T, data= T)
distframe <- temp$data
distframe <- filter(distframe, groups == "After Black-After White" | groups == "Before Black-Before White")

#TIME
temp <- pairDistPlot(dist, df$Time, within = T, data= T)
distframe2 <- temp$data
distframe<- filter(distframe2, groups == "Before-Before" | groups == "After-After")


temp2 <- pairDistPlot(dist, df$Time, within = F, data= T)
distframe2 <- temp2$data
new <-  rbind(distframe,distframe2)
new <- filter(new, groups == "After Black-After White" | groups == "Before Black-Before White"| groups == "Before-Before" | groups == "After-After")

###Outliers
#Distance analysis between ethnicities
before<- distframe[which(distframe$groups == "Before Black-Before White"),]
after<- distframe[which(distframe$groups == "After Black-After White"),]

Q <- quantile(after$distance, probs=c(.25, .75), na.rm = FALSE)
iqr <- IQR(after$distance)
up <-  Q[2]+1.5*iqr # Upper Range
low<- Q[1]-1.5*iqr # Lower Range?
after_eliminated<- subset(after, after$distance > low & after$distance < up)

Q <- quantile(before$distance, probs=c(.25, .75), na.rm = FALSE)
iqr <- IQR(before$distance)
up <-  Q[2]+1.5*iqr # Upper Range
low<- Q[1]-1.5*iqr # Lower Range?
before_eliminated<- subset(before, before$distance > low & before$distance < up)
no_outliers <- rbind(before_eliminated,after_eliminated)

#Distance analysis between all subjects ignoring ethnicity
before_<- distframe[which(distframe$groups == "Before-Before"),]
after<- distframe[which(distframe$groups == "After-After"),]

Q <- quantile(after$distance, probs=c(.25, .75), na.rm = FALSE)
iqr <- IQR(after$distance)
up <-  Q[2]+1.5*iqr # Upper Range
low<- Q[1]-1.5*iqr # Lower Range?
after_eliminated<- subset(after, after$distance > low & after$distance < up)

Q <- quantile(before$distance, probs=c(.25, .75), na.rm = FALSE)
iqr <- IQR(before$distance)
up <-  Q[2]+1.5*iqr # Upper Range
low<- Q[1]-1.5*iqr # Lower Range?
before_eliminated<- subset(before, before$distance > low & before$distance < up)
no_outliers <- rbind(before_eliminated,after_eliminated)

#Plotting
groups_col <-c("#D8E7F2","#D8EBDF")
plot <-  distframe %>% ggplot( aes(x=groups, y=distance, fill=groups)) +
  geom_jitter(aes(colour = factor(groups)), size= .5, alpha= .8) +
  scale_colour_manual(values=c("#2171b5","#238b45"))+
  geom_boxplot(fill = groups_col) +
  labs(x = "", y = "") + 
  scale_x_discrete(labels = c('Inter-ethnicity, \n After','Inter-ethnicity, \n Before '))+
  # scale_x_discrete(labels = c('All, After','All, Before '))+
  coord_flip()
plot + 
  theme_classic() +
  theme( text=element_text(family="Times New Roman", size=25))+
  theme(legend.position = "none")+
  theme(plot.margin=unit(c(1,1,1.5,1.2),"cm"))

# Statistical Testing of mean distance of before and after (all subjects and between ethnictiies) with hypothesis that diff between means is zero  
wilcox.test(distframe$distance~distframe$groups, alternative= "two.sided")
