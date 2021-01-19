#!/bin/bash

#SBATCH --job-name=humann_join
#SBATCH --mail-type=all
#SBATCH --mail-user=elizabeth.mallott@vanderbilt.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=64G
#SBATCH --time=2:00:00
#SBATCH --output=/home/mallote/humann_join_year2.out
#SBATCH --error=/home/mallote/humann_join_year2.err

#Load modules
module purge all
module load Anaconda3

#Activate biobakery3 environment
source activate /home/mallote/pythonenvs/biobakery3

#Set variables
project=/data/bordenstein_lab/vmi/vmi_metagenomics/year2/shortread

#Merge gene family tables
humann_join_tables --input ${project}/humann_output --output ${project}/humann_output/year2_genefamilies.tsv \
  --file_name genefamilies

#Merge pathway abundance tables
humann_join_tables --input ${project}/humann_output --output ${project}/humann_output/year2_pathabundance.tsv \
  --file_name pathabundance

#Normalize raw gene table to copies per million
humann_renorm_table --input ${project}/humann_output/year2_genefamilies.tsv \
  --output ${project}/humann_output/year2_genefamilies_cpm.tsv --units cpm

#Normalize raw pathway abundance table to relative abundance
humann_renorm_table --input ${project}/humann_output/year2_pathabundance.tsv \
  --output ${project}/humann_output/year2_pathabundance_relab.tsv --units relab

#Split into stratified and unstratified normalized raw gene and pathway abundance tables
humann_split_stratified_table --input ${project}/humann_output/year2_genefamilies_cpm.tsv \
  --output ${project}/humann_output/year2_genefamilies_cpm
humann_split_stratified_table --input ${project}/humann_output/year2_pathabundance_relab.tsv \
  --output ${project}/humann_output/year2_pathabundance_relab

#Regroup gene family table into KEGG orthologs, normalize, and split into stratified/unstratified tables
humann_regroup_table --input ${project}/humann_output/year2_genefamilies.tsv --groups uniref90_ko  \
  --output ${project}/humann_output/year2_genefamilies_ko.tsv

humann_renorm_table --input ${project}/humann_output/year2_genefamilies_ko.tsv \
  --output ${project}/humann_output/year2_genefamilies_ko_cpm.tsv --units cpm

humann_split_stratified_table --input ${project}/humann_output/year2_genefamilies_ko_cpm.tsv \
  --output ${project}/humann_output/year2_genefamilies_ko_cpm

#Regroup gene family table into COGs, normalize, and split into stratified/unstratified tables
humann_regroup_table --input ${project}/humann_output/year2_genefamilies.tsv --groups uniref90_eggnog  \
  --output ${project}/year2_genefamilies_cog.tsv

humann_renorm_table --input ${project}/humann_output/year2_genefamilies_cog.tsv \
  --output ${project}/humann_output/year2_genefamilies_cog_cpm.tsv --units cpm

humann_split_stratified_table --input ${project}/humann_output/year2_genefamilies_cog_cpm.tsv \
  --output ${project}/humann_output/year2_genefamilies_cog_cpm
