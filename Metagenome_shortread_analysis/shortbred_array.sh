#!/bin/bash

#SBATCH --job-name=shortbred
#SBATCH --mail-type=ALL
#SBATCH --mail-user=elizabeth.mallott@vanderbilt.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH	--cpus-per-task=8
#SBATCH --mem=48G
#SBATCH --time=4:00:00
#SBATCH --output=/home/mallote/shortbred_year2_array_%A_%a.out
#SBATCH --error=/home/mallote/shortbred_year2_array_%A_%a.err
#SBATCH --array=1-164%10

module purge all

module load Anaconda2

source activate /home/mallote/pythonenvs/shortbred

file=$(ls /data/bordenstein_lab/vmi/vmi_metagenomics/year2/shortread/kneaddata/*kneaddata.fastq.gz | sed -n ${SLURM_ARRAY_TASK_ID}p)

shortbred_quantify.py --markers /data/bordenstein_lab/humann_db/ShortBRED_CARD_2017_markers.faa --wgs ${file} \
  --results ${file}_shortbred_results.tsv --threads 8 --usearch /home/mallote/usearch11.0.667_i86linux32

mv ${file}_shortbred_results.tsv /data/bordenstein_lab/vmi/vmi_metagenomics/year2/shortread/shortbred
