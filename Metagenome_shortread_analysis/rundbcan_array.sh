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

#Set array task variable
file=$(ls /data/bordenstein_lab/vmi/vmi_metagenomics/year2/shortread/kneaddata/*kneaddata.fastq.gz | sed -n ${SLURM_ARRAY_TASK_ID}p)

#Create filename variable
filebase="$(basename -- $file)"

#Convert file from fastq to fasta
seqtk seq -a ${file} > ${file}.fa

#Run hmmer-based dbcan
run_dbcan.py ${file}.fa meta -t hmmer --tf_cpu 11 --db_dir /data/bordenstein_lab/humann_db \
  --out_dir /data/bordenstein_lab/vmi/vmi_metagenomics/year2/shortread/cazymes/${filebase}

#Clean up intermediate files
rm /data/bordenstein_lab/vmi/vmi_metagenomics/AGP/caz_output/${filebase}/prodigal.gff
rm /data/bordenstein_lab/vmi/vmi_metagenomics/AGP/caz_output/${filebase}/UniInput
rm ${file}.fa
