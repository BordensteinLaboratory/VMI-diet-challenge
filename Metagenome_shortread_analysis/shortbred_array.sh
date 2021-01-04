#!/bin/bash

#SBATCH --job-name=shortbred
#SBATCH --mail-type=ALL
#SBATCH --mail-user=elizabeth.mallott@vanderbilt.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH	--cpus-per-task=8
#SBATCH --mem=48G
#SBATCH --time=24:00:00
#SBATCH --output=/home/mallote/shortbred_agp_array_%A_%a.out
#SBATCH --error=/home/mallote/shortbred_agp_array_%A_%a.err
#SBATCH --array=1-8%4

module purge all

module load Anaconda2

source activate /home/mallote/pythonenvs/biobakery2

file=$(ls /data/bordenstein_lab/vmi/vmi_metagenomics/AGP/kneaddata/*kneaddata.fastq | sed -n ${SLURM_ARRAY_TASK_ID}p)

#seqtk seq -a ${file} > ${file} > ${file}.fa

shortbred_quantify.py --markers /data/bordenstein_lab/humann_db/ShortBRED_CARD_2017_markers.faa --wgs ${file} --results /data/bordenstein_lab/vmi/vmi_metagenomics/AGP/shortbred_results.tsv --tmp /scratch/bordenstein_lab/vmi/vmi_metagenomics/AGP/shortbred_tmp_${file} --threads 8 --usearch /home/mallote/usearch11.0.667_i86linux32




