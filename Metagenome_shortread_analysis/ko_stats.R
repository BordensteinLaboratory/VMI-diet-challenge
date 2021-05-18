library(tidyverse)
library(vegan)
library(ggtext)
library(ggpubr)
library(gridExtra)
library(cowplot)
set.seed(999)

#Cohort1 Short read PERMANOVA modeling of KOs 
dir <- "/Users/Ko/directory/"
data <- read.table(paste(dir,"ko_cohort1.tsv",sep=""), sep='\t',header=T)
meta <- read.table(paste(dir,"year1_metadata.txt",sep=""), sep='\t', header=T)

distance <- "jaccard"

#ORAL
run <- left_join(meta,data) %>% 
  filter(source == "oral" & UNMAPPED != "NA")
met <- run[,1:10] 
dat <- run[,11:length(run)]
sr_c1_oralko_jac <- adonis2(dat~ethnicity + stage + antibiotic+ contraceptive+subject_id, data = met, permutations = 999, method = distance,na.rm = T)

#FECAL
run<- left_join(meta,data) %>% 
  filter(source == "fecal" & UNMAPPED != "NA")
met <- run[,1:10] 
dat <- run[,11:length(run)]
sr_c1_fecalko_jac <- adonis2(dat~ethnicity + stage + antibiotic+ contraceptive+subject_id, data = met, permutations = 999, method = distance,na.rm = T)

distance <- "bray"
#FECAL
run<- left_join(meta,data) %>% 
  filter(source == "fecal" & UNMAPPED != "NA")
met <- run[,1:9] 
dat <- run[,10:length(run)]
sr_c1_fecalko_bray <- adonis2(dat~ethnicity + stage + antibiotic+ contraceptive+subject_id, data = met, permutations = 999, method = distance,na.rm = T)

#Cohort2 Short read PERMANOVA modeling of KOs
dir <- "/Users/Ko/directory/"
data <- read.table(paste(dir,"ko_cohort2.tsv",sep=""), sep='\t',header=T)
meta <- read.table(paste(dir,"year2_metadata.txt",sep=""), sep='\t', header=T)

distance <- "jaccard"
#FECAL
run<- left_join(meta,data) %>% 
  filter(source == "fecal" & UNMAPPED != "NA")
met <- run[,1:10] 
dat <- run[,11:length(run)]
sr_c2_fecalko_jac <- adonis2(dat~ethnicity + stage + antibiotic+ contraceptive+subject_id, data = met, permutations = 999, method = distance,na.rm = T)

distance <- "bray"
#FECAL
run<- left_join(meta,data) %>% 
  filter(source == "fecal" & UNMAPPED != "NA")
met <- run[,1:10] 
dat <- run[,11:length(run)]
sr_c2_fecalko_bray <- adonis2(dat~ethnicity + stage + antibiotic+ contraceptive+subject_id, data = met, permutations = 999, method = distance,na.rm = T)

####NMDS
nmds<- metaMDS(dat, k=2, trymax=499, dist = distance)
m3<-scores(nmds)
df<-cbind(m3,met)
df$Ethnicity <- factor(df$Ethnicity, levels=c("Black","White"))
df$`Study period` <- factor(df$`Study period`, levels=c("Before","During","After"))
df$`Study period` <- factor(df$`Study period`, levels=c("Before","After"))
df$SampleID <- as.factor(df$SampleID)

#Plots####

brayc1stage <- ggplot(df, aes(x = NMDS1, y = NMDS2, 
                              color = `Stage`)) +
  geom_point(size=3) + scale_color_manual(
    values = c("Before"="#238b45","During" = "#d94801", "After"="#2171b5")) + scale_fill_manual(
      values = c("Before"="#238b45","During" = "#d94801", "After"="#2171b5")) +
  theme(panel.background = element_rect(fill = 'White', colour = 'Black'), 
        legend.key=element_blank()) + 
  theme(axis.title.x=element_text(size=rel(2)), 
        axis.title.y=element_text(size=rel(2)),
        plot.title = element_text(size=rel(3)),
        legend.title = element_text(size=rel(2)),
        legend.text = element_text(size = rel(1.8))) +
  stat_ellipse(data = df, aes(x = NMDS1, y = NMDS2, 
                              fill = `Stage`), 
               alpha = 0.2, size = 0.8, geom = "polygon",
               linetype = 2,
               type = "t", level = 0.95) + 
  ggtitle("KO - Bray-Curtis - Fecal")  
brayc1stage

