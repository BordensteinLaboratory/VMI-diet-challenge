#!/bin/bash

#SBATCH --job-name=assembly
#SBATCH --mail-type=ALL
#SBATCH --mail-user=elizabeth.mallott@vanderbilt.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH	--cpus-per-task=18
#SBATCH --mem=100G
#SBATCH --time=48:00:00
#SBATCH --output=/home/mallote/assembly_year2_array_%A_%a.out
#SBATCH --error=/home/mallote/assembly_year2_array_%A_%a.err
#SBATCH --array=1-34%2

module load GCC/6.4.0-2.28 MEGAHIT/1.1.3-Python-3.6.3

project=/data/bordenstein_lab/vmi/vmi_metagenomics/year2

folder=$(ls -d ${project}/1_2_human_reads/*/ | sed -n ${SLURM_ARRAY_TASK_ID}p)
folder_name=$(basename ${folder})
echo ${folder}
echo ${folder_name}

##### CO-ASSEMBLE CONTIGS USING ALL FECAL OR ORAL SAMPLES WITHIN ONE INDIVIDUAL #####

megahit --k-list 27,37,47,57,67,77,87 -m 80000000000 -t 18 -1 $(cat ${project}/1_2_human_reads/${folder_name}/R1.csv) \
  -2 $(cat ${project}/1_2_human_reads/${folder_name}/R2.csv) --tmp-dir ${project}/1_3_contig_assembly/${folder_name}/tmp \
  -o ${project}/1_3_contig_assembly/${folder_name} --out-prefix ${folder_name} --min-contig-len 1000 --continue

#Remove intermediate files#

rm ${project}/1_2_human_reads/${folder_name}/R1.csv
rm ${project}/1_2_human_reads/${folder_name}/R2.csv

#Move trimmed and filtered reads back#

mv ${project}/1_2_human_reads/${folder_name}/*.fastq.gz ${project}/1_2_human_reads/hg38_bowtie2_mapped/

######################################################
