#!/bin/bash

#SBATCH --job-name=humann
#SBATCH --mail-type=ALL
#SBATCH --mail-user=elizabeth.mallott@vanderbilt.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH	--cpus-per-task=8
#SBATCH --mem=48G
#SBATCH --time=100:00:00
#SBATCH --output=/home/mallote/humann_year2_array_%A_%a.out
#SBATCH --error=/home/mallote/humann_year2_array_%A_%a.err
#SBATCH --array=1-164%10

#Load modules
module purge all
module load Anaconda3

#Activate biobakery3 environment
source activate /home/mallote/pythonenvs/biobakery3

#Set project and array task variables
project=/data/bordenstein_lab/vmi/vmi_metagenomics/year2/shortread
file=$(ls ${project}/kneaddata/*cat_kneaddata.fastq.gz | sed -n ${SLURM_ARRAY_TASK_ID}p)

#Run humann, specifying the location of the nucleotide, protein, and metaphlan databases
#Uniref90 was used for this analysis
humann --resume --input ${file} --output ${project}/humann_output/ \
  --threads 8 --nucleotide-database /data/bordenstein_lab/humann_db/chocophlan \
  --protein-database /data/bordenstein_lab/humann_db/uniref \
  --metaphlan-options "--bowtie2db /data/bordenstein_lab/humann_db"
