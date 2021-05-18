title: "Metabolome Analysis"
author: "Robert Markowitz"

library("MetaboAnalystR")
library(vegan)
library(Rfast)
library(tidyverse)
library(ComplexHeatmap)
library(circlize)
library(rayshader)
library(readxl)
library(broom)
library(knitr)
set.seed(36)

# This analysis was performed to determine if metabolome compositions changed during the dietary intervention and produce a PCA plot incorporated into Figure 5 of the main text. 
temp <- "Path/to/urine_or_plasma/metabolite/data"
df_edit<- read.csv(temp, stringsAsFactors = FALSE, check.names = F) 
df_edit <- within(df_edit, rm(Ethnicity))
p.env <- df_edit[c(1:2)]
pdat<-df_edit[c(3:length(df_edit))]
adonis2(pdat~Time, data = p.env, permutations = 999, method = "euclidian",na.rm = T) 
write.csv(df_edit, "temp.csv", row.names = FALSE) 

#Using modified R script from MetaboAnalyst to customize PCA plots of metabolites with associated color scheme
file <- "temp.csv"
mSet<-InitDataObjects("pktable", "stat", FALSE)
mSet<-Read.TextData(mSet,file , "rowu", "disc");
mSet<-SanityCheckData(mSet)
mSet<-ReplaceMin(mSet);
mSet<-PreparePrenormData(mSet)
mSet<-Normalization(mSet, "NULL", "NULL", "AutoNorm", ratio=FALSE, ratioNum=20)
PCAdat <- as.data.frame(mSet[["dataSet"]][["norm"]])

#PCA plotting of metabolite data by "Before" and "After" diet and add in r^2 value labels 
PCAdat$Time <- mSet[["dataSet"]][["cls"]]
df <- PCAdat
row.names(df) <- paste(df$Time, row.names(df), sep="_") 
row.names(df) <- gsub('n_A', 'n A', row.names(df))
rownames(df)
df_pca <- prcomp(df[,2:(length(df)-1)])
df_out <- as.data.frame(df_pca$x)
df_out$Time <- sapply( strsplit(as.character(row.names(df)), "_"), "[[", 1 )
percentage <- round(((df_pca$sdev**2)) / sum((df_pca$sdev**2))* 100, 1)
percentage <- paste( colnames(df_out), "(", paste( as.character(percentage), "%", ")", sep="") )
theme<-theme(panel.background = element_blank(),panel.border=element_rect(fill=NA),panel.grid.major = element_blank(),panel.grid.minor = element_blank(),strip.background=element_blank(),axis.text.x=element_text(colour="black"),axis.text.y=element_text(colour="black"),axis.ticks=element_line(colour="black"),plot.margin=unit(c(1,1,1,1),"line"),)
p<- ggplot(df_out,aes(x=PC1,y=PC2,color=Time ))+
  stat_ellipse(alpha=0.15,type="norm",size =0.80, geom="polygon", linetype = 2,aes(fill = Time))+
  geom_point(shape=16, alpha=1, size=3)+ xlab(percentage[1]) + ylab(percentage[2])+ theme
# p<-p+ scale_fill_manual(values=c("#f5c4ca","#87ceeb"))+scale_color_manual(values=c("#f5c4ca","#87ceeb"))
p<-p+ scale_fill_manual(values=c("#2171b5","#238b45"))+scale_color_manual(values=c("#2171b5","#238b45"))
p+scale_x_reverse()+ theme(panel.background = element_blank())+ theme(text=element_text(family="Times New Roman", size=25))
		
#Significant (FDR) urine and plasma metabolites exported from MetaboAnalyst as csv file with metabolites and corrected p-values formatted as [1]plasma_metabolite, [2]plasma_p_val, [3]urine_metabolite, [4] urine_p_val 
s_mets <- read.csv("combined_mets_sig.csv", check.names = F, stringsAsFactors = F)
# Selecting here for plasma metabolites that are significant 
df_urine <-as.data.frame(s_mets[,1], stringsAsFactors = F)
sigmets<- as.data.frame(df_urine)
colnames(sigmets) <-(cbind("Metabolites"))
# Pulling in all values for significant metabolites above to include in heatmap
dfPla<- read.csv("all_plasma.csv", check.names = F, stringsAsFactors = FALSE)
df0 <- dfPla[,c(-2,-3)]
df <- df0[,-1]
rownames(df) <- df0[,1]
plat <- as.data.frame(t(df))
plat <- rownames_to_column(plat, "Metabolites")
metabo_sig <- merge(plat,sigmets,"Metabolites")
# Merging in Superpathway metadata for significant metabolites 
pathway_df <- read_csv("plasma_with_meta.csv")
pathway_df <- pathway_df[,1:2]
pathway_df <- pathway_df %>% rename (Metabolites = BIOCHEMICAL)
merged_path <- merge(metabo_sig,pathway_df, all.x = T )
sort_merge <- merged_path %>% arrange_at("SUPER_PATHWAY", desc)
t_merged <-  as.data.frame(t(sort_merge))
names(t_merged) <- as.matrix(t_merged[1,])
t_merged <- t_merged[cbind(-1,-36),]
t_merged <-  rownames_to_column(t_merged,"Subjects")
meta<- dfPla[,c(1:3)]
meta <- meta %>% rename(Subjects = Subject)
df_donex<- merge(meta,t_merged, "Subjects")
df_donex <- df_donex %>% arrange_at("Ethnicity", desc)
df_donex <- df_donex %>% arrange_at("Time",desc)
write_csv(df_donex,"merged_met_sig.csv")
df0 <- read.csv("merged_met_sig.csv", check.names = F,stringsAsFactors = F)

