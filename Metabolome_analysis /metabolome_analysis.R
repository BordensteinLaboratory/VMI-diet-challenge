---
  title: "Metabolome Analysis"
author: "Rob Markowitz"
date: "1/25/2020"
output: html_document
fig_width: 5

library(tidyverse)
library(readxl)
library(broom)
library(knitr)
library(vegan)
classes <- list("Amino Acid", "Cofactors and Vitamins", "Energy", "Lipid", "Nucleotide", "Partially Characterized Molecules", "Carbohydrate", "Peptide", "Xenobiotics")
Time <- list("Before","After")
adonisResult <- NULL
adonisEthnicity <- NULL
adonisTime <- NULL
meta_file <- 
  data_file <-
  ####Data Cleaning####
df <- read.csv(data_file, check.names = F, stringsAsFactors = FALSE)
df_meta <- read.csv(meta_file, check.names = F, stringsAsFactors = FALSE)
df_clean <- drop(df[,c(-1,-4:-13)])
dfx<- as_tibble(df_clean)  
df_t <- gather(dfx, Subjects,value, 3:length(dfx))
df_tidy <- merge(df_t,df_meta, "Subjects")
df_tidy <- rename(df_tidy,Measure=value, Metabolite =BIOCHEMICAL)

####Ethnicity#####
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

#Diet
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