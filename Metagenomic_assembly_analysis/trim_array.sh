#!/bin/bash

#SBATCH --job-name=trimgalore
#SBATCH --mail-type=ALL
#SBATCH --mail-user=elizabeth.mallott@vanderbilt.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH	--cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --time=2:00:00
#SBATCH --output=/home/mallote/trimgalore_array_%A_%a.out
#SBATCH --error=/home/mallote/trimgalore_array_%A_%a.err
#SBATCH --array=1-191%10

module purge all

module load GCC/6.4.0-2.28 cutadapt/1.16-Python-3.6.3

module load Java/11.0.2

export PATH=$PATH:/home/mallote/FastQC

file1=$(ls /data/bordenstein_lab/vmi/vmi_metagenomics/year2/1_raw/*R1.fastq.gz | sed -n ${SLURM_ARRAY_TASK_ID}p)
file2=${file1%%_R1.fastq.gz}"_R2.fastq.gz"

project=/data/bordenstein_lab/vmi/vmi_metagenomics/year2

mkdir ${project}/1_2_trimmed_reads
chmod g+w ${project}/1_2_trimmed_reads
chmod a+rw ${project}/1_2_trimmed_reads

/home/mallote/TrimGalore-0.6.6/trim_galore --paired --length 20 --q 20 --fastqc --output_dir ${project}/1_2_trimmed_reads $file1 $file2

trimmed_seqs=${project}/1_2_trimmed_reads

mkdir ${trimmed_seqs}/forward
mkdir ${trimmed_seqs}/reverse
mv ${trimmed_seqs}/*R1_val_1.fq.gz ${trimmed_seqs}/forward
mv ${trimmed_seqs}/*R2_val_2.fq.gz ${trimmed_seqs}/reverse
