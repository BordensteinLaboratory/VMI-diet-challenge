#!/bin/bash

#SBATCH --job-name=kneaddata
#SBATCH --mail-type=ALL
#SBATCH --mail-user=elizabeth.mallott@vanderbilt.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH	--cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=24:00:00
#SBATCH --output=/home/mallote/kneaddata_year2_array_%A_%a.out
#SBATCH --error=/home/mallote/kneaddata_year2_array_%A_%a.err
#SBATCH --array=1-328%5

module purge all

module load GCC/6.4.0-2.28 Python/2.7.14 Bowtie2/2.3.4.1 Java/11.0.2

source /home/mallote/biobakery2/bin/activate
export PATH=$PATH:/home/mallote/biobakery2/bin
export PATH=$PATH:/home/mallote/trimmomatic
export PATH=$PATH:/home/mallote/trf

file=$(ls /data/bordenstein_lab/vmi/vmi_metagenomics/year2/1_raw/*.fastq.gz | sed -n ${SLURM_ARRAY_TASK_ID}p)
read="${file##*/}"
filename=${read%%.fastq.gz}""

echo ${filename}
date '+%A %W %Y %X'

kneaddata --input ${file} --threads 8 --reference-db /data/bordenstein_lab/humann_db/hg37dec_v0.1 --trimmomatic /home/mallote/trimmomatic --trf /home/mallote/trf --output /data/bordenstein_lab/vmi/vmi_metagenomics/year2/shortread/kneaddata

rm /data/bordenstein_lab/vmi/vmi_metagenomics/year2/shortread/kneaddata/${filename}_kneaddata.trimmed.fastq
rm /data/bordenstein_lab/vmi/vmi_metagenomics/year2/shortread/kneaddata/${filename}_kneaddata_hg37dec_v0.1_bowtie2_contam.fastq
rm /data/bordenstein_lab/vmi/vmi_metagenomics/year2/shortread/kneaddata/${filename}_kneaddata.repeats.removed.fastq

gzip /data/bordenstein_lab/vmi/vmi_metagenomics/year2/shortread/kneaddata/${filename}_kneaddata.fastq
