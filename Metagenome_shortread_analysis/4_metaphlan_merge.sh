#!/bin/bash

#SBATCH --job-name=metaphlan_merge
#SBATCH --mail-type=ALL
#SBATCH --mail-user=elizabeth.mallott@vanderbilt.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=16G
#SBATCH --time=2:00:00
#SBATCH --output=/home/mallote/metaphlan_merge.out
#SBATCH --error=/home/mallote/metaphlan_merge.err

#Load modules
module purge all
module load Anaconda3

#Activate biobakery3 environment
source activate /home/mallote/pythonenvs/biobakery3

#Set variables
project=/data/bordenstein_lab/vmi/vmi_metagenomics/year2/shortread

#Move files to single subdirectory
mkdir ${project}/metaphlan

for folder in ${project}/humann_output/*/
do
  mv ${folder}*bugs_list.tsv ${project}/metaphlan
done

#Merge individual file outputs into one OTU-like taxonomy table
merge_metaphlan_tables.py ${project}/metaphlan/*  > ${project}/metaphlan/year2_merged_abundance_table.txt

#Extract species-level relative abundance table from merged merge_metaphlan_tables
grep -E "s__|clade" ${project}/metaphlan/year2_merged_abundance_table.txt | sed 's/^.*s__//g' \
  | cut -f1,3-70 | sed -e 's/clade_name/body_site/g' \
  > ${project}/metaphlan/year2_merged_abundance_table_species.txt
