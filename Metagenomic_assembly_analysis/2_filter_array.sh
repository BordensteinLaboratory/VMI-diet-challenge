#!/bin/bash

#SBATCH --job-name=filter
#SBATCH --mail-type=ALL
#SBATCH --mail-user=elizabeth.mallott@vanderbilt.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH	--cpus-per-task=12
#SBATCH --mem=24G
#SBATCH --time=2:00:00
#SBATCH --output=/home/mallote/filter_year2_array_%A_%a.out
#SBATCH --error=/home/mallote/filter_year2_array_%A_%a.err
#SBATCH --array=1-162%5

module purge all

module load GCC/6.4.0-2.28 Bowtie2/2.3.4.1 SAMtools/1.6 BEDTools/2.27.1

project=/data/bordenstein_lab/vmi/vmi_metagenomics/year2

file1=$(ls ${project}/1_2_trimmed_reads/*_R1_val_1.fq.gz | sed -n ${SLURM_ARRAY_TASK_ID}p)

### EXTRACT SEQUENCE FILES ###
fread="${file1##*/}"
rread=${fread%%_R1_val_1.fq.gz}"_R2_val_2.fq.gz"
filename=${fread%%_R1_val_1.fq.gz}""
echo "###################################################################"
date '+%A %W %Y %X'
echo "########## ACTING ON FILES ##########"
echo "$fread"
echo "$rread"
echo "$filename"

### ALIGN TO HUMAN GENOME ###
echo "########## ALIGNING TO HUMAN GENOME ##########"
date '+%A %W %Y %X'
bowtie2 -x /data/bordenstein_lab/vmi/vmi_metagenomics/src/hg38_bowtie2_index/hg38_index -1 ${project}/1_2_trimmed_reads/${fread} -2 ${project}/1_2_trimmed_reads/${rread} -p 12 -S ${project}/1_2_human_reads/hg38_bowtie2_mapped/${filename}.sam

### CONVERT SAM TO BAM ALIGNMENT FORMAT ###
echo "########## CONVERTING SAM TO BAM ##########"
date '+%A %W %Y %X'
samtools view -bS ${project}/1_2_human_reads/hg38_bowtie2_mapped/${filename}.sam > ${project}/1_2_human_reads/hg38_bowtie2_mapped/${filename}.bam -@ 12

### EXTRACT ALIGNMENTS WITH BOTH READS UNMAPPED TO HUMAN GENOME ###
echo "########## EXTRACT UNMAPPED READS ##########"
date '+%A %W %Y %X'
samtools view -b -f 12 -F 256 ${project}/1_2_human_reads/hg38_bowtie2_mapped/${filename}.bam > ${project}/1_2_human_reads/hg38_bowtie2_mapped/${filename}.filtered.bam -@ 12

### SORT SEQUENCES BY NAME FOR SORTING FORWARD AND REVERSE ###
echo "########## SORTING BY NAME ##########"
date '+%A %W %Y %X'
samtools sort -n ${project}/1_2_human_reads/hg38_bowtie2_mapped/${filename}.filtered.bam -o ${project}/1_2_human_reads/hg38_bowtie2_mapped/${filename}.filtered.sorted.bam -@ 12 -m 4G

### SPLIT FILTERED SEQUENCES BACK INTO FORWARD AND REVERSE FASTQ FILES ###
echo "########## ALIGNING BACK INTO FASTQ FILES ##########"
date '+%A %W %Y %X'
bedtools bamtofastq -i ${project}/1_2_human_reads/hg38_bowtie2_mapped/${filename}.filtered.sorted.bam -fq ${project}/1_2_human_reads/hg38_bowtie2_mapped/${filename}.R1.fastq -fq2 ${project}/1_2_human_reads/hg38_bowtie2_mapped/${filename}.R2.fastq

### REMOVE INTERMEDIATE FILES ###
echo "########## REMOVE INTERMEDIATE FILES ##########"
date '+%A %W %Y %X'
rm ${project}/1_2_human_reads/hg38_bowtie2_mapped/${filename}.sam
rm ${project}/1_2_human_reads/hg38_bowtie2_mapped/${filename}.filtered.bam
rm ${project}/1_2_human_reads/hg38_bowtie2_mapped/${filename}.filtered.sorted.bam

### COMPRESS FASTQ FILES AND REMOVE RAW VERSIONS FOR SPACE ###
gzip ${project}/1_2_human_reads/hg38_bowtie2_mapped/${filename}.R1.fastq
gzip ${project}/1_2_human_reads/hg38_bowtie2_mapped/${filename}.R2.fastq
#rm ${project}/1_2_human_reads/hg38_bowtie2_mapped/${filename}.R1.fastq
#rm ${project}/1_2_human_reads/hg38_bowtie2_mapped/${filename}.R2.fastq
