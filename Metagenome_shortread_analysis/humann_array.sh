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

module purge all

module load Anaconda3

source activate /home/mallote/pythonenvs/biobakery3

file=$(ls /data/bordenstein_lab/vmi/vmi_metagenomics/year2/shortread/kneaddata/*cat_kneaddata.fastq.gz | sed -n ${SLURM_ARRAY_TASK_ID}p)

humann --resume --input ${file} --output /data/bordenstein_lab/vmi/vmi_metagenomics/year2/shortread/humann_output/ \
  --threads 8 --nucleotide-database /data/bordenstein_lab/humann_db/chocophlan \
  --protein-database /data/bordenstein_lab/humann_db/uniref --metaphlan-options "--bowtie2db /data/bordenstein_lab/humann_db"
