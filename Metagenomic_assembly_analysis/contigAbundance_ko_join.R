library(tidyverse)
library(here)
# This script was used to map the relative abundance of a contig to the KOs present on that contig by merging the two files. 
setwd("~/Path/to/directory/with/all_contig_relative_abundance_files")
fileNames <- Sys.glob("*.txt")

#Here the KO list from each cohort mapped using KOFamScan (all_kos_cohort1.txt output file from kofamscan.sh) is split into distinct columns to allow for mapping in following loop 
ko_list <- read_tsv("~/Path/to/directory/with/KOs_assigned_to_all_coding_sequences_in each_cohort", col_names = TRUE)
ko_list <- ko_list %>% drop_na() %>% 
  separate("contig", c("contigID","contig","version"), sep = "_") %>% 
  select(-version, -contigID)

# This loops over each file containing realtive abundances of contigs per sample and joins the RA of a contig with the KOs identified on that contig producing a list of KOs with their linked abundance per sample
for (fileName in fileNames) {
  contig <- read_tsv(fileName, col_names = T)
  contig <- contig %>% 
    separate("contig", c("contigID","contig"), sep = "_") %>% 
    select(-taxid, -contigID)
  contig$sample <- sub('\\.txt$','', fileName)
  merged <- left_join(contig,ko_list, by="contig")
  KOs_with_RA_per_Sample <- paste("~/Desktop/merged_kos/",fileN,".txt", sep="")
}
