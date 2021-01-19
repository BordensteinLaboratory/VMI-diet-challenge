#!/bin/bash

#SBATCH --job-name=hmmer
#SBATCH --mail-type=ALL
#SBATCH --mail-user=elizabeth.mallott@vanderbilt.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH	--cpus-per-task=12
#SBATCH --mem=64G
#SBATCH --time=120:00:00
#SBATCH --output=/home/mallote/hmmer2_year2_array_%A_%a.out
#SBATCH --error=/home/mallote/hmmer2_year2_array_%A_%a.err
#SBATCH --array=1-164%8

#Load modules
module purge all
module load Anaconda3

#Activate virtual environment
source activate /home/mallote/pythonenvs/run_dbcan

#Set project and array task variable
project=/data/bordenstein_lab/vmi/vmi_metagenomics/year2/shortread
file=$(ls ${project}/kneaddata/*kneaddata.fastq.gz | sed -n ${SLURM_ARRAY_TASK_ID}p)

#Create filename variable
filebase="$(basename -- $file)"

#Convert file from fastq to fasta
seqtk seq -a ${file} > ${file}.fa

#Run hmmer-based dbcan
run_dbcan.py ${file}.fa meta -t hmmer --tf_cpu 11 --db_dir /data/bordenstein_lab/humann_db \
  --out_dir ${project}/cazymes/${filebase}

#Clean up intermediate files
rm ${project}/cazymes/${filebase}/prodigal.gff
rm ${project}/cazymes/${filebase}/UniInput
rm ${file}.fa