#This analysis created the heat map for urine and plasma metabolomes in each cohort as seen in Figure 5 
df0 <- read.csv("plasma_merged_met_sig.csv", check.names = F,stringsAsFactors = F)
df <- df0[,-1]
rownames(df) <- df0[,1]
dfx <- as.matrix(df[,3:length(df)])
df <- as.data.frame(df)
df$Time = factor(df$Time, levels = c("Before","After"))
col = list(Time = c("Before" = "#238b45","After" = "#2171b5"),Ethnicity = c("Black" = "#f5c4ca", "White" = "#87ceeb"))
col_fun = colorRamp2(c(0,1,2,4), c("white","violet","purple", "blue"))
ha <- HeatmapAnnotation(Time = df$Time, Ethnicity = df$Ethnicity, col=col)
dfx<- t(dfx)
ht1 <- Heatmap(dfx, name = "Abundance",top_annotation = ha, 
               col=col_fun,cluster_rows = F, cluster_columns = F,show_row_names = F,show_column_names = F)
draw(ht1, heatmap_legend_side = "left", annotation_legend_side = "bottom")

#This analysis determined the log fold change of significant metabolites and generated bar plot alongside heatmap (above) in Figure 5
urine<- df0
pre <- as.data.frame(subset(urine, urine$Time =="Before", select = c(-Time, -Ethnicity)))
rownames(pre) <-pre[,1]
pre <-pre[,-1]
premeans <- as.data.frame(colMeans(pre))
post<- subset(urine, urine$Time =="After", select = c(-Time, -Ethnicity))
rownames(post) <-post[,1]
post<-post[,-1]
postmeans <- as.data.frame(colMeans(post))
fc <- log(postmeans/premeans)
fc <- rownames_to_column(fc,"Metabolites")
matched  <- merge(fc,meta)
fc <- fc %>% rename( 'LogValue' = `colMeans(post)`)
fc_done <- merge(fc,pathway_df, "Metabolites" ) %>% arrange_at("SUPER_PATHWAY", desc)
write_csv(fc_done, "plasma_log.csv")
plot <- read.csv("plasma_log.csv", stringsAsFactors = F, check.names = F)

theme_set(theme_bw())
group.colors <- c("Amino Acid"= "#E69F00", "Cofactors and Vitamins" = "#56B4E9", "Energy" ="#009E73", "Lipid" = "#F0E442", "Nucleotide" = "#0072B2",  "Partially Characterized Molecules" = "#D55E00", "Carbohydrate" = "#66ccff", "Peptide" = "#CC79A7", "Xenobiotics" = "#999999")
plot$Class <- factor(plot$Class,levels = c("Amino Acid", "Cofactors and Vitamins", "Energy", "Lipid", "Nucleotide", "Partially Characterized Molecules", "Carbohydrate", "Peptide", "Xenobiotics"))
plot$Metabolites <- factor(plot$Metabolites, levels = plot$Metabolites[order(plot$Order)])
plot <- as.data.frame(plot)
p <- ggplot(plot,width=1) +geom_bar(aes(x=Metabolites, y=LogValue, fill=Class),stat="identity",width = 1, position = position_dodge(width = 1))+scale_fill_manual(values =group.colors)
p2<-p + theme_classic()+theme(axis.text.x = element_text(angle = 60, hjust = 1), axis.ticks = element_blank(),panel.grid.major = element_blank(),text=element_text(family="Times New Roman", size=10))
p3 <- p2+coord_flip() +theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),panel.background = element_blank(), axis.line = element_line(colour = "black"))
p3


# This pathway analysis was to determine if metabolomes differed between ethnicities at the super pathway level of composition
classes <- list("Amino Acid", "Cofactors and Vitamins", "Energy", "Lipid", "Nucleotide", "Partially Characterized Molecules", "Carbohydrate", "Peptide", "Xenobiotics")
Time <- list("Before","After")

meta_file <- "Path/to/metadata_file"
data_file <- "Path/to/data_file"

adonisResult <- NULL
adonisEthnicity <- NULL
adonisTime <- NULL

df <- read.csv(data_file, check.names = F, stringsAsFactors = FALSE)
df_meta <- read.csv(meta_file, check.names = F, stringsAsFactors = FALSE)
df_clean <- drop(df[,c(-1,-4:-13)])
dfx<- as_tibble(df_clean)  
df_t <- gather(dfx, Subjects,value, 3:length(dfx))
df_tidy <- merge(df_t,df_meta, "Subjects")
df_tidy <- rename(df_tidy,Measure=value, Metabolite =BIOCHEMICAL)

for(time in Time){ 
  for (var in classes) {
    df_spread2 <- df_tidy%>% 
      filter(SUPER_PATHWAY == var)%>%
      spread(Metabolite, Measure)
    df_edit <- within(df_spread2, rm(SUPER_PATHWAY))
    p.env <- df_edit[c(1:3)]
    pdat<-(df_edit[c(4:length(df_edit))])
    adonisResult[[var]]<- adonis2(pdat~Ethnicity, data = p.env, permutations = 999, method = distance,na.rm = T) 
    adonisEthnicity[[time]] <- adonisResult
  }
}

for (var in classes) {
  df_spread2 <- df_tidy%>% 
    filter(SUPER_PATHWAY == var)%>%
    spread(Metabolite, Measure)
  df_edit <- within(df_spread2, rm(SUPER_PATHWAY))
  p.env <- df_edit[c(1:3)]
  pdat<-(df_edit[c(4:length(df_edit))])
  adonisResult[[var]]<- adonis2(pdat~Time, data = p.env, permutations = 999, method = distance,na.rm = T) 
  adonisTime <- adonisResult
}