brayc1eth <- ggplot(df, aes(x = NMDS1, y = NMDS2, 
                            color = Ethnicity)) +
  geom_point(size=3) + scale_color_manual(
    values = c("White"="#87ceeb","Black"="#f5c4ca")) +
  theme(panel.background = element_rect(fill = 'white', colour = 'black'), 
        legend.key=element_blank()) + 
  theme(axis.title.x=element_text(size=rel(2)), 
        axis.title.y=element_text(size=rel(2)),
        plot.title = element_text(size=rel(3)),
        legend.title = element_text(size=rel(2)),
        legend.text = element_text(size = rel(1.8))) +
  stat_ellipse(data = df,aes(x = NMDS1, y = NMDS2, fill = Ethnicity), 
               alpha = 0.2, size = 0.8, geom = "polygon",
               linetype = 2,
               type = "t", level = 0.95) + 
  ggtitle("KO - Bray-Curtis - Fecal") 
brayc1eth

brayc2Stage <- ggplot(df, aes(x = NMDS1, y = NMDS2, 
                              color = `Stage`)) +
  geom_point(size=3) + scale_color_manual(
    values = c("Before"="#238b45","During" = "#d94801", "After"="#2171b5")) + scale_fill_manual(
      values = c("Before"="#238b45","During" = "#d94801", "After"="#2171b5")) +
  theme(panel.background = element_rect(fill = 'White', colour = 'Black'), 
        legend.key=element_blank()) + 
  theme(axis.title.x=element_text(size=rel(2)), 
        axis.title.y=element_text(size=rel(2)),
        plot.title = element_text(size=rel(3)),
        legend.title = element_text(size=rel(2)),
        legend.text = element_text(size = rel(1.8))) +
  stat_ellipse(data = df, aes(x = NMDS1, y = NMDS2, 
                              fill = `Stage`), 
               alpha = 0.2, size = 0.8, geom = "polygon",
               linetype = 2,
               type = "t", level = 0.95) + 
  ggtitle("KO - Bray-Curtis - Fecal") 
brayc2Stage

brayc2eth <- ggplot(df, aes(x = NMDS1, y = NMDS2, 
                            color = Ethnicity)) +
  geom_point(size=3) + scale_color_manual(
    values = c("White"="#87ceeb","Black"="#f5c4ca")) +
  theme(panel.background = element_rect(fill = 'white', colour = 'black'), 
        legend.key=element_blank()) + 
  theme(axis.title.x=element_text(size=rel(2)), 
        axis.title.y=element_text(size=rel(2)),
        plot.title = element_text(size=rel(3)),
        legend.title = element_text(size=rel(2)),
        legend.text = element_text(size = rel(1.8))) +
  stat_ellipse(aes(x = NMDS1, y = NMDS2, fill = Ethnicity), 
               alpha = 0.2, size = 0.8, geom = "polygon",
               linetype = 2,
               type = "t", level = 0.95) + 
  ggtitle("KO - Bray-Curtis- Fecal") 
brayc2eth

#Create figures 

#Create figures 
tiff(file = "sr_KO_Eth.tif", res = 150, width = 18, 
     height = 7, units = "in")
legend1 = get_legend(brayc1eth + theme(legend.box.margin = margin(0, 0, 0, 12)))
col1 = plot_grid(brayc1eth + theme(legend.position = "none"),
                 nrow = 1, ncol = 1, labels = c('A'), 
                 label_size = 20)
col2 = plot_grid(brayc2eth + theme(legend.position = "none"),
                 nrow = 1, ncol = 1, labels = c('B'), 
                 label_size = 20) 
plot = plot_grid(col1, col2, legend1, nrow = 1, ncol = 3, 
                 rel_widths = c(1.5, 1.5, 0.75), align = "h", axis = "t")
plot
dev.off()

tiff(file = "sr_KO_Stage.tif", res = 150, width = 18, 
     height = 7, units = "in")
legend1 = get_legend(brayc1stage + theme(legend.box.margin = margin(0, 0, 0, 12)))
col1 = plot_grid(brayc1stage + theme(legend.position = "none"),
                 nrow = 1, ncol = 1, labels = c('C'), 
                 label_size = 20)
col2 = plot_grid(brayc2Stage + theme(legend.position = "none"),
                 nrow = 1, ncol = 1, labels = c('D'), 
                 label_size = 20) 
plot = plot_grid(col1, col2, legend1, nrow = 1, ncol = 3, 
                 rel_widths = c(1.5, 1.5, 0.75), align = "h", axis = "t")
plot
dev.off()