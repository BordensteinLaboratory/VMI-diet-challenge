#!/bin/bash

#SBATCH --job-name=humann_join
#SBATCH --mail-type=all
#SBATCH --mail-user=elizabeth.mallott@vanderbilt.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=64G
#SBATCH --time=12:00:00
#SBATCH --output=/home/mallote/humann_join_hmp.out
#SBATCH --error=/home/mallote/humann_join_hmp.err

module purge all

module load Anaconda3

source activate /data/bordenstein_lab/pythonenvs/biobakery3

#humann_join_tables --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies.tsv --file_name genefamilies

#humann_join_tables --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_pathabundance.tsv --file_name pathabundance

#humann_renorm_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_cpm.tsv --units cpm

#humann_renorm_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_pathabundance.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_pathabundance_relab.tsv --units relab

#humann_split_stratified_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_cpm.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_cpm

#humann_split_stratified_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_pathabundance_relab.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_pathabundance_relab

#humann_regroup_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies.tsv --groups uniref90_ko  --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_ko.tsv

#humann_renorm_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_ko.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_ko_cpm.tsv --units cpm

#humann_split_stratified_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_ko_cpm.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_ko_cpm

#humann_split_stratified_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_ko.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_ko

#humann_regroup_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies.tsv --groups uniref90_eggnog  --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_cog.tsv

#humann_renorm_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_cog.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_cog_cpm.tsv --units cpm

#humann_split_stratified_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_cog_cpm.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_cog_cpm

#humann_split_stratified_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_cog.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_cog

#humann_join_tables --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies.tsv --file_name genefamilies

#humann_join_tables --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_pathabundance.tsv --file_name pathabundance

#humann_renorm_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_cpm.tsv --units cpm

#humann_renorm_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_pathabundance.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_pathabundance_relab.tsv --units relab

#humann_split_stratified_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_cpm.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_cpm

#humann_split_stratified_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_pathabundance_relab.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_pathabundance_relab

#humann_regroup_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies.tsv --groups uniref90_ko  --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_ko.tsv

#humann_renorm_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_ko.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_ko_cpm.tsv --units cpm

#humann_split_stratified_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_ko_cpm.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_ko_cpm

#humann_split_stratified_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/gw/humann_output/gw_genefamilies_ko.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/gw/humann_output/gw_genefamilies_ko

#humann_regroup_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies.tsv --groups uniref90_eggnog  --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_cog.tsv

#humann_renorm_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_cog.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_cog_cpm.tsv --units cpm

#humann_split_stratified_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_cog_cpm.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_cog_cpm

#humann_split_stratified_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/gw/humann_output/gw_genefamilies_cog.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/gw/humann_output/gw_genefamilies_cog

#humann_join_tables --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_pathabundance.tsv --file_name pathabundance

#humann_join_tables --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_pathabundance.tsv --file_name pathabundance

#humann_renorm_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_cpm.tsv --units cpm

#humann_renorm_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_pathabundance.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_pathabundance_relab.tsv --units relab

#humann_split_stratified_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_cpm.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_cpm

#humann_split_stratified_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_pathabundance_relab.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_pathabundance_relab

#humann_regroup_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies.tsv --groups uniref90_ko  --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_ko.tsv

#humann_renorm_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_ko.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_ko_cpm.tsv --units cpm

#humann_split_stratified_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_ko_cpm.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_ko_cpm

#humann_split_stratified_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/AGP/humann_output/agp_genefamilies_ko.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/AGP/humann_output/agp_genefamilies_ko

#humann_regroup_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies.tsv --groups uniref90_eggnog  --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_cog.tsv

#humann_renorm_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_cog.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_cog_cpm.tsv --units cpm

#humann_split_stratified_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_cog_cpm.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_cog_cpm

#humann_split_stratified_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/AGP/humann_output/agp_genefamilies_cog.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/AGP/humann_output/agp_genefamilies_cog

#mkdir /data/bordenstein_lab/vmi/vmi_metagenomics/validation/combined
cp /data/bordenstein_lab/vmi/vmi_metagenomics/AGP/humann_output/agp_genefamilies_ko.tsv /data/bordenstein_lab/vmi/vmi_metagenomics/validation/combined
cp /data/bordenstein_lab/vmi/vmi_metagenomics/gw/humann_output/gw_genefamilies_ko.tsv /data/bordenstein_lab/vmi/vmi_metagenomics/validation/combined
cp /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_ko.tsv /data/bordenstein_lab/vmi/vmi_metagenomics/validation/combined
cp /data/bordenstein_lab/vmi/vmi_metagenomics/AGP/humann_output/agp_genefamilies_cog.tsv /data/bordenstein_lab/vmi/vmi_metagenomics/validation/combined
cp /data/bordenstein_lab/vmi/vmi_metagenomics/gw/humann_output/gw_genefamilies_cog.tsv /data/bordenstein_lab/vmi/vmi_metagenomics/validation/combined
cp /data/bordenstein_lab/vmi/vmi_metagenomics/validation/hmp/humann/hmp_genefamilies_cog.tsv /data/bordenstein_lab/vmi/vmi_metagenomics/validation/combined

humann_join_tables --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/combined/ --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/combined/combined_genefamilies_ko.tsv --file_name ko
humann_join_tables --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/combined/ --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/combined_genefamilies_cog.tsv --file_name cog

humann_split_stratified_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/combined/combined_genefamilies_ko.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/combined
humann_split_stratified_table --input /data/bordenstein_lab/vmi/vmi_metagenomics/validation/combined/combined_genefamilies_cog.tsv --output /data/bordenstein_lab/vmi/vmi_metagenomics/validation/combined
