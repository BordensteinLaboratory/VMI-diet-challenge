#!/bin/bash

#SBATCH --job-name=kneaddata
#SBATCH --mail-type=ALL
#SBATCH --mail-user=elizabeth.mallott@vanderbilt.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH	--cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=24:00:00
#SBATCH --output=/home/mallote/kneaddata_hmp_array_%A_%a.out
#SBATCH --error=/home/mallote/kneaddata_hmp_array_%A_%a.err
#SBATCH --array=1-95%5

module purge all

module load Anaconda2/5.0.1

source activate /home/mallote/pythonenvs/biobakery2

file=$(ls /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/*1.fastq.gz | sed -n ${SLURM_ARRAY_TASK_ID}p)

kneaddata --input ${file} --threads 8 --reference-db /data/bordenstein_lab/humann_db/hg37dec_v0.1 --output /scratch/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/kneaddata


