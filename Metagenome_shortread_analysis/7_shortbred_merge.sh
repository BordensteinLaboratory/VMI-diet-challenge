#!/bin/bash

#SBATCH --job-name=shortbred_join
#SBATCH --mail-type=ALL
#SBATCH --mail-user=elizabeth.mallott@vanderbilt.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=8G
#SBATCH --time=2:00:00
#SBATCH --output=/home/mallote/shortbred_join_combined.out
#SBATCH --error=/home/mallote/shortbred_join_combined.err

#Load modules
module purge all
module load Anaconda3

#Activate the biobakery3 environment
source activate /home/mallote/pythonenvs/biobakery3

#Set project variable
project1=/data/bordenstein_lab/vmi/vmi_metagenomics/year1_shortread
project2=/data/bordenstein_lab/vmi/vmi_metagenomics/year2/shortread
combined=/data/bordenstein_lab/vmi/vmi_metagenomics/combined_shortread

#Copy output files to single directory
mkdir ${combined}/shortbred
cp ${project1}/shortbred/*shortbred_results.tsv ${combined}/shortbred
cp ${project2}/shortbred/*shortbred_results.tsv ${combined}/shortbred

#Parse the shortbred results to make them readable to HUMAnN
for FILE in ${combined}/shortbred/*shortbred_results.tsv
do
  SAMPLEID="${FILE%_shortbred.tsv}"
  cat $FILE | cut -f1,2 > ${SAMPLEID}_shortbred_subset.tsv
done

#Use the join table script from HUMAnN to merge all samples into one file
humann_join_tables --input ${combined}/shortbred --output ${combined}/shortbred/combineds_shortbred_abundance.tsv \
  --file_name _shortbred_subset.tsv
