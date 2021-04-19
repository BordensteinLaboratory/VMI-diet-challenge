#!/bin/bash

#SBATCH --job-name=humann_join
#SBATCH --mail-type=all
#SBATCH --mail-user=elizabeth.mallott@vanderbilt.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=64G
#SBATCH --time=12:00:00
#SBATCH --output=/home/mallote/humann_join_years.out
#SBATCH --error=/home/mallote/humann_join_years.err

#Load modules
module purge all
module load Anaconda3

#Activate biobakery3 environment
source activate /home/mallote/pythonenvs/biobakery3

#Set variables
mkdir /data/bordenstein_lab/vmi/vmi_metagenomics/combined_shortread/

project2=/data/bordenstein_lab/vmi/vmi_metagenomics/year2/shortread
project1=/data/bordenstein_lab/vmi/vmi_metagenomics/year1_shortread
combined=/data/bordenstein_lab/vmi/vmi_metagenomics

#Merge taxonomy tables from year1 and year2
mkdir ${combined}/metaphlan

cp ${project1}/metaphlan/year1_merged_abundance_table.txt ${combined}/metaphlan
cp ${project2}/metaphlan/year2_merged_abundance_table.txt ${combined}/metaphlan

merge_metaphlan_tables.py ${combined}/metaphlan/*.txt > ${combined}/metaphlan/combined_merged_abundance_table.txt

#Extract species-level relative abundance table from merged merge_metaphlan_tables
grep -E "s__|clade" ${combined}/metaphlan/combined_merged_abundance_table.txt | sed 's/^.*s__//g' \
  | cut -f1,3-70 | sed -e 's/clade_name/body_site/g' \
  > ${combined}/metaphlan/combined_merged_abundance_table_species.txt

#Merge gene family tables
mkdir ${combined}/humann

cp ${project1}/humann_output/year1_genefamilies.tsv ${combined}/humann
cp ${project2}/humann_output/year2_genefamilies.tsv ${combined}/humann

humann_join_tables --input ${combined}/humann --output ${combined}/humann/combined_genefamilies.tsv \
  --file_name genefamilies

#Merge pathway abundance tables
humann_join_tables --input ${combined}/humann --output ${combined}/humann/combined_pathabundance.tsv \
  --file_name pathabundance

#Regroup gene family table into KEGG orthologs, normalize, and split into stratified/unstratified tables
humann_regroup_table --input ${combined}/humann/combined_genefamilies.tsv --groups uniref90_ko  \
  --output ${combined}/humann/combined_genefamilies_ko.tsv

humann_renorm_table --input ${combined}/humann/combined_genefamilies_ko.tsv \
  --output ${combined}/humann/combined_genefamilies_ko_cpm.tsv --units cpm

humann_split_stratified_table --input ${combined}/humann/combined_genefamilies_ko_cpm.tsv \
  --output ${combined}/humann/combined_genefamilies_ko_cpm

#Regroup gene family table into COGs, normalize, and split into stratified/unstratified tables
humann_regroup_table --input ${combined}/humann/combined_genefamilies.tsv --groups uniref90_eggnog  \
  --output ${combined}/humann/combined_genefamilies_cog.tsv

humann_renorm_table --input ${combined}/humann/combined_genefamilies_cog.tsv \
  --output ${combined}/humann/combined_genefamilies_cog_cpm.tsv --units cpm

humann_split_stratified_table --input ${combined}/humann/combined_genefamilies_cog_cpm.tsv \
  --output ${combined}/humann/combined_genefamilies_cog_cpm

#Normalize raw gene table to copies per million
humann_renorm_table --input ${combined}/humann/combined_genefamilies.tsv \
  --output ${combined}/humann/combined_genefamilies_cpm.tsv --units cpm

#Normalize raw pathway abundance table to relative abundance
humann_renorm_table --input ${combined}/humann/combined_pathabundance.tsv \
  --output ${combined}/humann/combined_pathabundance_relab.tsv --units relab

#Split into stratified and unstratified normalized raw gene and pathway abundance tables
humann_split_stratified_table --input ${combined}/humann/combined_genefamilies_cpm.tsv \
  --output ${combined}/humann/combined_genefamilies_cpm
humann_split_stratified_table --input ${combined}/humann/combined_pathabundance_relab.tsv \
  --output ${combined}/humann/combined_pathabundance_relab
