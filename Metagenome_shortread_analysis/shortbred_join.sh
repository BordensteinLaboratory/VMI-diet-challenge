#!/bin/bash

#SBATCH --job-name=shortbred_join
#SBATCH --mail-type=ALL
#SBATCH --mail-user=elizabeth.mallott@vanderbilt.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=8G
#SBATCH --time=2:00:00
#SBATCH --output=/home/mallote/shortbred_join_agp.out
#SBATCH --error=/home/mallote/shortbred_join_agp.err

module purge all

module load Anaconda3

source activate /home/mallote/pythonenvs/biobakery3

for FILE in /data/bordenstein_lab/vmi/vmi_metagenomics/AGP/shortbred/*shortbred_results.tsv
do
  SAMPLEID="${FILE%_shortbred.tsv}"
  cat $FILE | cut -f1,2 > ${SAMPLEID}_shortbred_subset.tsv
done

humann_join_tables --input /data/bordenstein_lab/vmi/vmi_metagenomics/AGP/shortbred/ --output /data/bordenstein_lab/vmi/vmi_metagenomics/AGP/shortbred/all_shortbred_abundance.tsv --file_name _shortbred_subset.tsv

