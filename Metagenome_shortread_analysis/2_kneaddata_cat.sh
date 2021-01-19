#!/bin/bash

#SBATCH --job-name=kneaddata_cat
#SBATCH --mail-type=ALL
#SBATCH --mail-user=elizabeth.mallott@vanderbilt.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH	--cpus-per-task=1
#SBATCH --mem=8G
#SBATCH --time=2:00:00
#SBATCH --output=/home/mallote/kneaddata_cat.out
#SBATCH --error=/home/mallote/kneaddata_cat.err

project=/data/bordenstein_lab/vmi/vmi_metagenomics/year2/shortread

ls ${project}/kneaddata/*_R1_kneaddata.fastq.gz > ${project}/cat.txt

for file in $(cat ${project}/cat.txt)
do
  read1="${file##*/}"
  read2=${read1%%_R1_kneaddata.fastq.gz}"_R2_kneaddata.fastq.gz"
  filename=${read1%%_R1_kneaddata.fastq.gz}""
  cat ${project}/kneaddata/${read1} ${project}/kneaddata/${read2} > ${project}/kneaddata/${filename}_cat_kneaddata.fastq.gz
  rm ${project}/kneaddata/${read1}
  rm ${project}/kneaddata/${read2}
done
